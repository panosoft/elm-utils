module Utils.Ops exposing (..)

{-|

    Utility operators.

Boolean:
@docs (?), (?!)

List:
@docs (!!)

Maybe:
@docs (?=), (?!=), (|?>)
@docs (|?->), (|?!->), (|?-->), (|?!-->), (|?-->), (|?!-->), (|?--->), (|?!--->)
@docs (|?**>), (|?!**>), (|?***>), (|?!***>), (|?****>), (|?!****>)

Result:
@docs (|??>), (??=)
@docs (|??->), (|??-->)
@docs (|??**>), (|??***>), (|??****>)

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



-- List


{-| get item at index
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


{-| Lazy version of (|?***>)
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


{-| (|??->) for 2-tuple of Results
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
