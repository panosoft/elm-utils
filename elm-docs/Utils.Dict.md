# Utils.Dict

Utility Dict functions.

- [swap](#swap)
- [zip](#zip)

### **swap**
```elm
swap : Dict comparable comparable_ -> Result String (Dict comparable_ comparable)
```

swap dictionary's keys and values - returns Err if values are NOT unique

---

### **zip**
```elm
zip : List comparable -> List a -> Dict comparable a
```

Zip keys and values together into Dictionary.

When length of keys != length of values then whichever runs out first will end the zip.

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

