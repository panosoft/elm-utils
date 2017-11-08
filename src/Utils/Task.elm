module Utils.Task exposing (..)

{-| Utility Task functions.

@docs untilSuccess, andThenIf, sequence2, sequence3, sequence4, sequence5, sequence6, sequence7, sequence8, sequence9

-}

import Task exposing (Task)
import Utils.Ops exposing (..)


{-| Execute a list of Tasks from left to right sequentially
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


{-| Sequence 2 Tasks of similar error types but differing success types

This function helps reduces indent hell especially with higher numbers of tasks.

Old way:

    getCountTask
        |> Task.andThen
            (\count ->
                getNameTask
                    |> Task.andThen (\name -> name ++ ":" ++ count)
            )

New way:

    ( getCountTask, getNameTask )
        |> sequence2
        |> Task.andThen (\( count, name ) -> name ++ ":" ++ count)

-}
sequence2 : ( Task x a, Task x b ) -> Task x ( a, b )
sequence2 ( ta, tb ) =
    ta
        |> Task.andThen
            (\a -> tb |> Task.andThen (\b -> Task.succeed ( a, b )))


{-| Sequence 3 Tasks of similar error types but differing success types
-}
sequence3 : ( Task x a, Task x b, Task x c ) -> Task x ( a, b, c )
sequence3 ( ta, tb, tc ) =
    sequence2 ( ta, tb )
        |> Task.andThen
            (\( a, b ) -> tc |> Task.andThen (\c -> Task.succeed ( a, b, c )))


{-| Sequence 4 Tasks of similar error types but differing success types
-}
sequence4 : ( Task x a, Task x b, Task x c, Task x d ) -> Task x ( a, b, c, d )
sequence4 ( ta, tb, tc, td ) =
    sequence3 ( ta, tb, tc )
        |> Task.andThen
            (\( a, b, c ) -> td |> Task.andThen (\d -> Task.succeed ( a, b, c, d )))


{-| Sequence 5 Tasks of similar error types but differing success types
-}
sequence5 : ( Task x a, Task x b, Task x c, Task x d, Task x e ) -> Task x ( a, b, c, d, e )
sequence5 ( ta, tb, tc, td, te ) =
    sequence4 ( ta, tb, tc, td )
        |> Task.andThen
            (\( a, b, c, d ) -> te |> Task.andThen (\e -> Task.succeed ( a, b, c, d, e )))


{-| Sequence 6 Tasks of similar error types but differing success types
-}
sequence6 : ( Task x a, Task x b, Task x c, Task x d, Task x e, Task x f ) -> Task x ( a, b, c, d, e, f )
sequence6 ( ta, tb, tc, td, te, tf ) =
    sequence5 ( ta, tb, tc, td, te )
        |> Task.andThen
            (\( a, b, c, d, e ) -> tf |> Task.andThen (\f -> Task.succeed ( a, b, c, d, e, f )))


{-| Sequence 7 Tasks of similar error types but differing success types
-}
sequence7 : ( Task x a, Task x b, Task x c, Task x d, Task x e, Task x f, Task x g ) -> Task x ( a, b, c, d, e, f, g )
sequence7 ( ta, tb, tc, td, te, tf, tg ) =
    sequence6 ( ta, tb, tc, td, te, tf )
        |> Task.andThen
            (\( a, b, c, d, e, f ) -> tg |> Task.andThen (\g -> Task.succeed ( a, b, c, d, e, f, g )))


{-| Sequence 8 Tasks of similar error types but differing success types
-}
sequence8 : ( Task x a, Task x b, Task x c, Task x d, Task x e, Task x f, Task x g, Task x h ) -> Task x ( a, b, c, d, e, f, g, h )
sequence8 ( ta, tb, tc, td, te, tf, tg, th ) =
    sequence7 ( ta, tb, tc, td, te, tf, tg )
        |> Task.andThen
            (\( a, b, c, d, e, f, g ) -> th |> Task.andThen (\h -> Task.succeed ( a, b, c, d, e, f, g, h )))


{-| Sequence 9 Tasks of similar error types but differing success types
-}
sequence9 : ( Task x a, Task x b, Task x c, Task x d, Task x e, Task x f, Task x g, Task x h, Task x i ) -> Task x ( a, b, c, d, e, f, g, h, i )
sequence9 ( ta, tb, tc, td, te, tf, tg, th, ti ) =
    sequence8 ( ta, tb, tc, td, te, tf, tg, th )
        |> Task.andThen
            (\( a, b, c, d, e, f, g, h ) -> ti |> Task.andThen (\i -> Task.succeed ( a, b, c, d, e, f, g, h, i )))
