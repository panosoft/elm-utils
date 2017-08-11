module Utils.Task exposing (..)

{-|
    Utility Task functions.

@docs untilSuccess
-}

import Task exposing (Task)


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
