module Utils.Func
    exposing
        ( apply
        , apply2
        , apply3
        , apply4
        , compose
        , compose2
        , compose3
        , compose4
        , compose5
        , compose6
        , compose7
        , compose8
        )

{-|
    Functional utilities functions.
@docs apply, apply2, apply3, apply4 , compose, compose2 , compose3 , compose4 , compose5, compose6, compose7, compose8
-}


{-| Apply 1 params.
-}
apply : a -> (a -> b) -> b
apply p1 =
    (|>) p1


{-| Apply 2 params.
-}
apply2 : a -> b -> (a -> b -> c) -> c
apply2 p1 p2 =
    apply p1 >> (|>) p2


{-| Apply 3 params.
-}
apply3 : a -> b -> c -> (a -> b -> c -> d) -> d
apply3 p1 p2 p3 =
    apply2 p1 p2 >> (|>) p3


{-| Apply 4 params.
-}
apply4 : a -> b -> c -> d -> (a -> b -> c -> d -> e) -> e
apply4 p1 p2 p3 p4 =
    apply3 p1 p2 p3 >> (|>) p4


{-| Compose where first function takes 1 parameters
-}
compose : (b -> c) -> (a -> b) -> a -> c
compose f2 f1 =
    (<<) f2 f1


{-| Compose where first function takes 2 parameters
-}
compose2 : (c -> d) -> (a -> b -> c) -> a -> b -> d
compose2 f2 f1 a =
    compose f2 <| f1 a


{-| Compose where first function takes 3 parameters
-}
compose3 : (d -> e) -> (a -> b -> c -> d) -> a -> b -> c -> e
compose3 f2 f1 a =
    compose2 f2 <| f1 a


{-| Compose where first function takes 4 parameters
-}
compose4 : (e -> f) -> (a -> b -> c -> d -> e) -> a -> b -> c -> d -> f
compose4 f2 f1 a =
    compose3 f2 <| f1 a


{-| Compose where first function takes 5 parameters
-}
compose5 : (f -> g) -> (a -> b -> c -> d -> e -> f) -> a -> b -> c -> d -> e -> g
compose5 f2 f1 a =
    compose4 f2 <| f1 a


{-| Compose where first function takes 6 parameters
-}
compose6 : (g -> h) -> (a -> b -> c -> d -> e -> f -> g) -> a -> b -> c -> d -> e -> f -> h
compose6 f2 f1 a =
    compose5 f2 <| f1 a


{-| Compose where first function takes 7 parameters
-}
compose7 : (h -> i) -> (a -> b -> c -> d -> e -> f -> g -> h) -> a -> b -> c -> d -> e -> f -> g -> i
compose7 f2 f1 a =
    compose6 f2 <| f1 a


{-| Compose where first function takes 8 parameters
-}
compose8 : (i -> j) -> (a -> b -> c -> d -> e -> f -> g -> h -> i) -> a -> b -> c -> d -> e -> f -> g -> h -> j
compose8 f2 f1 a =
    compose7 f2 <| f1 a
