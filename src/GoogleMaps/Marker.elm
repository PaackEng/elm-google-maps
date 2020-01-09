module GoogleMaps.Marker exposing
    ( Marker, Latitude, Longitude, init
    , withIcon, withDraggableMode
    , onClick
    , toHtml
    )

{-| This module allows you to create markers to be used along with GoogleMaps.Map

    import GoogleMaps.Map as Map
    import GoogleMaps.Marker as Marker

    myMarker : Html Msg
    myMarker =
        Marker.init -3.7344654 -38.5057405
            |> Marker.onClick MyClickMsg

    mapView : String -> Html Msg
    mapView apiKey =
        Map.init apiKey
            |> Map.withMarkers [ myMarker ]
            |> Map.toHtml

@docs Marker, Latitude, Longitude, init


# Modifiers

@docs withIcon, withDraggableMode


# Events

@docs onClick


# Don't touch this :o

@docs toHtml

-}

import Html exposing (Html)
import Internals.Marker as IMarker


{-| -}
type alias Latitude =
    Float


{-| -}
type alias Longitude =
    Float


{-| -}
type Marker msg
    = Marker (IMarker.Marker msg)


{-| It requires the latitude and longitude(both are floats)
-}
init : Latitude -> Longitude -> Marker msg
init latitude longitude =
    Marker <| IMarker.init latitude longitude


{-| Sets a custom image to the marker
-}
onClick : msg -> Marker msg -> Marker msg
onClick msg (Marker marker) =
    Marker <| IMarker.onClick msg marker


{-| Sets a custom image to the marker
-}
withIcon : String -> Marker msg -> Marker msg
withIcon icon (Marker marker) =
    Marker <| IMarker.withIcon icon marker


{-| make the marker draggable
-}
withDraggableMode : Marker msg -> Marker msg
withDraggableMode (Marker marker) =
    Marker <| IMarker.withDraggableMode marker


{-| You should not use this function, GoogleMaps.Map uses it in order to render the marker.
-}
toHtml : Marker msg -> Html msg
toHtml (Marker marker) =
    IMarker.toHtml marker
