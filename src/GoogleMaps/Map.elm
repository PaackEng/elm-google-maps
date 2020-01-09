module GoogleMaps.Map exposing
    ( Map, MapType, ApiKey, Latitude, Longitude
    , init, toHtml
    , withDefaultUIControls, withMapTypeControls, withStreetViewControls, withZoomActions
    , withMapType, hybrid, roadmap, satellite, terrain
    , withCenter, withCustomStyle, withFitToMarkers, withMarkers, withMaxZoom, withMinZoom, withPolygons, withZoom
    , onMapClick, onMapReady
    )

{-| This module allows you to create markers to be used along with GoogleMaps.Map

> Note that the map has 100% height, so you would resize the map based on the parent view


# Simple Example

    import GoogleMaps.Map as Map

    mapView : String -> Html Msg
    mapView apiKey =
        Map.init apiKey
            |> Map.toHtml


# Complex Example

    import GoogleMaps.Map as Map

    mapView : String -> Html Msg
    mapView apiKey =
        Map.init apiKey
            |> Map.withZoom 12
            |> Map.withMapType Map.satellite
            |> Map.onMapReady MyMsg
            |> Map.withCenter -3.7715105 -38.5724269
            |> Map.withDefaultUIControls False
            |> Map.toHtml


# Types

@docs Map, MapType, ApiKey, Latitude, Longitude


# Basics

@docs init, toHtml


# UI Controls

You can use those functions in order to enable/disable UI controls such as StreetView button, zoom and etc

By default all the controls are enabled

@docs withDefaultUIControls, withMapTypeControls, withStreetViewControls, withZoomActions


# MapType

@docs withMapType, hybrid, roadmap, satellite, terrain


# Other Modifiers

@docs withCenter, withCustomStyle, withFitToMarkers, withMarkers, withMaxZoom, withMinZoom, withPolygons, withZoom


# Events

@docs onMapClick, onMapReady

-}

import GoogleMaps.Marker exposing (Marker)
import GoogleMaps.Polygon exposing (Polygon)
import Html exposing (Html)
import Internals.Map as IMap


{-| -}
type MapType
    = MapType IMap.MapType


{-| -}
type alias ApiKey =
    String


{-| -}
type alias Latitude =
    Float


{-| -}
type alias Longitude =
    Float


{-| -}
type Map msg
    = Map (IMap.Map msg)


{-| It requires the api key that is a String
-}
init : ApiKey -> Map msg
init apiKey =
    Map (IMap.init apiKey)


{-| Sets the center of the map
-}
withCenter : Latitude -> Longitude -> Map msg -> Map msg
withCenter latitude longitude (Map map) =
    Map (IMap.withCenter latitude longitude map)


{-| Default zoom is 14
-}
withZoom : Int -> Map msg -> Map msg
withZoom zoom (Map map) =
    Map (IMap.withZoom zoom map)


{-| Default value is 0
-}
withMinZoom : Int -> Map msg -> Map msg
withMinZoom zoom (Map map) =
    Map (IMap.withMinZoom zoom map)


{-| Default value is 20
-}
withMaxZoom : Int -> Map msg -> Map msg
withMaxZoom zoom (Map map) =
    Map (IMap.withMaxZoom zoom map)


{-| Sets the mapType.
Possible options:

satellite, roadmap, hybrid, terrain

Example:

    import GoogleMaps.Map as Map

    mapView : String -> Html Msg
    mapView apiKey =
        Map.init apiKey
            |> Map.withMapType Map.satellite
            |> Map.toHtml

-}
withMapType : MapType -> Map msg -> Map msg
withMapType (MapType mapType) (Map map) =
    Map (IMap.withMapType mapType map)


{-| -}
satellite : MapType
satellite =
    MapType IMap.Satellite


{-| -}
roadmap : MapType
roadmap =
    MapType IMap.Roadmap


{-| -}
hybrid : MapType
hybrid =
    MapType IMap.Hybrid


{-| -}
terrain : MapType
terrain =
    MapType IMap.Terrain


{-| The idea is make it typed, but right know you should pass the JSON as string

Reference: <https://developers.google.com/maps/documentation/javascript/styling>

-}
withCustomStyle : String -> Map msg -> Map msg
withCustomStyle mapStyle (Map map) =
    Map (IMap.withCustomStyle mapStyle map)


{-| If contains 1 marker, it sets the map center to the marker location, otherwise it changes the bounds in order to fit all the markers in the screen
-}
withFitToMarkers : Bool -> Map msg -> Map msg
withFitToMarkers shouldFit (Map map) =
    Map (IMap.withFitToMarkers shouldFit map)


{-|

    import GoogleMaps.Map as Map
    import GoogleMaps.Marker as Marker

    myMarker : Marker.Marker Msg
    myMarker =
        Marker.init -3.7344654 -38.5057405
            |> Marker.onClick MyClickMsg

    mapView : String -> Html Msg
    mapView apiKey =
        Map.init apiKey
            |> Map.withMarkers [ myMarker ]
            |> Map.toHtml

-}
withMarkers : List (Marker msg) -> Map msg -> Map msg
withMarkers markers (Map map) =
    Map (IMap.withMarkers markers map)


{-|

    import GoogleMaps.Map as Map
    import GoogleMaps.Polygon as Polygon

    myPolygon : Polygon.Polygon Msg
    myPolygon =
        Polygon.init
            [ ( -3.7344654, -38.5057405 )
            , ( -3.7366108, -38.5188557 )
            , ( -3.7374002, -38.5195225 )
            , ( -3.7474947, -38.5153675 )
            ]
            |> Polygon.withStrokeColor "red"
            |> Polygon.withFillColor "orange"
            |> Polygon.withFillOpacity 0.25
            |> Polygon.withClosedMode

    mapView : String -> Html Msg
    mapView apiKey =
        Map.init apiKey
            |> Map.withPolygons [ myPolygon ]
            |> Map.toHtml

-}
withPolygons : List (Polygon msg) -> Map msg -> Map msg
withPolygons polygons (Map map) =
    Map (IMap.withPolygons polygons map)



-- Events


{-| -}
onMapReady : msg -> Map msg -> Map msg
onMapReady evt (Map map) =
    Map (IMap.onMapReady evt map)


{-| -}
onMapClick : msg -> Map msg -> Map msg
onMapClick evt (Map map) =
    Map (IMap.onMapClick evt map)



-- Controls


{-| -}
withDefaultUIControls : Bool -> Map msg -> Map msg
withDefaultUIControls isEnabled (Map map) =
    Map (IMap.withDefaultUIControls isEnabled map)


{-| -}
withZoomActions : Bool -> Map msg -> Map msg
withZoomActions isEnabled (Map map) =
    Map (IMap.withZoomActions isEnabled map)


{-| -}
withMapTypeControls : Bool -> Map msg -> Map msg
withMapTypeControls isEnabled (Map map) =
    Map (IMap.withMapTypeControls isEnabled map)


{-| -}
withStreetViewControls : Bool -> Map msg -> Map msg
withStreetViewControls isEnabled (Map map) =
    Map (IMap.withStreetViewControls isEnabled map)


{-| The final function to generate the final html
-}
toHtml : Map msg -> Html msg
toHtml (Map map) =
    IMap.toHtml map
