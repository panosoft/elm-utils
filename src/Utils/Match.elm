module Utils.Match exposing (..)

{-|
    Utility Regex Match functions.

@docs extract1, extract2, extract3, extract4
@docs getSubmatches1, getSubmatches2, getSubmatches3, getSubmatches4
-}

import Regex exposing (..)
import Utils.Ops exposing (..)


{-| extract 1 submatch
-}
extract1 : Match -> Maybe (Maybe String)
extract1 match =
    (match.submatches !! 0)
        |?-> ( Nothing, Just )


{-| extract 2 submatches
-}
extract2 : Match -> Maybe ( Maybe String, Maybe String )
extract2 match =
    ( match.submatches !! 0, match.submatches !! 1 )
        |?**> ( Nothing, Nothing, Just )


{-| extract 3 submatches
-}
extract3 : Match -> Maybe ( Maybe String, Maybe String, Maybe String )
extract3 match =
    ( match.submatches !! 0, match.submatches !! 1, match.submatches !! 2 )
        |?***> ( Nothing, Nothing, Nothing, Just )


{-| extract 4 submatches
-}
extract4 : Match -> Maybe ( Maybe String, Maybe String, Maybe String, Maybe String )
extract4 match =
    ( match.submatches !! 0, match.submatches !! 1, match.submatches !! 2, match.submatches !! 3 )
        |?****> ( Nothing, Nothing, Nothing, Nothing, Just )


{-| get 1 submatch
-}
getSubmatches1 : Match -> String
getSubmatches1 match =
    extract1 match
        |?!->
            ( \_ -> Debug.crash "missing submatches"
            , flip (|?!->)
                ( \_ -> Debug.crash "missing first"
                , (\first -> first)
                )
            )


{-| get 2 submatches
-}
getSubmatches2 : Match -> ( String, String )
getSubmatches2 match =
    extract2 match
        |?!->
            ( \_ -> Debug.crash "missing submatcheses"
            , flip (|?!**>)
                ( \_ -> Debug.crash "missing first"
                , \_ -> Debug.crash "missing second"
                , identity
                )
            )


{-| get 3 submatches
-}
getSubmatches3 : Match -> ( String, String, String )
getSubmatches3 match =
    extract3 match
        |?!->
            ( \_ -> Debug.crash "missing submatches"
            , flip (|?!***>)
                ( \_ -> Debug.crash "missing first"
                , \_ -> Debug.crash "missing second"
                , \_ -> Debug.crash "missing third"
                , identity
                )
            )


{-| get 4 submatches
-}
getSubmatches4 : Match -> ( String, String, String, String )
getSubmatches4 match =
    extract4 match
        |?!->
            ( \_ -> Debug.crash "missing submatches"
            , flip (|?!****>)
                ( \_ -> Debug.crash "missing first"
                , \_ -> Debug.crash "missing second"
                , \_ -> Debug.crash "missing third"
                , \_ -> Debug.crash "missing fourth"
                , identity
                )
            )
