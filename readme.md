# Set of Utility functions for Elm programs

> Utilities for Maybe, Result, Json, Tuple and Regex.

## Install

### Elm

Since the Elm Package Manager doesn't allow for Native code and most everything we write at Panoramic Software has some native code in it,
you have to install this library directly from GitHub, e.g. via [elm-github-install](https://github.com/gdotdesign/elm-github-install) or some equivalent mechanism. It's just not worth the hassle of putting libraries into the Elm package manager until it allows native code.

## API

* [Operators](#operators)
* [Dict](#dict)
* [Json](#json)
* [Regex](#regex)
* [Result](#result)
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

This is important if the default is a `Debug.crash`. You don't want it to be evaluated until it's needed. Since Elm is not lazy, we need to have
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
b : Result String Int
b =
	br |??> (\num -> 10 * num) ??= (\_ -> -1)

-- g will be Ok 1230
g : Result String Int
g =
	gr |??> (\num -> 10 * num) ??= -1
```

### Dict

> Zip keys and values together into Dictionary.

When length of keys != lenght of values then whichever runs out first will end the zip.

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
