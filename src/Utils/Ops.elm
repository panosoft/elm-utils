module Utils.Ops exposing (..)

{-|
    Utility operators.

Boolean:
@docs (?), (?!)

Maybe:
@docs (?=), (?!=), (|?>)
@docs (|?->), (|?!->), (|?-->), (|?!-->), (|?-->), (|?!-->), (|?--->), (|?!--->)
@docs (|?**>), (|?!**>), (|?***>), (|?!***>)

Result:
@docs (|??>), (??=)
@docs (|??->), (|??-->)
-}

-- Boolean


{-| Inline if operator
-}
(?) : Bool -> ( a, a ) -> a
(?) bool ( t, f ) =
    if bool then
        t
    else
        f


{-| Lazy version of ? operator for recursion or expensive functions that you don't want executed.
-}
(?!) : Bool -> ( () -> a, () -> a ) -> a
(?!) bool ( tf, ff ) =
    if bool then
        tf ()
    else
        ff ()



-- Maybe


{-| Maybe with default operator
-}
(?=) : Maybe a -> a -> a
(?=) =
    flip Maybe.withDefault


{-| Lazy version of ?= operator. (Since Elm is eager)
-}
(?!=) : Maybe a -> (() -> a) -> a
(?!=) maybe lazy =
    case maybe of
        Just x ->
            x

        Nothing ->
            lazy ()


{-| Maybe.map operator
-}
(|?>) : Maybe a -> (a -> b) -> Maybe b
(|?>) =
    flip Maybe.map


{-| Maybe.map combined with Maybe.withDefault (or |?> combined with ?=)
-}
(|?->) : Maybe a -> ( b, a -> b ) -> b
(|?->) ma ( vma, f ) =
    ma
        |?> f
        ?= vma


{-| Lazy version of (|?->)
-}
(|?!->) : Maybe a -> ( () -> b, a -> b ) -> b
(|?!->) ma ( fma, f ) =
    ma
        |?> f
        ?!= fma


{-| Double version of (|?->)
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


{-| Lazy version of (|?**>)
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


{-| Lazy version of (|?***>)
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



-- Result


{-| Result.map operator
-}
(|??>) : Result a b -> (b -> c) -> Result a c
(|??>) =
    flip Result.map


{-| Result default operator. This is different from Maybe.default since the Error Type may be different then the Ok Type in a Result.
    This is why a function is passed to convert the Error Value to a value of Ok Type.
-}
(??=) : Result err value -> (err -> value) -> value
(??=) result f =
    case result of
        Ok value ->
            value

        Err err ->
            f err


{-| Result.map combined with (??=) (or |??> combined with ??=)
-}
(|??->) : Result a b -> ( a -> c, b -> c ) -> c
(|??->) r ( fr, f ) =
    r
        |??> f
        ??= fr


{-| Double version of (|?->)
-}
(|??-->) : Result a (Result b c) -> ( a -> d, b -> d, c -> d ) -> d
(|??-->) rr ( frr, fr, f ) =
    rr
        |??> (\r -> r |??-> ( fr, f ))
        ??= frr
