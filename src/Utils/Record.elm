module Utils.Record exposing (makeComparable)

{-| Utility Record functions.

@docs makeComparable

-}


{-| Make a record into a comparable string for use as a key in a Dict

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

`timeout` was left out on purpose in this example.

-}
makeComparable : List (a -> String) -> a -> String
makeComparable recordStringGetters record =
    recordStringGetters
        |> List.map ((|>) record)
        |> String.join "†"
