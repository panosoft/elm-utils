module Utils.Dict exposing (zip)

{-|
    Utility Dict functions.

@docs zip
-}

import Dict exposing (..)


{-|
    Zip list of keys and list of values into a Dictionary.

    When length of keys != lenght of values then whichever runs out first will end the zip.

    Usage:

    keys : String
    keys =
        [ "a"
        , "b"
        , "c"
        ]

    values : Int
    values =
        [ 1
        , 2
        , 3
        ]

    dict : Dict String Int
    dict =
        zip keys values
-}
zip : List comparable -> List a -> Dict comparable a
zip keys values =
    let
        toList keys values list =
            case keys of
                [] ->
                    list

                key :: restKeys ->
                    case values of
                        [] ->
                            list

                        value :: restValues ->
                            toList restKeys restValues (( key, value ) :: list)
    in
        Dict.fromList <| toList keys values []
