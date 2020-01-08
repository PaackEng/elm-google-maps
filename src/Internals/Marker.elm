module Internals.Marker exposing
    ( Marker
    , init
    , onClick
    , toHtml
    , withDraggableMode
    , withIcon
    )

import Html exposing (Html, node)
import Html.Attributes exposing (attribute)
import Html.Events exposing (on)
import Internals.Helpers exposing (addIf, maybeAdd)
import Json.Decode as Decode


type alias Marker msg =
    { onClick : Maybe msg
    , latitude : Float
    , longitude : Float
    , icon : Maybe String
    , isDraggable : Bool
    }


init : Float -> Float -> Marker msg
init latitude longitude =
    { onClick = Nothing
    , latitude = latitude
    , longitude = longitude
    , icon = Nothing
    , isDraggable = False
    }


withIcon : String -> Marker msg -> Marker msg
withIcon icon marker =
    { marker | icon = Just icon }


withDraggableMode : Marker msg -> Marker msg
withDraggableMode marker =
    { marker | isDraggable = True }


onClick : msg -> Marker msg -> Marker msg
onClick msg marker =
    { marker | onClick = Just msg }


toHtml : Marker msg -> Html msg
toHtml marker =
    let
        attrs =
            [ attribute "latitude" (String.fromFloat marker.latitude)
            , attribute "longitude" (String.fromFloat marker.longitude)
            , attribute "slot" "markers"
            ]
                |> addIf marker.isDraggable (attribute "draggable" "true")
                |> maybeAdd (\icon -> [ attribute "icon" icon ]) marker.icon
                |> maybeAdd
                    (\msg ->
                        [ on "google-map-marker-click" (Decode.succeed msg)
                        , attribute "click-events" "true"
                        ]
                    )
                    marker.onClick
    in
    node "google-map-marker" attrs []
