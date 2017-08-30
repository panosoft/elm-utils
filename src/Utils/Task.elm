module Utils.Task exposing (..)

{-|
    Utility Task functions.

@docs untilSuccess, andThenIf
-}

import Task exposing (Task)
import Utils.Ops exposing (..)


{-| Exectute a list of Tasks from left to right sequentially
    until one succeeds at which point processing of the list is terminated.
-}
untilSuccess : x -> List (Task x a) -> Task x a
untilSuccess failureValue tasks =
    case tasks of
        [] ->
            Task.fail failureValue

        task :: tasks ->
            task
                |> Task.andThen Task.succeed
                |> Task.onError
                    (\_ -> untilSuccess failureValue tasks)


{-| Conditional Task.andThen
-}
andThenIf : Bool -> ( a -> Task x b, a -> Task x b ) -> Task x a -> Task x b
andThenIf cond ( tf, ff ) =
    Task.andThen (cond ? ( tf, ff ))
