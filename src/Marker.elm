module Marker exposing
    ( Marker
    , init
    , onClick
    , toHtml
    , withDraggableMode
    , withIcon
    )

import Html exposing (Html)
import Internals.Marker as IMarker


type Marker msg
    = Marker (IMarker.Marker msg)


init : Float -> Float -> Marker msg
init latitude longitude =
    Marker <| IMarker.init latitude longitude


onClick : msg -> Marker msg -> Marker msg
onClick msg (Marker marker) =
    Marker <| IMarker.onClick msg marker


withIcon : String -> Marker msg -> Marker msg
withIcon icon (Marker marker) =
    Marker <| IMarker.withIcon icon marker


withDraggableMode : Marker msg -> Marker msg
withDraggableMode (Marker marker) =
    Marker <| IMarker.withDraggableMode marker


toHtml : Marker msg -> Html msg
toHtml (Marker marker) =
    IMarker.toHtml marker
