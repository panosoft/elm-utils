module Utils.Log exposing (..)

{-| Log Types.

@docs LogLevel

-}


{-| Logging Level
-}
type LogLevel
    = LogLevelFatal
    | LogLevelError
    | LogLevelWarn
    | LogLevelInfo
    | LogLevelDebug
    | LogLevelTrace
