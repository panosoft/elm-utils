module Utils.List exposing (..)

{-| Utility List functions.

@docs to2Tuple, to3Tuple, to4Tuple, to5Tuple, to6Tuple, to7Tuple, to8Tuple, to9Tuple

-}


{-| Take a list of length 2 or greater and convert it into an 2-tuple dropping any extra elements
-}
to2Tuple : List a -> ( a, a )
to2Tuple list =
    case List.take 2 list of
        [ a, b ] ->
            ( a, b )

        _ ->
            Debug.crash "List must be of at least length 2"


{-| Take a list of length 3 or greater and convert it into an 3-tuple dropping any extra elements
-}
to3Tuple : List a -> ( a, a, a )
to3Tuple list =
    case List.take 3 list of
        [ a, b, c ] ->
            ( a, b, c )

        _ ->
            Debug.crash "List must be of at least length 3"


{-| Take a list of length 4 or greater and convert it into an 4-tuple dropping any extra elements
-}
to4Tuple : List a -> ( a, a, a, a )
to4Tuple list =
    case List.take 4 list of
        [ a, b, c, d ] ->
            ( a, b, c, d )

        _ ->
            Debug.crash "List must be of at least length 4"


{-| Take a list of length 5 or greater and convert it into an 5-tuple dropping any extra elements
-}
to5Tuple : List a -> ( a, a, a, a, a )
to5Tuple list =
    case List.take 5 list of
        [ a, b, c, d, e ] ->
            ( a, b, c, d, e )

        _ ->
            Debug.crash "List must be of at least length 5"


{-| Take a list of length 6 or greater and convert it into an 6-tuple dropping any extra elements
-}
to6Tuple : List a -> ( a, a, a, a, a, a )
to6Tuple list =
    case List.take 6 list of
        [ a, b, c, d, e, f ] ->
            ( a, b, c, d, e, f )

        _ ->
            Debug.crash "List must be of at least length 6"


{-| Take a list of length 7 or greater and convert it into an 7-tuple dropping any extra elements
-}
to7Tuple : List a -> ( a, a, a, a, a, a, a )
to7Tuple list =
    case List.take 7 list of
        [ a, b, c, d, e, f, g ] ->
            ( a, b, c, d, e, f, g )

        _ ->
            Debug.crash "List must be of at least length 7"


{-| Take a list of length 8 or greater and convert it into an 8-tuple dropping any extra elements
-}
to8Tuple : List a -> ( a, a, a, a, a, a, a, a )
to8Tuple list =
    case List.take 8 list of
        [ a, b, c, d, e, f, g, h ] ->
            ( a, b, c, d, e, f, g, h )

        _ ->
            Debug.crash "List must be of at least length 8"


{-| Take a list of length 9 or greater and convert it into an 9-tuple dropping any extra elements
-}
to9Tuple : List a -> ( a, a, a, a, a, a, a, a, a )
to9Tuple list =
    case List.take 9 list of
        [ a, b, c, d, e, f, g, h, i ] ->
            ( a, b, c, d, e, f, g, h, i )

        _ ->
            Debug.crash "List must be of at least length 9"
