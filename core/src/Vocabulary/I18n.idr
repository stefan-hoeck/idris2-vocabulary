module Vocabulary.I18n

import public Vocabulary.Gender
import public Vocabulary.Language
import public Vocabulary.WordType

%default total

public export
interface VLocal where
  constructor MkVLocal
  gender   : Gender -> String
  language : Language -> String
  wordType : WordType -> String
