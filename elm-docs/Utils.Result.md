# Utils.Result

Utility Result functions.

- [filterErr](#filtererr)
- [filterOk](#filterok)

### **filterErr**
```elm
filterErr : List (Result error x) -> List error
```

Filter Errors from a List of Results.

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

---

### **filterOk**
```elm
filterOk : List (Result x value) -> List value
```

Filter Oks from a List of Results.

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

