module Vocabulary.Word

import Derive.Barbie
import Derive.Finite
import Derive.Prelude
import Control.Barbie

%default total
%language ElabReflection

public export
data WordField : Type where
  WID          : WordField
  WWord        : WordField
  WUnit        : WordField
  WType        : WordField
  WTranslation : WordField

%runElab derive "WordField" [Show,Eq,Ord,Finite]

public export
record WordB (f : WordField -> Type) where
  constructor MkWord
  nr          : f WID
  unit        : f WUnit
  type        : f WType
  word        : f WWord
  translation : f WTranslation

-- %runElab derive "WordB"
