# Utils.Error

Error Types and Encoding/Decoding

- [ErrorType](#errortype)
- [errorTypeEncoder](#errortypeencoder)
- [errorTypeDecoder](#errortypedecoder)

### **type ErrorType**
```elm
type ErrorType   
    = FatalError   
    | NonFatalError   
    | RetryableError 
```

Error Types

---

### **errorTypeEncoder**
```elm
errorTypeEncoder : Utils.Error.ErrorType -> Json.Encode.Value
```

ErrorType encoder

---

### **errorTypeDecoder**
```elm
errorTypeDecoder : Json.Decode.Decoder Utils.Error.ErrorType
```

ErrorType decoder

