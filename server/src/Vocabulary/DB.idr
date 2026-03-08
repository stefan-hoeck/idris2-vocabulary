module Vocabulary.DB

import FS.Sqlite3

%default total

public export
Results : SQLTable
Results =
  table "results"
    [ C "result_id" INTEGER
    , C "word_id"   INTEGER
    , C "user_id"   INTEGER
    , C "timestamp" INTEGER
    , C "success"   INTEGER
    ]

public export
Units : SQLTable
Units =
  table "units"
    [ C "unit_id"  INTEGER
    , C "parent"   INTEGER
    , C "name"     TEXT
    , C "from"     TEXT
    , C "to"       TEXT
    ]

public export
Users : SQLTable
Users =
  table "users"
    [ C "user_id"  INTEGER
    , C "name"     TEXT
    , C "password" TEXT
    , C "email"    TEXT
    ]

public export
Words : SQLTable
Words =
  table "words"
    [ C "word_id"  INTEGER
    ]

public export
createUnits : Cmd TCreate
createUnits =
  IF_NOT_EXISTS $ CREATE_TABLE Units
    [ PRIMARY_KEY   ["unit_id"]
    , AUTOINCREMENT "unit_id"
    , FOREIGN_KEY Units ["parent"] ["unit_id"]
    , NOT_NULL      "name"
    , NOT_NULL      "from"
    , NOT_NULL      "to"
    ]

public export
createUsers : Cmd TCreate
createUsers =
  IF_NOT_EXISTS $ CREATE_TABLE Users
    [ PRIMARY_KEY   ["user_id"]
    , AUTOINCREMENT "user_id"
    , NOT_NULL      "name"
    , NOT_NULL      "password"
    , NOT_NULL      "email"
    ]

public export
createResults : Cmd TCreate
createResults =
  IF_NOT_EXISTS $ CREATE_TABLE Results
    [ PRIMARY_KEY       ["result_id"]
    , FOREIGN_KEY Words ["word_id"] ["word_id"]
    , FOREIGN_KEY Users ["user_id"] ["user_id"]
    , AUTOINCREMENT     "result_id"
    , NOT_NULL          "timestamp"
    , NOT_NULL          "success"
    ]
