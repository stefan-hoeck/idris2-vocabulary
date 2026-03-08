module Vocabulary.Unit

import Derive.Finite
import Derive.Prelude
import Vocabulary.Language

%default total
%language ElabReflection

public export
data UnitField : Type where
  UID   : UnitField
  UName : UnitField
  UFrom : UnitField
  UTo   : UnitField

%runElab derive "UnitField" [Show,Eq,Ord,Finite]

public export
record VUnit (f : UnitField -> Type) where
  constructor MkVUnit
  nr   : f UID
  name : f UName
  from : f UFrom
  to   : f UTo
