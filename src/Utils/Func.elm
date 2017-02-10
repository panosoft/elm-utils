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


{-|
    Apply 2 params.
-}
apply2 : a -> b -> (a -> b -> c) -> c
apply2 p1 p2 =
    (|>) p1 >> (|>) p2


{-|
    Apply 3 params.
-}
apply3 : a -> b -> c -> (a -> b -> c -> d) -> d
apply3 p1 p2 p3 =
    apply2 p1 p2 >> (|>) p3


{-|
    Apply 4 params.
-}
apply4 : a -> b -> c -> d -> (a -> b -> c -> d -> e) -> e
apply4 p1 p2 p3 p4 =
    apply3 p1 p2 p3 >> (|>) p4
