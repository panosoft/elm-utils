module Utils.Result exposing (..)

{-|
    Utility Result functions.

@docs filterErr, filterOk
-}


{-|
    Filter Errors from a List of Results.

    Usage:

    results : Result String Int
    results =
        [ Err "bad"
        , Ok 123
        , Err "bad2"
        ]

    -- errorsOnly will be ["bad", "bad2"]
    errorsOnly : List String
    errorsOnly =
        filterErr results
-}
filterErr : List (Result error x) -> List error
filterErr results =
    case results of
        result :: rest ->
            case result of
                Err msg ->
                    msg :: filterErr rest

                Ok _ ->
                    filterErr rest

        [] ->
            []


{-|
    Filter Oks from a List of Results.

    Usage:

    results : Result String Int
    results =
        [ Err "bad"
        , Ok 123
        , Err "bad2"
        ]

    -- oksOnly will be [123]
    oksOnly : List String
    oksOnly =
        filterOk results
-}
filterOk : List (Result x value) -> List value
filterOk results =
    case results of
        result :: rest ->
            case result of
                Err _ ->
                    filterOk rest

                Ok value ->
                    value :: filterOk rest

        [] ->
            []
