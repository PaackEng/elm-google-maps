module Internals.Marker exposing
    ( Animation(..)
    , Marker
    , init
    , onClick
    , toHtml
    , withAnimation
    , withCursor
    , withDraggableMode
    , withIcon
    , withInfoWindow
    , withInfoWindowOnMouseOver
    , withTitle
    )

import Html exposing (Html, node)
import Html.Attributes exposing (attribute)
import Html.Events exposing (on)
import Internals.Helpers exposing (addIf, maybeAdd)
import Json.Decode as Decode


type Marker msg
    = Marker (Options msg)


type Animation
    = Drop
    | Bounce


type alias Options msg =
    { onClick : Maybe msg
    , cursor : Maybe String
    , latitude : Float
    , longitude : Float
    , icon : Maybe String
    , isDraggable : Bool
    , title : Maybe String
    , animation : Maybe Animation
    , infoWindow : List (Html msg)
    , infoOnMouse : Maybe String
    }


init : Float -> Float -> Marker msg
init latitude longitude =
    Marker
        { onClick = Nothing
        , latitude = latitude
        , cursor = Nothing
        , longitude = longitude
        , icon = Nothing
        , isDraggable = False
        , title = Nothing
        , animation = Nothing
        , infoWindow = []
        , infoOnMouse = Nothing
        }

withCursor : String -> Marker msg -> Marker msg
withCursor cursor (Marker options) =
    Marker { options | cursor = Just cursor }

withIcon : String -> Marker msg -> Marker msg
withIcon icon (Marker options) =
    Marker { options | icon = Just icon }


withDraggableMode : Marker msg -> Marker msg
withDraggableMode (Marker options) =
    Marker { options | isDraggable = True }


onClick : msg -> Marker msg -> Marker msg
onClick msg (Marker options) =
    Marker { options | onClick = Just msg }


withTitle : String -> Marker msg -> Marker msg
withTitle title (Marker options) =
    Marker { options | title = Just title }


withAnimation : Animation -> Marker msg -> Marker msg
withAnimation animation (Marker options) =
    Marker { options | animation = Just animation }


withInfoWindow : List (Html msg) -> Marker msg -> Marker msg
withInfoWindow infoWindow (Marker options) =
    Marker { options | infoWindow = infoWindow }


withInfoWindowOnMouseOver : Bool -> Marker msg -> Marker msg
withInfoWindowOnMouseOver value (Marker options) =
    let
        valueStr =
            if value then
                "true"

            else
                "false"
    in
    Marker { options | infoOnMouse = Just valueStr }


animationToAttribute : Animation -> String
animationToAttribute a =
    case a of
        Drop ->
            "DROP"

        Bounce ->
            "BOUNCE"


toHtml : Marker msg -> Html msg
toHtml (Marker options) =
    let
        animation : String
        animation =
            options.animation
                |> Maybe.map animationToAttribute
                |> Maybe.withDefault ""

        attrs =
            [ attribute "latitude" (String.fromFloat options.latitude)
            , attribute "longitude" (String.fromFloat options.longitude)
            , attribute "slot" "markers"
            , attribute "animation" animation
            ]
                |> addIf options.isDraggable (attribute "draggable" "true")
                |> maybeAdd (\cursor -> [ attribute "cursor" cursor ]) options.cursor
                |> maybeAdd (\icon -> [ attribute "icon" icon ]) options.icon
                |> maybeAdd (\title -> [ attribute "title" title ]) options.title
                |> maybeAdd (\infoOnMouse -> [ attribute "info-on-mouse" infoOnMouse ]) options.infoOnMouse
                |> maybeAdd
                    (\msg ->
                        [ on "google-map-marker-click" (Decode.succeed msg)
                        , attribute "click-events" "true"
                        ]
                    )
                    options.onClick
    in
    node "google-map-marker" attrs options.infoWindow
