module Utils.Dict
    exposing
        ( swap
        , zip
        )

{-| Utility Dict functions.

@docs swap, zip

-}

import Dict exposing (..)
import Utils.Ops exposing (..)


{-| swap dictionary's keys and values - returns Err if values are NOT unique
-}
swap : Dict comparable comparable_ -> Result String (Dict comparable_ comparable)
swap dict =
    dict
        |> Dict.toList
        |> List.map (\( k, v ) -> ( v, k ))
        |> Dict.fromList
        |> (\newDict ->
                (Dict.size newDict == Dict.size dict)
                    ? ( Ok newDict
                      , Err "Values are not unique"
                      )
           )


{-| Zip keys and values together into Dictionary.

When length of keys != length of values then whichever runs out first will end the zip.

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
