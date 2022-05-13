module GoogleMaps.Marker exposing
    ( Marker, Latitude, Longitude, init, Animation
    , withCursor, withIcon, withDraggableMode, withTitle, withAnimation, withInfoWindow
    , bounce, drop
    , onClick, withInfoWindowOnMouseOver
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

@docs Marker, Latitude, Longitude, init, Animation


# Modifiers

@docs withCursor, withIcon, withDraggableMode, withTitle, withAnimation, withInfoWindow


# Animations

@docs bounce, drop


# Events

@docs onClick, withInfoWindowOnMouseOver

-}

import Html exposing (Html)
import Internals.Marker as IMarker


{-| This type is latitude in float format as expected by Google Maps.
-}
type alias Latitude =
    Float


{-| This type is longitude in float format as expected by Google Maps.
-}
type alias Longitude =
    Float


{-| This type wraps the available animations for markers in Google Maps, "DROP" or "BOUNCE" or nothing.

  - See <https://developers.google.com/maps/documentation/javascript/examples/marker-animations>.

-}
type Animation
    = Animation IMarker.Animation


{-| Opaque type that upholds the marker description.
-}
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


{-| Sets cursor to the marker
-}
withCursor : String -> Marker msg -> Marker msg
withCursor cursor marker =
    IMarker.withCursor cursor marker


{-| Sets a custom image to the marker
-}
withIcon : String -> Marker msg -> Marker msg
withIcon icon marker =
    IMarker.withIcon icon marker


{-| Sets an on hover title for the marker
-}
withTitle : String -> Marker msg -> Marker msg
withTitle title marker =
    IMarker.withTitle title marker


{-| Makes the marker draggable
-}
withDraggableMode : Marker msg -> Marker msg
withDraggableMode marker =
    IMarker.withDraggableMode marker


{-| Sets the animation for the marker.
-}
withAnimation : Animation -> Marker msg -> Marker msg
withAnimation (Animation animation) marker =
    IMarker.withAnimation animation marker


{-| Sets the content of the Info Window.

When empty, disables the info window.

-}
withInfoWindow : List (Html msg) -> Marker msg -> Marker msg
withInfoWindow infoWindow marker =
    IMarker.withInfoWindow infoWindow marker


{-| Allows to enter/leave a Info Window specified in [`withInfoWindow`](#withInfoWindow)
-}
withInfoWindowOnMouseOver : Marker msg -> Marker msg
withInfoWindowOnMouseOver marker =
    IMarker.withInfoWindowOnMouseOver True marker


{-| Get Bounce animation
-}
bounce : Animation
bounce =
    Animation IMarker.Bounce


{-| Get Drop animation
-}
drop : Animation
drop =
    Animation IMarker.Drop
