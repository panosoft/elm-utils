module Utils.Record exposing (makeComparable)

{-|
    Utility Record functions.

@docs makeComparable
-}


{-| Make a record into a comparable string for use as a key in a Dict
-}
makeComparable : List (a -> String) -> a -> String
makeComparable recordStringGetters record =
    recordStringGetters
        |> List.map ((|>) record)
        |> String.join "†"
