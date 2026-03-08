module Vocabulary.Gender

import Derive.Finite
import Derive.Prelude

%default total
%language ElabReflection

public export
data Gender : Type where
  Masculine : Gender
  Feminine  : Gender
  Neuter    : Gender

%runElab derive "Gender" [Show,Eq,Ord,Finite]

export %inline
Interpolation Gender where
  interpolate = toLower . show
