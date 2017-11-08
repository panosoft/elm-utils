module Utils.Tuple exposing (..)

{-| Utility tuple functions.

@docs firstMap, secondMap, map2, map3, map4, map5, map6, map7, map8, map9

-}


{-| Map over List on first item of 2-tuple.

    x : List ( Int, String )
    x =
        firstMap (\num -> 10 * num) [ ( 1, "Test" ), ( 2, "Another" ) ]

-}
firstMap : (a -> b) -> List ( a, c ) -> List ( b, c )
firstMap f =
    List.map (\( x, y ) -> ( f x, y ))


{-| Map over List on second item of 2-tuple.

    x : List ( Int, String )
    x =
        secondMap String.length [ ( 1, "Test" ), ( 2, "Another" ) ]

-}
secondMap : (b -> c) -> List ( a, b ) -> List ( a, c )
secondMap f =
    List.map (\( x, y ) -> ( x, f y ))


{-| Map over homogeneous 2-tuple
-}
map2 : (a -> b) -> ( a, a ) -> ( b, b )
map2 f ( a, b ) =
    ( f a, f b )


{-| Map over homogeneous 3-tuple
-}
map3 : (a -> b) -> ( a, a, a ) -> ( b, b, b )
map3 f ( a, b, c ) =
    ( f a, f b, f c )


{-| Map over homogeneous 4-tuple
-}
map4 : (a -> b) -> ( a, a, a, a ) -> ( b, b, b, b )
map4 f ( a, b, c, d ) =
    ( f a, f b, f c, f d )


{-| Map over homogeneous 5-tuple
-}
map5 : (a -> b) -> ( a, a, a, a, a ) -> ( b, b, b, b, b )
map5 f ( a, b, c, d, e ) =
    ( f a, f b, f c, f d, f e )


{-| Map over homogeneous 6-tuple
-}
map6 : (a -> b) -> ( a, a, a, a, a, a ) -> ( b, b, b, b, b, b )
map6 f ( a, b, c, d, e, g ) =
    ( f a, f b, f c, f d, f e, f g )


{-| Map over homogeneous 7-tuple
-}
map7 : (a -> b) -> ( a, a, a, a, a, a, a ) -> ( b, b, b, b, b, b, b )
map7 f ( a, b, c, d, e, g, h ) =
    ( f a, f b, f c, f d, f e, f g, f h )


{-| Map over homogeneous 8-tuple
-}
map8 : (a -> b) -> ( a, a, a, a, a, a, a, a ) -> ( b, b, b, b, b, b, b, b )
map8 f ( a, b, c, d, e, g, h, i ) =
    ( f a, f b, f c, f d, f e, f g, f h, f i )


{-| Map over homogeneous 9-tuple
-}
map9 : (a -> b) -> ( a, a, a, a, a, a, a, a, a ) -> ( b, b, b, b, b, b, b, b, b )
map9 f ( a, b, c, d, e, g, h, i, j ) =
    ( f a, f b, f c, f d, f e, f g, f h, f i, f j )
