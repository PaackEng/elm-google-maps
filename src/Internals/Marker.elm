module Internals.Marker exposing
    ( Marker
    , init
    , onClick
    , toHtml
    , withDraggableMode
    , withIcon
    , withTitle
    )

import Html exposing (Html, node)
import Html.Attributes exposing (attribute)
import Html.Events exposing (on)
import Internals.Helpers exposing (addIf, maybeAdd)
import Json.Decode as Decode


type Marker msg
    = Marker (Options msg)


type alias Options msg =
    { onClick : Maybe msg
    , latitude : Float
    , longitude : Float
    , icon : Maybe String
    , isDraggable : Bool
    , title : Maybe String
    }


init : Float -> Float -> Marker msg
init latitude longitude =
    Marker
        { onClick = Nothing
        , latitude = latitude
        , longitude = longitude
        , icon = Nothing
        , isDraggable = False
        , title = Nothing
        }


withIcon : String -> Marker msg -> Marker msg
withIcon icon (Marker marker) =
    Marker { marker | icon = Just icon }


withDraggableMode : Marker msg -> Marker msg
withDraggableMode (Marker marker) =
    Marker { marker | isDraggable = True }


onClick : msg -> Marker msg -> Marker msg
onClick msg (Marker marker) =
    Marker { marker | onClick = Just msg }


withTitle : String -> Marker msg -> Marker msg
withTitle title (Marker marker) =
    Marker { marker | title = Just title }


toHtml : Marker msg -> Html msg
toHtml (Marker marker) =
    let
        attrs =
            [ attribute "latitude" (String.fromFloat marker.latitude)
            , attribute "longitude" (String.fromFloat marker.longitude)
            , attribute "slot" "markers"
            ]
                |> addIf marker.isDraggable (attribute "draggable" "true")
                |> maybeAdd (\icon -> [ attribute "icon" icon ]) marker.icon
                |> maybeAdd (\title -> [ attribute "title" title ]) marker.title
                |> maybeAdd
                    (\msg ->
                        [ on "google-map-marker-click" (Decode.succeed msg)
                        , attribute "click-events" "true"
                        ]
                    )
                    marker.onClick
    in
    node "google-map-marker" attrs []
