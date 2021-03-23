module Internals.Plugins.DrawingTool exposing
    ( Config
    , State
    , init
    , isDrawingEnabled
    , startDrawing
    , stopDrawing
    , toHtml
    )

import Html exposing (Html)
import Html.Attributes exposing (attribute)
import Html.Events exposing (on)
import Internals.Helpers exposing (addIf)
import Json.Decode as Decode


type State
    = State StateData


type alias StateData =
    { isEnabled : Bool }


type alias Config msg =
    { onPolygonCompleted : List ( Float, Float ) -> msg
    }


init : State
init =
    State { isEnabled = False }


isDrawingEnabled : State -> Bool
isDrawingEnabled (State { isEnabled }) =
    isEnabled


startDrawing : State -> State
startDrawing (State state) =
    State { state | isEnabled = True }


stopDrawing : State -> State
stopDrawing (State state) =
    State { state | isEnabled = False }


toHtml : State -> Config msg -> Html msg
toHtml (State { isEnabled }) { onPolygonCompleted } =
    let
        attrs =
            [ on "on-polygon-completed"
                (Decode.map onPolygonCompleted coordinatesDecoder)
            ]
                |> addIf (not isEnabled) (attribute "disabled" "true")
    in
    Html.node "google-map-drawing-tool" attrs []



-- Internals


coordinatesDecoder : Decode.Decoder (List ( Float, Float ))
coordinatesDecoder =
    Decode.at [ "detail" ]
        (Decode.list
            (Decode.map2
                Tuple.pair
                (Decode.field "lat" Decode.float)
                (Decode.field "lng" Decode.float)
            )
        )
