module GoogleMaps.Marker exposing
    ( Marker, Latitude, Longitude, init
    , withIcon, withDraggableMode
    , onClick
    )

{-| This module allows you to create markers to be used along with GoogleMaps.Map

    import GoogleMaps.Map as Map
    import GoogleMaps.Marker as Marker

    myMarker : Marker Msg
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

-}

import Internals.Marker as IMarker


{-| -}
type alias Latitude =
    Float


{-| -}
type alias Longitude =
    Float


{-| -}
type alias Marker msg =
    IMarker.Marker msg


{-| It requires the latitude and longitude (both are floats)
-}
init : Latitude -> Longitude -> Marker msg
init latitude longitude =
    IMarker.init latitude longitude


{-| Sets a click event handler
-}
onClick : msg -> Marker msg -> Marker msg
onClick msg marker =
    IMarker.onClick msg marker


{-| Sets a custom image to the marker
-}
withIcon : String -> Marker msg -> Marker msg
withIcon icon marker =
    IMarker.withIcon icon marker


{-| Makes the marker draggable
-}
withDraggableMode : Marker msg -> Marker msg
withDraggableMode marker =
    IMarker.withDraggableMode marker
