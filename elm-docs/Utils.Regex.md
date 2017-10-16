# Utils.Regex

Utility Regex functions.

- [simpleReplacer](#simplereplacer)
- [parametricReplacer](#parametricreplacer)
- [replace](#replace)
- [replaceAll](#replaceall)
- [replaceFirst](#replacefirst)
- [replaceSimple](#replacesimple)

### **simpleReplacer**
```elm
simpleReplacer : String -> Regex.Match -> String
```

Simple replacer for Regex.

```elm
Regex.replace All "\\d" "*" "x9y8z7" simpleReplacer == "x*y*z*"
```

---

### **parametricReplacer**
```elm
parametricReplacer : String -> Regex.Match -> String
```

Parametric replacer for Regex that supports $1, $2, ... $9 Parametric Replacements
N.B. $$ is an escape for $, e.g. $$1 will be $1 in the output
N.B. any $n that isn't specified in the regular expression is untouched in the output

```elm
Regex.replace All (regex "(\\d)([a-z])") (parametricReplacer "-$1$2$$2$3") "6a7b8c" == "-6a$2$3-7b$2$3-8c$2$3"
Regex.replace (AtMost 2) (regex "(\\d)([a-z])") (parametricReplacer "-$1$2$$2$3") "6a7b8c" == "-6a$2$3-7b$2$38c"
```

---

### **replace**
```elm
replace : Regex.HowMany -> String -> (Regex.Match -> String) -> String -> String
```

General replace.

```elm
replace All "\\d" (simpleReplacer "_") "a1b2c3" == "a_b_c_"
replace All "(\\d)([a-z])" (parametricReplacer "-$1$2$$2$3") "6a7b8c" == "-6a$2$3-7b$2$3-8c$2$3"
```

---

### **replaceAll**
```elm
replaceAll : String -> String -> String -> String
```

Simple replacement of ALL occurrences.

```elm
replaceAll "\\d" "_" "a1b2c3" == "a_b_c_"
```

---

### **replaceFirst**
```elm
replaceFirst : String -> String -> String -> String
```

Simple replacement of FIRST occurrence.

```elm
replaceFirst "\\d" "_" "a1b2c3" == "a_b2c3"
```

---

### **replaceSimple**
```elm
replaceSimple : Regex.HowMany -> String -> String -> String -> String
```

General simplified replace of specified number of occurrences.

```elm
replaceSimple All "\\d" "_" "a1b2c3" == "a_b_c_"
```

