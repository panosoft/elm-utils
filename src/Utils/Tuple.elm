module Utils.Tuple exposing (..)

{-|
    Utility tuple functions.

@docs firstMap, secondMap
-}


{-|
    Map on first item of 2-tuple.

    Usage:

    -- x will be [(10, "Test"), (20, "Another")]
    x : List (Int, String)
    x = firstMap (\num -> 10 * num) [(1, "Test"), (2, "Another")]

-}
firstMap : (a -> b) -> List ( a, c ) -> List ( b, c )
firstMap f =
    List.map (\( x, y ) -> ( f x, y ))


{-|
    Map on second item of 2-tuple.

    Usage:

    -- x will be [(1, 4), (2, 7)]
    x : List (Int, String)
    x = secondMap String.length [(1, "Test"), (2, "Another")]

-}
secondMap : (b -> c) -> List ( a, b ) -> List ( a, c )
secondMap f =
    List.map (\( x, y ) -> ( x, f y ))
