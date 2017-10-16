# Utils.Func

Functional utilities functions.

- [apply](#apply)
- [apply2](#apply2)
- [apply3](#apply3)
- [apply4](#apply4)
- [compose](#compose)
- [compose2](#compose2)
- [compose3](#compose3)
- [compose4](#compose4)
- [compose5](#compose5)
- [compose6](#compose6)
- [compose7](#compose7)
- [compose8](#compose8)

### **apply**
```elm
apply : a -> (a -> b) -> b
```

Apply 1 params

---

### **apply2**
```elm
apply2 : a -> b -> (a -> b -> c) -> c
```

Apply 2 params

```elm
log : number -> String -> String -> number
log num prefix1 prefix2 =
    Debug.log (prefix1 ++ prefix2) num

nums : List number
nums =
    List.map (apply2 "prefix1" "prefix2")
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

---

### **apply3**
```elm
apply3 : a -> b -> c -> (a -> b -> c -> d) -> d
```

Apply 3 params

---

### **apply4**
```elm
apply4 : a -> b -> c -> d -> (a -> b -> c -> d -> e) -> e
```

Apply 4 params

---

### **compose**
```elm
compose : (b -> c) -> (a -> b) -> a -> c
```

Compose where first function takes 1 parameters

---

### **compose2**
```elm
compose2 : (c -> d) -> (a -> b -> c) -> a -> b -> d
```

Compose where first function takes 2 parameters

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
    addMult10 2 3


{- 60 -}
```

---

### **compose3**
```elm
compose3 : (d -> e) -> (a -> b -> c -> d) -> a -> b -> c -> e
```

Compose where first function takes 3 parameters

---

### **compose4**
```elm
compose4 : (e -> f) -> (a -> b -> c -> d -> e) -> a -> b -> c -> d -> f
```

Compose where first function takes 4 parameters

---

### **compose5**
```elm
compose5 : (f -> g) -> (a -> b -> c -> d -> e -> f) -> a -> b -> c -> d -> e -> g
```

Compose where first function takes 5 parameters

---

### **compose6**
```elm
compose6 : (g -> h) -> (a -> b -> c -> d -> e -> f -> g) -> a -> b -> c -> d -> e -> f -> h
```

Compose where first function takes 6 parameters

---

### **compose7**
```elm
compose7 : (h -> i) -> (a -> b -> c -> d -> e -> f -> g -> h) -> a -> b -> c -> d -> e -> f -> g -> i
```

Compose where first function takes 7 parameters

---

### **compose8**
```elm
compose8 : (i -> j) -> (a -> b -> c -> d -> e -> f -> g -> h -> i) -> a -> b -> c -> d -> e -> f -> g -> h -> j
```

Compose where first function takes 8 parameters

