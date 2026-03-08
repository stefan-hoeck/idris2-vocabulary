module Vocabulary.Language

import Derive.Finite
import Derive.Prelude

%default total
%language ElabReflection

public export
data Language : Type where
  English  : Language
  French   : Language
  German   : Language
  Latin    : Language
  Spanish  : Language

%runElab derive "Language" [Show,Eq,Ord,Finite]
