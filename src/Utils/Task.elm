module Utils.Task exposing (..)

{-| Utility Task functions.

@docs untilSuccess, andThenIf

-}

import Task exposing (Task)
import Utils.Ops exposing (..)


{-| Exectute a list of Tasks from left to right sequentially
until one succeeds at which point processing of the list is terminated.

If all tasks fail then the `failureValue` is the result of the combined Task.

    tasks : Task String Int
    tasks =
        untilSuccess "None succeeded" [ Task.fail "nope", Task.succeed 1, Task.fail "never gets executed", Task.succeed 2 ]

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

This function helps reduces code clutter (by 2 lines).

    with : Bool -> Task String ()
    with flag =
        Task.succeed ()
            |> Task.andThen (\_ -> Task.succeed ())
            |> andThenIf flag
                ( \_ -> Task.succeed ()
                , always <| Task.fail "flag not set"
                )

    without : Bool -> Task String ()
    without flag =
        Task.succeed ()
            |> Task.andThen (\_ -> Task.succeed ())
            |> Task.andThen
                (flag
                    ? ( \_ -> Task.succeed ()
                      , always <| Task.fail "flag not set"
                      )
                )

-}
andThenIf : Bool -> ( a -> Task x b, a -> Task x b ) -> Task x a -> Task x b
andThenIf cond ( tf, ff ) =
    Task.andThen (cond ? ( tf, ff ))
