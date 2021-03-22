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
    Html.node "google-map-drawing-tool"
        [ attribute "disabled" <| boolToStringLower <| not isEnabled
        , on "on-polygon-completed"
            (Decode.map onPolygonCompleted coordinatesDecoder)
        ]
        []


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


boolToStringLower : Bool -> String
boolToStringLower bool =
    if bool then
        "true"

    else
        "false"
