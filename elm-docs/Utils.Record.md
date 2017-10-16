# Utils.Record

Utility Record functions.

- [makeComparable](#makecomparable)

### **makeComparable**
```elm
makeComparable : List (a -> String) -> a -> String
```

Make a record into a comparable string for use as a key in a Dict

```elm
import Utils.Record as Record

type alias DbConnectionInfo =
    { host : String
    , port_ : Int
    , database : String
    , user : String
    , password : String
    , timeout : Int
    }

{-| make connection info comparable for Dictionaries
-}
makeComparable : DbConnectionInfo -> String
makeComparable =
    Record.makeComparable
        [ .host
        , toString << .port_
        , .database
        , .user
        , .password
        ]

```

`timeout` was left out on purpose in this example.

