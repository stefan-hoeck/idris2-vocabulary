module Vocabulary.Opts

import Data.FilePath
import Data.Vect
import HTTP.API.Server
import Monocle
import IO.Async.Console
import IO.Async.Logging
import Network.SCGI.Config as S
import System.Clock
import System.GetOpts
import Text.Crypt

%default total
%language ElabReflection

public export
record VociConfig where
  [noHints]
  constructor VC
  ||| Path to the data directory
  dataPath  : Path Abs

  ||| Basic logger used for logging
  baseLogger : HTTPLogger

  ||| Level used for logging
  level      : LogLevel

  ||| SCGI config
  config     : S.Config

  ||| Time of inactivity after which a session token expires
  expireAfter : Clock Duration

  ||| Method used for hashing a logged in user's name when generating
  ||| the session token
  hashMethod : CryptMethod

  ||| Cost for hashing a loggend in user's name when generating
  ||| the session token.
  hashCost   : Bits32

  {auto 0 inRange : InRange hashMethod hashCost}

configL : Lens' VociConfig S.Config
configL = lens config (\x => {config := x})

export
vociConfig : (out : ConsoleOut Poll) => VociConfig
vociConfig =
  VC {
      dataPath    = "/data/vocabulary"
    , baseLogger  = colorConsoleLogger out
    , level       = Info
    , config      = {port := 8000} local
    , expireAfter = fromNano 14_400_000_000_000 -- four hours
    , hashMethod  = SHA512Crypt
    , hashCost    = 1000
    }

export
vociLogger : VociConfig -> HTTPLogger
vociLogger c = filter c.level c.baseLogger

--------------------------------------------------------------------------------
-- Server Config
--------------------------------------------------------------------------------

parameters {auto cons : ConsoleOut Poll}

  %inline
  setPort, setAddress, setLogger, setLevel : String -> VociConfig -> VociConfig
  setPort s = over configL {port := cast s}

  setAddress s =
    case forget $ String.split ('.' ==) s of
      [a,b,c,d] => over configL {address := map cast [a,b,c,d]}
      _         => id

  setLogger "stdout" = {baseLogger := colorConsoleLogger cons}
  setLogger "syslog" = {baseLogger := syslogLogger cons}
  setLogger _        = id

  setLevel "trace" = {level := Trace}
  setLevel "debug" = {level := Debug}
  setLevel "info"  = {level := Info}
  setLevel "warn"  = {level := Warn}
  setLevel "error" = {level := Error}
  setLevel "fatal" = {level := Fatal}
  setLevel _       = id

  setDatadir : String -> VociConfig -> VociConfig
  setDatadir s c = maybe c setPth $ AbsPath.parse s
    where
      setPth : Path Abs -> VociConfig
      setPth x = {dataPath := x} c

  export
  serverOpts : List (OptDescr (VociConfig -> VociConfig))
  serverOpts =
    [ MkOpt ['p'] ["port"]   (ReqArg setPort "<port>")
        """
        Sets the port to be used by the server.
        The default is 8000.
        """
    , MkOpt ['a'] ["address"]   (ReqArg setAddress "<address>")
        """
        Sets the address to be used by the server.
        This defaults to "0.0.0.0"
        """
    , MkOpt [] ["logger"]   (ReqArg setLogger "stdout | syslog")
        """
        Sets the logger to be used by the server.
        Possible values are "stdout", which prints colorized log messaged
        to standard output, and "syslog", which converts log levels to
        syslog log levels.

        The default is stdout.
        """
    , MkOpt [] ["level"]   (ReqArg setLevel "trace | debug | info | warn | error")
        """
        Sets the log level.
        The default is "info".
        """
    , MkOpt [] ["debug"]   (NoArg $ setLevel "debug")
        "This is an alias for `--level debug`"
    , MkOpt ['d'] ["datadir"]   (ReqArg setDatadir "<directory>")
        """
        Sets the directory where CyBy will look for its data.
        The default is "/data/vocabulary".
        """
    ]
