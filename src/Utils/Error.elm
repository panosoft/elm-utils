module Utils.Error exposing (..)

{-|
    Error Types.

@docs ErrorType
-}


{-|
    Error Types.
-}
type ErrorType
    = FatalError
    | NonFatalError
    | RetryableError
