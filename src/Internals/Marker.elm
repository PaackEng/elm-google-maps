module Internals.Marker exposing
    ( Animation(..)
    , Marker
    , init
    , onClick
    , toHtml
    , withAnimation
    , withDraggableMode
    , withIcon
    , withInfoWindow
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
    , latitude : Float
    , longitude : Float
    , icon : Maybe String
    , isDraggable : Bool
    , title : Maybe String
    , animation : Maybe Animation
    , infoWindow : List (Html msg)
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
        , animation = Nothing
        , infoWindow = []
        }


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
                |> maybeAdd (\icon -> [ attribute "icon" icon ]) options.icon
                |> maybeAdd (\title -> [ attribute "title" title ]) options.title
                |> maybeAdd
                    (\msg ->
                        [ on "google-map-marker-click" (Decode.succeed msg)
                        , attribute "click-events" "true"
                        ]
                    )
                    options.onClick
    in
    node "google-map-marker" attrs options.infoWindow
