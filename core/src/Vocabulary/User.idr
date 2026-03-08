module Vocabulary.User

import Derive.Finite
import Derive.Prelude
import Vocabulary.Language

%default total
%language ElabReflection

public export
data UserField : Type where
  USID       : UserField
  USName     : UserField
  USEmail    : UserField
  USPassword : UserField

%runElab derive "UserField" [Show,Eq,Ord,Finite]

public export
record User (f : UserField -> Type) where
  constructor MkUser
  nr       : f USID
  name     : f USName
  email    : f USEmail
  password : f USPassword
