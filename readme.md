# Set of Utility functions for Elm programs

> Utilities for Maybe, Result, Json, Tuple and Regex.

## Install

### Elm

Since the Elm Package Manager doesn't allow for Native code and most everything we write at Panoramic Software has some native code in it,
you have to install this library directly from GitHub, e.g. via [elm-github-install](https://github.com/gdotdesign/elm-github-install) or some equivalent mechanism. It's just not worth the hassle of putting libraries into the Elm package manager until it allows native code.

## API

* [Ops](#operators)
* [Dict](#dict)
* [Error](#error)
* [Func](#func)
* [Json](#json)
* [Log](#log)
* [Record](#record)
* [Regex](#regex)
* [Result](#result)
* [Task](#task)
* [Tuple](#tuple)

### Operators

> Inline if operator.

Simplify `if` syntax on a single line.

```elm
(?) : Bool -> ( a, a ) -> a
(?) bool ( t, f )
```

__Usage__

```elm
x : Int
x =
	2

-- y will be "not one"
y : String
y =
	x == 1 ? ("one", "not one")
```
> Lazy version of ? operator for recursion or expensive functions that you don't want executed.

```elm
(?!) : Bool -> ( () -> a, () -> a ) -> a
(?!) bool ( tf, ff )
```
__Usage__

```elm
fact : Int -> Int
fact n =
	(n <= 1) ?! (\_ -> 1, \_ -> n * (fact <| n - 1) )
```
> Maybe with default operator.

Simplify `Maybe.withDefault` syntax

```elm
(?=) : Maybe a -> a -> a
(?=)
```

__Usage__

```elm
-- x will be 1
x : Int
x =
	Just 1 ?= -1

-- y will be -1
y : Int
y =
	Nothing ?= -1
```

> Lazy version of ?= operator. (Since Elm is eager).

This is important if the default is a `Debug.crash` (or any side-effect function). You don't want it to be evaluated until it's needed. Since Elm is not lazy, we need to have
special version of this.

```elm
(?!=) : Maybe a -> (() -> a) -> a
(?!=) maybe lazy
```

__Usage__

```elm
x : Maybe Int
x =
	Nothing

crashIfNothing : Int
crashIfNothing =
	x ?!= (\_ -> Debug.crash "x cannot be Nothing, must be a internal programming bug")
```

> Maybe.map operator.

Simplify `Maybe.map` syntax.

```elm
(|?>) : Maybe a -> (a -> b) -> Maybe b
(|?>)
```

__Usage__

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

> Maybe.map combined with Maybe.withDefault (or |?> combined with ?=)

This combines two operators with the error case first, i.e. the Nothing.

```elm
(|?->) : Maybe a -> ( b, a -> b ) -> b
(|?->) ma ( vma, f )
```

__Usage__

```elm
x : Maybe Int
x =
    Nothing

y : Int
y =
    x |?-> ( 0, \x -> x * 10 )
```

> Lazy version of (|?->)

The lazy version for side-effect functions, i.e. Debug.log.

```elm
(|?!->) : Maybe a -> ( () -> b, a -> b ) -> b
(|?!->) ma ( fma, f )
```
__Usage__

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

> Double version of (|?->)

Same as (|?->) but used with `Maybe (Maybe a)` instead of just `Maybe a`.

```elm
(|?-->) : Maybe (Maybe a) -> ( b, b, a -> b ) -> b
(|?-->) mma ( vmma, vma, f )
```

__Usage__

```elm
x : Maybe (Maybe Int)
x =
    Nothing

y : Int
y =
    x |?--> ( 0, \x -> x * 10 )
```

> Lazy version of (|?-->)

```elm
(|?!-->) : Maybe (Maybe a) -> ( () -> b, a -> b ) -> b
(|?!-->) mma ( fmma, f )
```

__Usage__

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

> Triple version of (|?->)

```elm
(|?--->) : Maybe (Maybe (Maybe a)) -> ( b, a -> b ) -> b
(|?--->) mmma ( vmmma, f )
```



> Lazy version of (|?--->)

```elm
(|?!--->) : Maybe (Maybe (Maybe a)) -> ( () -> b, a -> b ) -> b
(|?!--->) mmma ( fmmma, f )
```

> (|?->) for 2-tuple of Maybe's

Useful when 2 maybes need defaults.

```elm
(|?**>) : ( Maybe a, Maybe b ) -> ( c, c, ( a, b ) -> c ) -> c
(|?**>) ( ma, mb ) ( va, vb, f )
```

__Usage__

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

> Lazy version of (|?\**>)

Useful when 2 maybes must have defaults or must not be `Nothing`.

```elm
(|?!**>) : ( Maybe a, Maybe b ) -> ( () -> c, () -> c, ( a, b ) -> c ) -> c
(|?!**>) ( ma, mb ) ( fa, fb, f )
```

__Usage__

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

> (|?->) for 3-tuple of Maybe's

```elm
(|?***>) : ( Maybe a, Maybe b, Maybe c ) -> ( d, d, d, ( a, b, c ) -> d ) -> d
(|?***>) ( ma, mb, mc ) ( va, vb, vc, f )
```

> Lazy version of (|?\***>)

```elm
(|?!***>) : ( Maybe a, Maybe b, Maybe c ) -> ( () -> d, () -> d, () -> d, ( a, b, c ) -> d ) -> d
(|?!***>) ( ma, mb, mc ) ( fa, fb, fc, f )
```

> Result.map operator.

Simplified `Result.map` syntax.

```elm
(|??>) : Result a b -> (b -> c) -> Result a c
(|??>)
```

__Usage__

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

> Result default operator. This is different from Maybe.default since the Error Type may be different then the Ok Type in a Result.
This is why a function is passed to convert the Error Value to a value of Ok Type.

Simplified `Result.default` syntax.

```elm
(??=) : Result err value -> (err -> value) -> value
(??=) result f
```

__Usage__

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

> Result.map combined with (??=) (or |??> combined with ??=)

This combines two operators with the error case first.

```elm
(|??->) : Result a b -> ( a -> c, b -> c ) -> c
(|??->) r ( fr, f )
```

__Usage__

```elm
br : Result String Int
br =
    Err "Bad Things Happened"

-- b will be -1
b : Int
b =
    br |??-> ( \_ -> -1, \num -> 10 * num )
```

> Double version of (|?->)

```elm
(|??-->) : Result a (Result b c) -> ( a -> d, b -> d, c -> d ) -> d
(|??-->) rr ( frr, fr, f )
```

__Usage__

```elm
crash : String -> (a -> b)
crash error =
    (\_ -> Debug.crash error)

br : Result String (Result String Int)
br =
    Ok <| Err "Bad Things Happened"

-- b will be -1
b : Int
b =
	br
        |??-->
            ( crash "fatal error"
            , \_ -> -1
            , \num -> 10 * num
            )
```


### Dict

> Swap keys with values. Returns Err if values are not unique.

```elm
swap : Dict comparable comparable_ -> Result String (Dict comparable_ comparable)
swap dict
```

> Zip keys and values together into Dictionary.

When length of keys != length of values then whichever runs out first will end the zip.

```elm
zip : List comparable -> List a -> Dict comparable a
zip keys values
```

__Usage__

```elm
keys : String
keys =
	[ "a"
	, "b"
	, "c"
	]

values : Int
values =
	[ 1
	, 2
	, 3
	]

dict : Dict String Int
dict =
	zip keys values
```

### Error

> Error Types.

```elm
type ErrorType
    = FatalError
    | NonFatalError
    | RetryableError
```

### Func

> Apply 2 params.

```elm
apply2 : a -> b -> (a -> b -> c) -> c
```

__Usage__

```elm
log : number -> String -> String -> number
log num prefix1 prefix2 =
	Debug.log (prefix1 ++ prefix2) num

nums : List number
nums = List.map (apply2 "prefix1" "prefix2")
	[ log 1
	, log 2
	]

{-
	nums = [1, 2]

	Outputs to console:

		prefix1prefix2: 1
		prefix1prefix2: 2

-}
```

> Apply 3 and 4 params.

```elm
apply3 : a -> b -> c -> (a -> b -> c -> d) -> d
apply4 : a -> b -> c -> d -> (a -> b -> c -> d -> e) -> e
```

> Compose where first function takes 2 parameters

```elm
compose2 : (c -> d) -> (a -> b -> c) -> a -> b -> d
```

__Usage__

```elm
add : number -> number -> number
add a b =
	a + b

mult10 : number -> number
mult10 x =
	x * 10

addMult10 : number -> number -> number
addMult10 =
	compose2 mult10 add

x : number
x =
	addMult10 2 3 {- 60 -}
```
> Compose where first function takes 3, 4 and 5 parameters

```elm
compose3 : (d -> e) -> (a -> b -> c -> d) -> a -> b -> c -> e
compose4 : (e -> f) -> (a -> b -> c -> d -> e) -> a -> b -> c -> d -> f
compose5 : (f -> g) -> (a -> b -> c -> d -> e -> f) -> a -> b -> c -> d -> e -> g
```

### Json

> Operator to allow stringing decoders together to construct a record via its constructor.


```elm
(<||) : JD.Decoder (a -> b) -> JD.Decoder a -> JD.Decoder b
(<||)
```

__Usage__

```elm
type alias User =
	{ name : String
	, age : Int
	, amount : Float
	, twelve : Int
	, address : Address
	}

userDecoder : Json.Decoder User
userDecoder =
	Json.succeed User
		<|| ("name" := string)
		<|| ("age" := int)
		<|| ("amount" := float)
		<|| Json.succeed 12
		<|| ("address" := addressDecoder)
```

> Operator to provide a default for a Decoder.

```elm
(///) : JD.Decoder a -> a -> JD.Decoder a
(///) decoder default
```

__Usage__

```elm
type alias User =
	{ name : String
	, age : Int
	, amount : Float
	, twelve : Int
	, address : Address
	}

userDecoder : Json.Decoder User
userDecoder =
	Json.succeed User
		<|| ("name" := string)
		<|| ("age" := int)
		<|| (("amount" := float) /// 100)
		<|| Json.succeed 12
		<|| ("address" := addressDecoder)
```

> Convenience function for encoding a Maybe with a encoder and NULL default.

```elm
encMaybe : (a -> JE.Value) -> Maybe a -> JE.Value
encMaybe encoder maybe
```

__Usage__

```elm
import Json.Encode as JE exposing (..)

JE.encode 0 <|
	JE.object
		[ ( "street", Json.encMaybe JE.string address.street )
		, ( "city", Json.encMaybe JE.string address.city )
		, ( "state", Json.encMaybe JE.string address.state )
		, ( "zip", Json.encMaybe JE.string address.zip )
		]
```

> Convenience function for encoding a Dictionary to a JS object of the following form:

```js
{
	keys: [
		// keys encoded here
	],
	values: [
		// values encoded here
	]
}
```

```elm
encDict : (comparable -> JE.Value) -> (value -> JE.Value) -> Dict comparable value -> JE.Value
encDict keyEncoder valueEncoder dict
```

__Usage__

```elm
import Json.Encode as JE exposing (..)

type alias Model =
	{ ids : Dict Int (Set String)
	, ages : Dict String Int
	}

JE.encode 0 <|
	JE.object
		[ ( "ids", Json.encDict JE.int (JE.list << List.map JE.string << Set.toList) model.ids )
		, ( "ages", Json.encDict JE.string JE.int model.ages )
		]
```

> Convenience function for decoding a Dictionary WITH a value converstion function from a JS object of the following form:

```js
{
	keys: [
		// keys encoded here
	],
	values: [
		// values encoded here
	]
}
```

```elm
decConvertDict : (a -> value) -> Decoder comparable -> Decoder a -> Decoder (Dict comparable value)
decConvertDict valuesConverter keyDecoder valueDecoder
```

__Usage__

```elm
import Json.Decode as JD exposing (..)

type alias Model =
	{ ids : Dict Int (Set String)
	, ages : Dict String Int
	}

-- here json is a JSON string that was generated by encDict
JD.decodeString
	((JD.succeed Model)
		<|| ("ids" := Json.decConvertDict Set.fromList JD.int (JD.list JD.string))
		<|| ("ages" := Json.decDict JD.string JD.int)
	)
	json
```

> Convenience function for decoding a Dictionary WITHOUT a value conversion function.

from a JS object of the following form:

```js
{
   keys: [
	   // keys encoded here
   ],
   values: [
	   // values encoded here
   ]
}
```

```elm
decDict : Decoder comparable -> Decoder value -> Decoder (Dict comparable value)
decDict keyDecoder valueDecoder
```

__Usage__

```elm
import Json.Decode as JD exposing (..)

type alias Model =
   { ids : Dict Int (Set String)
   , ages : Dict String Int
   }

-- here json is a JSON string that was generated by encDict
JD.decodeString
   ((JD.succeed Model)
	   <|| ("ids" := Json.decConvertDict Set.fromList JD.int (JD.list JD.string))
	   <|| ("ages" := Json.decDict JD.string JD.int)
   )
   json
```

> Elm Result encoder

Will create a JS object with either an `okay` key or an `error` key.

```elm
resultEncoder : (error -> JE.Value) -> (okay -> JE.Value) -> Result error okay -> JE.Value
resultEncoder errorEncoder okayEncoder result
```

* `errorEncoder` is an encoder for the `error` type
* `okayEncoder` is an encoder for the `okay` type

__Usage__

```elm
import Json.Encode as JE exposing (..)

type alias Thing =
    { id : Int
    , result : Result String Int
    }


thingEncoder : Thing -> JE.Value
thingEncoder thing =
    JE.object
        [ ( "id", JE.int thing.id )
        , ( "result", resultEncoder JE.string JE.int thing.result )
        ]
```

> Elm Result decoder

Expects a JS object with either an `okay` key or an `error` key.

```elm
resultDecoder : Decoder error -> Decoder okay -> Decoder (Result error okay)
resultDecoder errorDecoder okayDecoder
```

* `errorDecoder` is an decoder for the `error` type
* `okayDecoder` is an decoder for the `okay` type

__Usage__

```elm
import Json.Decode as JD exposing (..)

type alias Thing =
    { id : Int
    , result : Result String Int
    }

thingDecoder : Decoder Thing
thingDecoder =
    (JD.succeed Thing)
        <|| (field "id" JD.int)
        <|| (field "result" <| resultDecoder JD.string JD.int)
```

> Encode Elm Result

Will create a JS object with either an `okay` key or an `error` key.

```elm
resultEncode : (error -> JE.Value) -> (okay -> JE.Value) -> Result error okay -> String
resultEncode errorEncoder okayEncoder result
```

__Usage__

```elm
import Json.Encode as JE exposing (..)

type alias MyResult =
    Result String Int


encodedErrorResult : String
encodedErrorResult =
    resultEncode JE.string JE.int <| Err "This is an error"


encodedOkayResult : String
encodedOkayResult =
    resultEncode JE.string JE.int <| Ok 123
```

> Decode Elm Result

Expects a JS object with either an `okay` key or an `error` key.

```elm
resultDecode : Decoder error -> Decoder okay -> String -> Result String (Result error okay)
resultDecode = errorEncoder okayEncoder
```

__Usage__

```elm
type alias MyResult =
    Result String Int


decodedErrorResult : Result String MyResult
decodedErrorResult =
    resultDecode JD.string JD.int """{"error": "This is an error"}"""


decodedOkayResult : Result String MyResult
decodedOkayResult =
    resultDecode JD.string JD.int """{"okay": 123}"""
```

### Log

> Log Level.

```elm
type LogLevel
    = LogLevelFatal
    | LogLevelError
    | LogLevelWarn
    | LogLevelInfo
    | LogLevelDebug
    | LogLevelTrace
```

### Record

> Make a record into a comparable string for use as a key in a Dict

```elm
makeComparable : List (a -> String) -> a -> String
makeComparable recordStringGetters record
```

__Usage__

```elm

import Utils.Record as Record

type alias DbConnectionInfo =
    { host : String
    , port_ : Int
    , database : String
    , user : String
    , password : String
    , timeout : Int
    }


{-| make connection info comparable for Dictionaries
-}
makeComparable : DbConnectionInfo -> String
makeComparable =
    Record.makeComparable
        [ .host
        , toString << .port_
        , .database
        , .user
        , .password
        ]
```

`timeout` was left out on purpose in this example.

### Regex

> Simple replacer for Regex.

```elm
simpleReplacer : String -> (Match -> String)
simpleReplacer new
```

__Usage__

```elm
Regex.replace All "\\d" "*" "x9y8z7" simpleReplacer == "x*y*z*"
```

> General replace.

```elm
replace : HowMany -> String -> (Match -> String) -> String -> String
replace howMany r replacer old
```

__Usage__

```elm
replace All "\\d" (simpleReplacer "_") "a1b2c3" == "a_b_c_"
replace All "(\\d)([a-z])" (parametricReplacer "-$1$2$$2$3") "6a7b8c" == "-6a$2$3-7b$2$3-8c$2$3"
```

> General simplified replace of specified number of occurrences.

```elm
replaceSimple : HowMany -> String -> String -> String -> String
replaceSimple howMany r new old
```

__Usage__

```elm
replaceSimple All "\\d" "_" "a1b2c3" == "a_b_c_"
```

> Simple replacement of ALL occurrences.

```elm
replaceAll : String -> String -> String -> String
replaceAll r new old
```

__Usage__

```elm
replaceAll "\\d" "_" "a1b2c3" == "a_b_c_"
```

> Simple replacement of FIRST occurrence.

```elm
replaceFirst : String -> String -> String -> String
replaceFirst r new old
```

__Usage__

```elm
replaceFirst "\\d" "_" "a1b2c3" == "a_b2c3"
```

> Parametric replacer for Regex that supports $1, $2, ... $9 Parametric Replacements

> N.B. $$ is an escape for $, e.g. $$1 will be $1 in the output

> N.B. any $n that isn't specified in the regular expression is untouched in the output

```elm
parametricReplacer : String -> (Match -> String)
parametricReplacer new
```

__Usage__

```elm
Regex.replace All (regex "(\\d)([a-z])") (parametricReplacer "-$1$2$$2$3") "6a7b8c" == "-6a$2$3-7b$2$3-8c$2$3"
Regex.replace (AtMost 2) (regex "(\\d)([a-z])") (parametricReplacer "-$1$2$$2$3") "6a7b8c" == "-6a$2$3-7b$2$38c"
```

### Result

> Filter Errors from a List of Results.

```elm
filterErr : List (Result error x) -> List error
filterErr results
```

__Usage__

```elm
results : Result String Int
results =
	[ Err "bad"
	, Ok 123
	, Err "bad2"
	]

-- errorsOnly will be ["bad", "bad2"]
errorsOnly : List String
errorsOnly =
	filterErr results
```

> Filter Oks from a List of Results.

```elm
filterOk : List (Result x value) -> List value
filterOk results
```

__Usage__

```elm
results : Result String Int
results =
	[ Err "bad"
	, Ok 123
	, Err "bad2"
	]

-- oksOnly will be [123]
oksOnly : List String
oksOnly =
	filterOk results
```

### Task

> Exectute a list of Tasks from left to right sequentially
until one succeeds at which point processing of the list is terminated.

```elm
untilSuccess : x -> List (Task x a) -> Task x a
untilSuccess failureValue tasks
```

If all tasks fail then the `failureValue` is the result of the combined Task.

__Usage__

```elm
tasks : Task String Int
tasks =
    untilSuccess "None succeeded" [ Task.fail "nope", Task.succeed 1, Task.fail "never gets executed", Task.succeed 2 ]
```

### Tuple

> Map on first item of 2-tuple.

```elm
firstMap : (a -> b) -> List ( a, c ) -> List ( b, c )
firstMap f
```

__Usage__

```elm
-- x will be [(10, "Test"), (20, "Another")]
x : List (Int, String)
x = firstMap (\num -> 10 * num) [(1, "Test"), (2, "Another")]
```

> Map on second item of 2-tuple.

```elm
secondMap : (b -> c) -> List ( a, b ) -> List ( a, c )
secondMap f
```

__Usage__

```elm
-- x will be [(1, 4), (2, 7)]
x : List (Int, String)
x = secondMap String.length [(1, "Test"), (2, "Another")]
```
