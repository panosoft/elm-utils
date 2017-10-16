# Utils.Tuple

Utility tuple functions.

- [firstMap](#firstmap)
- [secondMap](#secondmap)

### **firstMap**
```elm
firstMap : (a -> b) -> List ( a, c ) -> List ( b, c )
```

Map on first item of 2-tuple.

```elm
x : List ( Int, String )
x =
    firstMap (\num -> 10 * num) [ ( 1, "Test" ), ( 2, "Another" ) ]
```

---

### **secondMap**
```elm
secondMap : (b -> c) -> List ( a, b ) -> List ( a, c )
```

Map on second item of 2-tuple.

```elm
x : List ( Int, String )
x =
    secondMap String.length [ ( 1, "Test" ), ( 2, "Another" ) ]
```

