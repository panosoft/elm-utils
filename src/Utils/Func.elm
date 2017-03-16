module Utils.Func
    exposing
        ( apply2
        , apply3
        , apply4
        )

{-|
    Functional utilities functions.
@docs apply2, apply3, apply4
-}


{-| Apply 2 params.
-}
apply2 : a -> b -> (a -> b -> c) -> c
apply2 p1 p2 =
    (|>) p1 >> (|>) p2


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


{-| Compose where first function takes 2 parameters
-}
compose2 : (c -> d) -> (a -> b -> c) -> a -> b -> d
compose2 f2 f1 a =
    (<<) f2 <| f1 a


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
