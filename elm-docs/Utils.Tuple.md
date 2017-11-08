# Utils.Tuple

Utility tuple functions.

- [firstMap](#firstmap)
- [secondMap](#secondmap)
- [map2](#map2)
- [map3](#map3)
- [map4](#map4)
- [map5](#map5)
- [map6](#map6)
- [map7](#map7)
- [map8](#map8)
- [map9](#map9)

### **firstMap**
```elm
firstMap : (a -> b) -> List ( a, c ) -> List ( b, c )
```

Map over List on first item of 2-tuple.

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

Map over List on second item of 2-tuple.

```elm
x : List ( Int, String )
x =
    secondMap String.length [ ( 1, "Test" ), ( 2, "Another" ) ]
```

---

### **map2**
```elm
map2 : (a -> b) -> ( a, a ) -> ( b, b )
```

Map over homogeneous 2-tuple

---

### **map3**
```elm
map3 : (a -> b) -> ( a, a, a ) -> ( b, b, b )
```

Map over homogeneous 3-tuple

---

### **map4**
```elm
map4 : (a -> b) -> ( a, a, a, a ) -> ( b, b, b, b )
```

Map over homogeneous 4-tuple

---

### **map5**
```elm
map5 : (a -> b) -> ( a, a, a, a, a ) -> ( b, b, b, b, b )
```

Map over homogeneous 5-tuple

---

### **map6**
```elm
map6 : (a -> b) -> ( a, a, a, a, a, a ) -> ( b, b, b, b, b, b )
```

Map over homogeneous 6-tuple

---

### **map7**
```elm
map7 : (a -> b) -> ( a, a, a, a, a, a, a ) -> ( b, b, b, b, b, b, b )
```

Map over homogeneous 7-tuple

---

### **map8**
```elm
map8 : (a -> b) -> ( a, a, a, a, a, a, a, a ) -> ( b, b, b, b, b, b, b, b )
```

Map over homogeneous 8-tuple

---

### **map9**
```elm
map9 : (a -> b) -> ( a, a, a, a, a, a, a, a, a ) -> ( b, b, b, b, b, b, b, b, b )
```

Map over homogeneous 9-tuple

