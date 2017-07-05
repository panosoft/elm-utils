module Utils.Error
    exposing
        ( ErrorType(..)
        , errorTypeEncoder
        , errorTypeDecoder
        )

{-|
    Error Types.

@docs ErrorType, errorTypeEncoder, errorTypeDecoder
-}

import Json.Decode as JD exposing (field)
import Json.Encode as JE


{-|
    Error Types.
-}
type ErrorType
    = FatalError
    | NonFatalError
    | RetryableError


{-| ErrorType encoder
-}
errorTypeEncoder : ErrorType -> JE.Value
errorTypeEncoder errorType =
    JE.string <| toString errorType


{-| ErrorType decoder
-}
errorTypeDecoder : JD.Decoder ErrorType
errorTypeDecoder =
    JD.string
        |> JD.andThen
            (\errorTypeStr ->
                JD.succeed <|
                    case errorTypeStr of
                        "FatalError" ->
                            FatalError

                        "NonFatalError" ->
                            NonFatalError

                        "RetryableError" ->
                            RetryableError

                        _ ->
                            Debug.crash ("Unknown ErrorType: " ++ errorTypeStr)
            )
