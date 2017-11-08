# Utils.Task

Utility Task functions.

- [untilSuccess](#untilsuccess)
- [andThenIf](#andthenif)
- [sequence2](#sequence2)
- [sequence3](#sequence3)
- [sequence4](#sequence4)
- [sequence5](#sequence5)
- [sequence6](#sequence6)
- [sequence7](#sequence7)
- [sequence8](#sequence8)
- [sequence9](#sequence9)

### **untilSuccess**
```elm
untilSuccess : x -> List (Task x a) -> Task x a
```

Execute a list of Tasks from left to right sequentially
until one succeeds at which point processing of the list is terminated.

If all tasks fail then the `failureValue` is the result of the combined Task.

```elm
tasks : Task String Int
tasks =
    untilSuccess "None succeeded" [ Task.fail "nope", Task.succeed 1, Task.fail "never gets executed", Task.succeed 2 ]
```

---

### **andThenIf**
```elm
andThenIf : Bool -> ( a -> Task x b, a -> Task x b ) -> Task x a -> Task x b
```

Conditional Task.andThen

This function helps reduces code clutter (by 2 lines).

```elm
with : Bool -> Task String ()
with flag =
    Task.succeed ()
        |> Task.andThen (\_ -> Task.succeed ())
        |> andThenIf flag
            ( \_ -> Task.succeed ()
            , always <| Task.fail "flag not set"
            )

without : Bool -> Task String ()
without flag =
    Task.succeed ()
        |> Task.andThen (\_ -> Task.succeed ())
        |> Task.andThen
            (flag
                ? ( \_ -> Task.succeed ()
                  , always <| Task.fail "flag not set"
                  )
            )
```

---

### **sequence2**
```elm
sequence2 : ( Task x a, Task x b ) -> Task x ( a, b )
```

Sequence 2 Tasks of similar error types but differing success types

This function helps reduces indent hell especially with higher numbers of tasks.

Old way:

```elm
getCountTask
    |> Task.andThen
        (\count ->
            getNameTask
                |> Task.andThen (\name -> name ++ ":" ++ count)
        )

```

New way:

```elm
( getCountTask, getNameTask )
    |> sequence2
    |> Task.andThen (\( count, name ) -> name ++ ":" ++ count)
```

---

### **sequence3**
```elm
sequence3 : ( Task x a, Task x b, Task x c ) -> Task x ( a, b, c )
```

Sequence 3 Tasks of similar error types but differing success types

---

### **sequence4**
```elm
sequence4 : ( Task x a, Task x b, Task x c, Task x d ) -> Task x ( a, b, c, d )
```

Sequence 4 Tasks of similar error types but differing success types

---

### **sequence5**
```elm
sequence5 : ( Task x a , Task x b , Task x c , Task x d , Task x e ) -> Task x ( a, b, c, d, e )
```

Sequence 5 Tasks of similar error types but differing success types

---

### **sequence6**
```elm
sequence6 : ( Task x a , Task x b , Task x c , Task x d , Task x e , Task x f ) -> Task x ( a, b, c, d, e, f )
```

Sequence 6 Tasks of similar error types but differing success types

---

### **sequence7**
```elm
sequence7 : ( Task x a , Task x b , Task x c , Task x d , Task x e , Task x f , Task x g ) -> Task x ( a, b, c, d, e, f, g )
```

Sequence 7 Tasks of similar error types but differing success types

---

### **sequence8**
```elm
sequence8 : ( Task x a , Task x b , Task x c , Task x d , Task x e , Task x f , Task x g , Task x h ) -> Task x ( a, b, c, d, e, f, g, h )
```

Sequence 8 Tasks of similar error types but differing success types

---

### **sequence9**
```elm
sequence9 : ( Task x a , Task x b , Task x c , Task x d , Task x e , Task x f , Task x g , Task x h , Task x i ) -> Task x ( a, b, c, d, e, f, g, h, i )
```

Sequence 9 Tasks of similar error types but differing success types

