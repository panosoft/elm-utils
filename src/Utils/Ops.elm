module Utils.Ops exposing (..)

{-| Utility operators.

  - [Boolean](#boolean)
  - [List](#list)
  - [Maybe](#maybe)
  - [Result](#result)


# Boolean

@docs (?), (?!)


# List

@docs (!!)


# Maybe

@docs (?=), (?!=), (|?>), (|?->), (|?!->), (|?-->), (|?!-->), (|?--->), (|?!--->), (|?**>), (|?!**>), (|?***>), (|?!***>), (|?****>), (|?!****>)


# Result

@docs (|??>), (??=), (|??->), (|??-->), (|??**>), (|??***>), (|??****>)

-}

-- Boolean


{-| Simplify `if` syntax on a single line.

    x : Int
    x =
        2


    -- y will be "not one"

    y : String
    y =
        x == 1 ? ( "one", "not one" )

-}
(?) : Bool -> ( a, a ) -> a
(?) bool ( t, f ) =
    if bool then
        t
    else
        f


{-| Lazy version of ? operator for recursion or expensive functions that you don't want executed.

    fact : Int -> Int
    fact n =
        (n <= 1) ?! ( \_ -> 1, \_ -> n * (fact <| n - 1) )

-}
(?!) : Bool -> ( () -> a, () -> a ) -> a
(?!) bool ( tf, ff ) =
    if bool then
        tf ()
    else
        ff ()



-- List


{-| Get item from List at index

    items : List String
    items =
        [ "Mickey's gloves", "Goofy's shoes", "Dumbo's feather" ]

    first2 : List String -> ( String, String )
    first2 list =
        ( list !! 0, list !! 1 )
            |?!**>
                ( \_ -> Debug.crash "missing first"
                , \_ -> Debug.crash "missing second"
                , identity
                )

-}
(!!) : List a -> Int -> Maybe a
(!!) list index =
    (list == [])
        ? ( Nothing
          , list
                |> List.drop index
                |> List.head
          )



-- Maybe


{-| Maybe with default operator.

Simplify `Maybe.withDefault` syntax

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


{-| Lazy version of ?= operator. (Since Elm is eager).

This is important if the default is a `Debug.crash` (or any side-effect function). You don't want it to be evaluated until it's needed. Since Elm is not lazy, we need to have
special version of this.

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


{-| Maybe.map operator

Simplify `Maybe.map` syntax.

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


{-| Maybe.map combined with Maybe.withDefault (or |?> combined with ?=)

This combines two operators with the error case first, i.e. the Nothing.

    x : Maybe Int
    x =
        Nothing

    y : Int
    y =
        x |?-> ( 0, \x -> x * 10 )

-}
(|?->) : Maybe a -> ( b, a -> b ) -> b
(|?->) ma ( vma, f ) =
    ma
        |?> f
        ?= vma


{-| Lazy version of (|?->)

The lazy version for side-effect functions, i.e. Debug.log.

    x : Maybe Int
    x =
        Nothing

    y : Int
    y =
        x |?!-> ( \_ -> Debug.crash "BUG: x must never be Nothing here!!!", \x -> x * 10 )

    z : Int
    z =
        x
            |?!->
                ( \_ ->
                    Debug.log "using default for x"
                        |> always 0
                , \x -> x * 10
                )

-}
(|?!->) : Maybe a -> ( () -> b, a -> b ) -> b
(|?!->) ma ( fma, f ) =
    ma
        |?> f
        ?!= fma


{-| Double version of (|?->)

Same as (|?->) but used with `Maybe (Maybe a)` instead of just `Maybe a`.

    x : Maybe (Maybe Int)
    x =
        Nothing

    y : Int
    y =
        x |?--> ( 0, \x -> x * 10 )

-}
(|?-->) : Maybe (Maybe a) -> ( b, a -> b ) -> b
(|?-->) mma ( vmma, f ) =
    mma
        |?> (\ma ->
                ma
                    |?> f
                    ?= vmma
            )
        ?= vmma


{-| Lazy version of (|?-->)

    x : Maybe (Maybe Int)
    x =
        Nothing

    y : Int
    y =
        x
            |?!-->
                ( \_ -> Debug.crash "BUG: x must never be Nothing here!!!"
                , \x -> x * 10
                )

    z : Int
    z =
        x
            |?!-->
                ( \_ ->
                    Debug.log "using default for x"
                        |> always 0
                , \x -> x * 10
                )

-}
(|?!-->) : Maybe (Maybe a) -> ( () -> b, a -> b ) -> b
(|?!-->) mma ( fmma, f ) =
    mma
        |?> (\ma ->
                ma
                    |?> f
                    ?!= fmma
            )
        ?!= fmma


{-| Triple version of (|?->)
-}
(|?--->) : Maybe (Maybe (Maybe a)) -> ( b, a -> b ) -> b
(|?--->) mmma ( vmmma, f ) =
    mmma
        |?> (\mma ->
                mma
                    |?--> ( vmmma, f )
            )
        ?= vmmma


{-| Lazy version of (|?--->)
-}
(|?!--->) : Maybe (Maybe (Maybe a)) -> ( () -> b, a -> b ) -> b
(|?!--->) mmma ( fmmma, f ) =
    mmma
        |?> (\mma ->
                mma
                    |?!--> ( fmmma, f )
            )
        ?!= fmmma


{-| (|?->) for 2-tuple of Maybe's

Useful when 2 maybes need defaults.

    x : Maybe Int
    x =
        Just 1

    y : Maybe Int
    y =
        Nothing

    z : Int
    z =
        ( x, y ) |?**> ( 0, 0, \( x, y ) -> x + y )

-}
(|?**>) : ( Maybe a, Maybe b ) -> ( c, c, ( a, b ) -> c ) -> c
(|?**>) ( ma, mb ) ( va, vb, f ) =
    case ( ma, mb ) of
        ( Just a, Just b ) ->
            f ( a, b )

        ( Nothing, _ ) ->
            va

        ( _, Nothing ) ->
            vb


{-| Lazy version of `(|?**>)`

Useful when 2 maybes must have defaults or must not be `Nothing`.

    bugMissing : String -> (a -> b)
    bugMissing missing =
        (\_ -> Debug.crash ("BUG: " ++ missing ++ " missing"))

    x : Maybe Int
    x =
        Just 1

    y : Maybe Int
    y =
        Nothing

    z : Int
    z =
        ( x, y )
            |?!**>
                ( bugMissing "x"
                , bugMissing "y"
                , \( x, y ) -> x + y
                )

-}
(|?!**>) : ( Maybe a, Maybe b ) -> ( () -> c, () -> c, ( a, b ) -> c ) -> c
(|?!**>) ( ma, mb ) ( fa, fb, f ) =
    case ( ma, mb ) of
        ( Just a, Just b ) ->
            f ( a, b )

        ( Nothing, _ ) ->
            fa ()

        ( _, Nothing ) ->
            fb ()


{-| (|?->) for 3-tuple of Maybe's
-}
(|?***>) : ( Maybe a, Maybe b, Maybe c ) -> ( d, d, d, ( a, b, c ) -> d ) -> d
(|?***>) ( ma, mb, mc ) ( va, vb, vc, f ) =
    case ( ma, mb, mc ) of
        ( Just a, Just b, Just c ) ->
            f ( a, b, c )

        ( Nothing, _, _ ) ->
            va

        ( _, Nothing, _ ) ->
            vb

        ( _, _, Nothing ) ->
            vc


{-| Lazy version of `(|?***>)`
-}
(|?!***>) : ( Maybe a, Maybe b, Maybe c ) -> ( () -> d, () -> d, () -> d, ( a, b, c ) -> d ) -> d
(|?!***>) ( ma, mb, mc ) ( fa, fb, fc, f ) =
    case ( ma, mb, mc ) of
        ( Just a, Just b, Just c ) ->
            f ( a, b, c )

        ( Nothing, _, _ ) ->
            fa ()

        ( _, Nothing, _ ) ->
            fb ()

        ( _, _, Nothing ) ->
            fc ()


{-| (|?->) for 4-tuple of Maybe's
-}
(|?****>) : ( Maybe a, Maybe b, Maybe c, Maybe d ) -> ( e, e, e, e, ( a, b, c, d ) -> e ) -> e
(|?****>) ( ma, mb, mc, md ) ( va, vb, vc, vd, f ) =
    case ( ma, mb, mc, md ) of
        ( Just a, Just b, Just c, Just d ) ->
            f ( a, b, c, d )

        ( Nothing, _, _, _ ) ->
            va

        ( _, Nothing, _, _ ) ->
            vb

        ( _, _, Nothing, _ ) ->
            vc

        ( _, _, _, Nothing ) ->
            vd


{-| Lazy version of `(|?***>)`
-}
(|?!****>) : ( Maybe a, Maybe b, Maybe c, Maybe d ) -> ( () -> e, () -> e, () -> e, () -> e, ( a, b, c, d ) -> e ) -> e
(|?!****>) ( ma, mb, mc, md ) ( fa, fb, fc, fd, f ) =
    case ( ma, mb, mc, md ) of
        ( Just a, Just b, Just c, Just d ) ->
            f ( a, b, c, d )

        ( Nothing, _, _, _ ) ->
            fa ()

        ( _, Nothing, _, _ ) ->
            fb ()

        ( _, _, Nothing, _ ) ->
            fc ()

        ( _, _, _, Nothing ) ->
            fd ()



-- Result


{-| Result.map operator

Simplified `Result.map` syntax.

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


{-| Simplified `Result.default` syntax.
This is different from Maybe.default since the Error Type may be different then the Ok Type in a Result.
This is why a function is passed to convert the Error Value to a value of Ok Type.

    br : Result String Int
    br =
        Err "Bad Things Happened"

    gr : Result String Int
    gr =
        Ok 123


    -- b will be -1

    b : Int
    b =
        br |??> (\num -> 10 * num) ??= (\_ -> -1)


    -- g will be Ok 1230

    g : Result String Int
    g =
        gr |??> (\num -> 10 * num)

-}
(??=) : Result err value -> (err -> value) -> value
(??=) result f =
    case result of
        Ok value ->
            value

        Err err ->
            f err


{-| Result.map combined with (??=) (or |??> combined with ??=)

This combines two operators with the error case first.

    br : Result String Int
    br =
        Err "Bad Things Happened"


    -- b will be -1

    b : Int
    b =
        br |??-> ( \_ -> -1, \num -> 10 * num )

-}
(|??->) : Result a b -> ( a -> c, b -> c ) -> c
(|??->) r ( fr, f ) =
    r
        |??> f
        ??= fr


{-| Double version of (|?->)

    crash : String -> (a -> b)
    crash error =
        (\_ -> Debug.crash error)

    brr : Result String (Result String Int)
    brr =
        Ok <| Err "Bad Things Happened"


    -- b will be -1

    b : Int
    b =
        brr
            |??-->
                ( crash "fatal error"
                , \_ -> -1
                , \num -> 10 * num
                )

-}
(|??-->) : Result a (Result b c) -> ( a -> d, b -> d, c -> d ) -> d
(|??-->) rr ( frr, fr, f ) =
    rr
        |??> (\r -> r |??-> ( fr, f ))
        ??= frr


{-| (|??->) for 2-tuple of Results

    crash : String -> String -> x
    crash which error =
        Debug.crash (which ++ " has the following error: " ++ error)

    ar : Result String Int
    ar =
        Ok 10

    br : Result String Int
    br =
        Ok 20


    -- sum will be 30

    sum : Int
    sum =
        ( ar, br )
            |??**>
                ( crash "a"
                , crash "b"
                , \( a, b ) -> a + b
                )

-}
(|??**>) : ( Result x a, Result x b ) -> ( x -> c, x -> c, ( a, b ) -> c ) -> c
(|??**>) ( ra, rb ) ( fa, fb, f ) =
    case ( ra, rb ) of
        ( Ok a, Ok b ) ->
            f ( a, b )

        ( Err error, _ ) ->
            fa error

        ( _, Err error ) ->
            fb error


{-| (|??->) for 3-tuple of Results
-}
(|??***>) : ( Result x a, Result x b, Result x c ) -> ( x -> d, x -> d, x -> d, ( a, b, c ) -> d ) -> d
(|??***>) ( ra, rb, rc ) ( fa, fb, fc, f ) =
    case ( ra, rb, rc ) of
        ( Ok a, Ok b, Ok c ) ->
            f ( a, b, c )

        ( Err error, _, _ ) ->
            fa error

        ( _, Err error, _ ) ->
            fb error

        ( _, _, Err error ) ->
            fc error


{-| (|??->) for 4-tuple of Results
-}
(|??****>) : ( Result x a, Result x b, Result x c, Result x d ) -> ( x -> e, x -> e, x -> e, x -> e, ( a, b, c, d ) -> e ) -> e
(|??****>) ( ra, rb, rc, rd ) ( fa, fb, fc, fd, f ) =
    case ( ra, rb, rc, rd ) of
        ( Ok a, Ok b, Ok c, Ok d ) ->
            f ( a, b, c, d )

        ( Err error, _, _, _ ) ->
            fa error

        ( _, Err error, _, _ ) ->
            fb error

        ( _, _, Err error, _ ) ->
            fc error

        ( _, _, _, Err error ) ->
            fd error
