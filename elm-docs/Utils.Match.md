# Utils.Match

Utility Regex Match functions.

- [extract1](#extract1)
- [extract2](#extract2)
- [extract3](#extract3)
- [extract4](#extract4)
- [getSubmatches1](#getsubmatches1)
- [getSubmatches2](#getsubmatches2)
- [getSubmatches3](#getsubmatches3)
- [getSubmatches4](#getsubmatches4)

### **extract1**
```elm
extract1 : Regex.Match -> Maybe (Maybe String)
```

extract 1 submatch

---

### **extract2**
```elm
extract2 : Regex.Match -> Maybe ( Maybe String, Maybe String )
```

Extract 2 from submatch

```elm
import Regex exposing (..)
import Utils.Match exposing (..)

str : String
str =
    "First second"

parseStr : ( Maybe String, Maybe String )
parseStr =
    (str
        |> find (AtMost 1) (regex "(\\w+)\\s+(\\w+)")
        |> List.head
    )
        |?!->
            ( \_ -> Debug.crash "no match"
            , extract2
            )
        ?!= (\_ -> Debug.crash "2 submatches not found")
```

---

### **extract3**
```elm
extract3 : Regex.Match -> Maybe ( Maybe String, Maybe String, Maybe String )
```

extract 3 submatches

---

### **extract4**
```elm
extract4 : Regex.Match -> Maybe ( Maybe String , Maybe String , Maybe String , Maybe String )
```

extract 4 submatches

---

### **getSubmatches1**
```elm
getSubmatches1 : Regex.Match -> String
```

get 1 submatch (WILL CRASH IF 1 DOESN'T EXIST!!!!!!)

---

### **getSubmatches2**
```elm
getSubmatches2 : Regex.Match -> ( String, String )
```

Get 2 submatches (WILL CRASH IF 2 DON'T EXIST!!!!!!)

```elm
import Regex exposing (..)
import Utils.Match exposing (..)

str : String
str =
    "First second"

parseStr : ( String, String )
parseStr =
    (str
        |> find (AtMost 1) (regex "(\\w+)\\s+(\\w+)")
        |> List.head
    )
        |?> getSubmatches2
        ?!= (\_ -> Debug.crash "no match")
```

---

### **getSubmatches3**
```elm
getSubmatches3 : Regex.Match -> ( String, String, String )
```

get 3 submatches (WILL CRASH IF 3 DON'T EXIST!!!!!!)

---

### **getSubmatches4**
```elm
getSubmatches4 : Regex.Match -> ( String, String, String, String )
```

get 4 submatches (WILL CRASH IF 4 DON'T EXIST!!!!!!)

