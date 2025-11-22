module Vocabulary.WordType

import Derive.Finite
import Derive.Prelude

%default total
%language ElabReflection

public export
data WordType : Type where
  Adjective : WordType
  Noun      : WordType
  Verb      : WordType

%runElab derive "WordType" [Show,Eq,Ord,Finite]

export %inline
Interpolation WordType where
  interpolate = show
