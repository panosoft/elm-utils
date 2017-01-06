module Utils.Ops exposing (..)

{-|
    Utility operators.

@docs (?), (?!), (?=), (?!=), (|?>), (|??>), (??=)
-}


{-|
    Inline if operator.

    Usage:

    x : Int
    x =
        2

    -- y will be "not one"
    y : String
    y =
        x == 1 ? ("one", "not one")
-}
(?) : Bool -> ( a, a ) -> a
(?) bool ( t, f ) =
    if bool then
        t
    else
        f


{-|
    Lazy version of ? operator for recursion or expensive functions that you don't want executed.

    Usage:

    fact : Int -> Int
    fact n =
        (n <= 1) ? (\_ -> 1, \_ -> n * (fact <| n - 1) )

-}
(?!) : Bool -> ( () -> a, () -> a ) -> a
(?!) bool ( tf, ff ) =
    if bool then
        tf ()
    else
        ff ()



-- case n of
--     0 ->
--         1
--
--     1 ->
--         1
--
--     _ ->
--         n * (fact <| n - 1)


{-|
    Maybe with default operator

    Usage:

    -- x will be 1
    x : Int
    x =
        Just 1 ?= -1

    -- y will be -1
    y : Int
    y =
        Nothing ?= -1
-}
(?=) : Maybe a -> a -> a
(?=) =
    flip Maybe.withDefault


{-|
    Lazy version of ?= operator. (Since Elm is eager)

    Usage:

    x : Maybe Int
    x =
        Nothing

    crashIfNothing : Int
    crashIfNothing =
        x ?!= (\_ -> Debug.crash "x cannot be Nothing, must be a internal programming bug")
-}
(?!=) : Maybe a -> (() -> a) -> a
(?!=) maybe lazy =
    case maybe of
        Just x ->
            x

        Nothing ->
            lazy ()


{-|
    Maybe.map operator

    Usage:

    x : Maybe Int
    x =
        Just 1

    -- y will be Just 10
    y : Maybe Int
    y =
        x |?> (\num -> 10 * num)

    -- z will be 10
    z : Int
    z =
        x |?> (\num -> 10 * num) ?= 0
-}
(|?>) : Maybe a -> (a -> b) -> Maybe b
(|?>) =
    flip Maybe.map


{-|
    Result.map operator

    Usage:

    br : Result String Int
    br =
        Err "Bad Things Happened"

    gr : Result String Int
    gr =
        Ok 123

    -- b will be Err "Bad Things Happened"
    b : Result String Int
    b =
        br |??> (\num -> 10 * num)

    -- g will be Ok 1230
    g : Result String Int
    g =
        gr |??> (\num -> 10 * num)
-}
(|??>) : Result a b -> (b -> c) -> Result a c
(|??>) =
    flip Result.map


{-|
    Result default operator. This is different from Maybe.default since the Error Type may be different then the Ok Type in a Result.
    This is why a function is passed to convert the Error Value to a value of Ok Type.

    Usage:

    br : Result String Int
    br =
        Err "Bad Things Happened"

    gr : Result String Int
    gr =
        Ok 123

    -- b will be -1
    b : Result String Int
    b =
        br |??> (\num -> 10 * num) ??= (\_ -> -1)

    -- g will be Ok 1230
    g : Result String Int
    g =
        gr |??> (\num -> 10 * num) ??= -1
-}
(??=) : Result err value -> (err -> value) -> value
(??=) result f =
    case result of
        Ok value ->
            value

        Err err ->
            f err
