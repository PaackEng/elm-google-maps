module Internals.Map.Events exposing
    ( Events
    , init
    , toHtmlAttributes
    )

import Html exposing (Attribute)
import Html.Events exposing (on)
import Internals.Helpers exposing (maybeAdd)
import Json.Decode as Decode


type alias Events msg =
    { onMapReady : Maybe msg
    , onMapClick : Maybe msg
    }


init : Events msg
init =
    { onMapReady = Nothing
    , onMapClick = Nothing
    }


toHtmlAttributes : Events msg -> List (Attribute msg)
toHtmlAttributes events =
    maybeAdd (\msg -> [ on "google-map-ready" (Decode.succeed msg) ]) events.onMapReady []
        |> maybeAdd (\msg -> [ on "google-map-click" (Decode.succeed msg) ]) events.onMapClick
