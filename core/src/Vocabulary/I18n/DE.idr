module Vocabulary.I18n.DE

import Vocabulary.I18n

%default total
%language ElabReflection

export
VLocal where
  gender Masculine = "maskulin"
  gender Feminine = "feminin"
  gender Neuter = "neutrum"

  language English = "Englisch"
  language French = "Französisch"
  language German = "Deutsch"
  language Latin = "Latein"
  language Spanish = "Spanisch"

  wordType Adjective = "Adjektiv"
  wordType Noun = "Nomen"
  wordType Verb = "Verb"
