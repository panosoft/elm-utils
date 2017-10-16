# Utils.Ops

Utility operators.

  - [Boolean](#boolean)
  - [List](#list)
  - [Maybe](#maybe)
  - [Result](#result)


# Boolean

- [(?)](#)
- [(?!)](#-1)

### **(?)**
```elm
(?) : Bool -> ( a, a ) -> a
```

Simplify `if` syntax on a single line.

```elm
x : Int
x =
    2


-- y will be "not one"

y : String
y =
    x == 1 ? ( "one", "not one" )
```

---

### **(?!)**
```elm
(?!) : Bool -> ( () -> a, () -> a ) -> a
```

Lazy version of ? operator for recursion or expensive functions that you don't want executed.

```elm
fact : Int -> Int
fact n =
    (n <= 1) ?! ( \_ -> 1, \_ -> n * (fact <| n - 1) )
```


# List

- [(!!)](#-2)

### **(!!)**
```elm
(!!) : List a -> Int -> Maybe a
```

Get item from List at index

```elm
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
```


# Maybe

- [(?=)](#-3)
- [(?!=)](#-4)
- [(|?>)](#-5)
- [(|?->)](#-)
- [(|?!->)](#--1)
- [(|?-->)](#--)
- [(|?!-->)](#---1)
- [(|?--->)](#---)
- [(|?!--->)](#----1)
- [(|?**>)](#-6)
- [(|?!**>)](#-7)
- [(|?***>)](#-8)
- [(|?!***>)](#-9)
- [(|?****>)](#-10)
- [(|?!****>)](#-11)

### **(?=)**
```elm
(?=) : Maybe a -> a -> a
```

Maybe with default operator.

Simplify `Maybe.withDefault` syntax

```elm
x : Int
x =
    Just 1 ?= -1


-- y will be -1

y : Int
y =
    Nothing ?= -1
```

---

### **(?!=)**
```elm
(?!=) : Maybe a -> (() -> a) -> a
```

Lazy version of ?= operator. (Since Elm is eager).

This is important if the default is a `Debug.crash` (or any side-effect function). You don't want it to be evaluated until it's needed. Since Elm is not lazy, we need to have
special version of this.

```elm
x : Maybe Int
x =
    Nothing

crashIfNothing : Int
crashIfNothing =
    x ?!= (\_ -> Debug.crash "x cannot be Nothing, must be a internal programming bug")
```

---

### **(|?>)**
```elm
(|?>) : Maybe a -> (a -> b) -> Maybe b
```

Maybe.map operator

Simplify `Maybe.map` syntax.

```elm
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
```

---

### **(|?->)**
```elm
(|?->) : Maybe a -> ( b, a -> b ) -> b
```

Maybe.map combined with Maybe.withDefault (or |?> combined with ?=)

This combines two operators with the error case first, i.e. the Nothing.

```elm
x : Maybe Int
x =
    Nothing

y : Int
y =
    x |?-> ( 0, \x -> x * 10 )
```

---

### **(|?!->)**
```elm
(|?!->) : Maybe a -> ( () -> b, a -> b ) -> b
```

Lazy version of (|?->)

The lazy version for side-effect functions, i.e. Debug.log.

```elm
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
```

---

### **(|?-->)**
```elm
(|?-->) : Maybe (Maybe a) -> ( b, a -> b ) -> b
```

Double version of (|?->)

Same as (|?->) but used with `Maybe (Maybe a)` instead of just `Maybe a`.

```elm
x : Maybe (Maybe Int)
x =
    Nothing

y : Int
y =
    x |?--> ( 0, \x -> x * 10 )
```

---

### **(|?!-->)**
```elm
(|?!-->) : Maybe (Maybe a) -> ( () -> b, a -> b ) -> b
```

Lazy version of (|?-->)

```elm
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
```

---

### **(|?--->)**
```elm
(|?--->) : Maybe (Maybe (Maybe a)) -> ( b, a -> b ) -> b
```

Triple version of (|?->)

---

### **(|?!--->)**
```elm
(|?!--->) : Maybe (Maybe (Maybe a)) -> ( () -> b, a -> b ) -> b
```

Lazy version of (|?--->)

---

### **(|?\*\*>)**
```elm
(|?**>) : ( Maybe a, Maybe b ) -> ( c, c, ( a, b ) -> c ) -> c
```

(|?->) for 2-tuple of Maybe's

Useful when 2 maybes need defaults.

```elm
x : Maybe Int
x =
    Just 1

y : Maybe Int
y =
    Nothing

z : Int
z =
    ( x, y ) |?**> ( 0, 0, \( x, y ) -> x + y )
```

---

### **(|?!\*\*>)**
```elm
(|?!**>) : ( Maybe a, Maybe b ) -> ( () -> c, () -> c, ( a, b ) -> c ) -> c
```

Lazy version of `(|?**>)`

Useful when 2 maybes must have defaults or must not be `Nothing`.

```elm
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
```

---

### **(|?\*\*\*>)**
```elm
(|?***>) : ( Maybe a, Maybe b, Maybe c ) -> ( d, d, d, ( a, b, c ) -> d ) -> d
```

(|?->) for 3-tuple of Maybe's

---

### **(|?!\*\*\*>)**
```elm
(|?!***>) : ( Maybe a, Maybe b, Maybe c ) -> ( () -> d, () -> d, () -> d, ( a, b, c ) -> d ) -> d
```

Lazy version of `(|?***>)`

---

### **(|?\*\*\*\*>)**
```elm
(|?****>) : ( Maybe a, Maybe b, Maybe c, Maybe d ) -> ( e, e, e, e, ( a, b, c, d ) -> e ) -> e
```

(|?->) for 4-tuple of Maybe's

---

### **(|?!\*\*\*\*>)**
```elm
(|?!****>) : ( Maybe a, Maybe b, Maybe c, Maybe d ) -> ( () -> e, () -> e, () -> e, () -> e, ( a, b, c, d ) -> e ) -> e
```

Lazy version of `(|?***>)`


# Result

- [(|??>)](#-12)
- [(??=)](#-13)
- [(|??->)](#--2)
- [(|??-->)](#---2)
- [(|??**>)](#-14)
- [(|??***>)](#-15)
- [(|??****>)](#-16)

### **(|??>)**
```elm
(|??>) : Result a b -> (b -> c) -> Result a c
```

Result.map operator

Simplified `Result.map` syntax.

```elm
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
```

---

### **(??=)**
```elm
(??=) : Result err value -> (err -> value) -> value
```

Simplified `Result.default` syntax.
This is different from Maybe.default since the Error Type may be different then the Ok Type in a Result.
This is why a function is passed to convert the Error Value to a value of Ok Type.

```elm
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
```

---

### **(|??->)**
```elm
(|??->) : Result a b -> ( a -> c, b -> c ) -> c
```

Result.map combined with (??=) (or |??> combined with ??=)

This combines two operators with the error case first.

```elm
br : Result String Int
br =
    Err "Bad Things Happened"


-- b will be -1

b : Int
b =
    br |??-> ( \_ -> -1, \num -> 10 * num )
```

---

### **(|??-->)**
```elm
(|??-->) : Result a (Result b c) -> ( a -> d, b -> d, c -> d ) -> d
```

Double version of (|?->)

```elm
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
```

---

### **(|??\*\*>)**
```elm
(|??**>) : ( Result x a, Result x b ) -> ( x -> c, x -> c, ( a, b ) -> c ) -> c
```

(|??->) for 2-tuple of Results

```elm
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
```

---

### **(|??\*\*\*>)**
```elm
(|??***>) : ( Result x a, Result x b, Result x c ) -> ( x -> d, x -> d, x -> d, ( a, b, c ) -> d ) -> d
```

(|??->) for 3-tuple of Results

---

### **(|??\*\*\*\*>)**
```elm
(|??****>) : ( Result x a , Result x b , Result x c , Result x d ) -> ( x -> e, x -> e, x -> e, x -> e, ( a, b, c, d ) -> e ) -> e
```

(|??->) for 4-tuple of Results

