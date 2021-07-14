module GoogleMaps.Map exposing
    ( Map, MapType, ApiKey, Latitude, Longitude
    , init, toHtml
    , withDefaultUIControls, withMapTypeControls, withStreetViewControls, withZoomActions
    , withMapType, hybrid, roadmap, satellite, terrain
    , JourneySharing, LocationProvider
    , withJourneySharing, journeySharing, locationProvider
    , withCenter, withCustomStyle, withFitToMarkers, withMarkers, withMaxZoom, withMinZoom, withPolygons, withZoom
    , onMapClick, onMapReady
    , withDrawingTool
    )

{-| This module allows you to create maps using Google maps webcomponent behind the scene

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


# Journey Sharing

@docs JourneySharing, LocationProvider
@docs withJourneySharing, journeySharing, locationProvider


# Other Modifiers

@docs withCenter, withCustomStyle, withFitToMarkers, withMarkers, withMaxZoom, withMinZoom, withPolygons, withZoom


# Events

@docs onMapClick, onMapReady


# Plugins

@docs withDrawingTool

-}

import GoogleMaps.Marker exposing (Marker)
import GoogleMaps.Plugins.DrawingTool as DrawingTool
import GoogleMaps.Polygon exposing (Polygon)
import Html exposing (Html)
import Internals.Map as IMap


{-| Upholds the possible types of surface for viewing the map.
-}
type MapType
    = MapType IMap.MapType


{-| Handles the fleet-engine's location provider.
-}
type LocationProvider
    = LocationProvider IMap.LocationProvider


{-| Handles the fleet-engine's journey-sharing feature.
-}
type JourneySharing
    = JourneySharing IMap.JourneySharing


{-| API key provided by Google for accessing their maps' services.
-}
type alias ApiKey =
    String


{-| This type is latitude in float format as expected by Google Maps.
-}
type alias Latitude =
    Float


{-| This type is longitude in float format as expected by Google Maps.
-}
type alias Longitude =
    Float


{-| Opaque type that upholds the map description.
-}
type Map msg
    = Map (IMap.Map msg)


{-| It requires the api key whose type is String
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

The default type is roadmap.

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


{-| Map with actual photos of the terrain surface.
-}
satellite : MapType
satellite =
    MapType IMap.Satellite


{-| Map focusing on a presentation of the available driveable paths.
-}
roadmap : MapType
roadmap =
    MapType IMap.Roadmap


{-| Map with the actual photos of the terrain surface like [satellite](#satellite).
While including the roads, and names from [roadmap](#roadmap)
-}
hybrid : MapType
hybrid =
    MapType IMap.Hybrid


{-| Map with terrain specifications, mountains, rivers, and other geospatial information.
-}
terrain : MapType
terrain =
    MapType IMap.Terrain


{-| Sets the journey-sharing feature.
-}
withJourneySharing : JourneySharing -> Map msg -> Map msg
withJourneySharing (JourneySharing value) (Map map) =
    Map (IMap.withJourneySharing value map)


{-| Specifies the journey-sharing feature.
-}
journeySharing : String -> LocationProvider -> JourneySharing
journeySharing accessToken (LocationProvider provider) =
    JourneySharing (IMap.JourneySharing accessToken provider)


{-| Specifies a location provider for the fleet-engine.
-}
locationProvider : String -> String -> LocationProvider
locationProvider projectId deliveryVehicleId =
    LocationProvider { projectId = projectId, deliveryVehicleId = deliveryVehicleId }


{-| The idea is make it typed, but right know you should pass the JSON as string

Reference: <https://developers.google.com/maps/documentation/javascript/styling>

-}
withCustomStyle : String -> Map msg -> Map msg
withCustomStyle mapStyle (Map map) =
    Map (IMap.withCustomStyle mapStyle map)


{-| This option is diesabled by default. If the option is enabled the map bounds change in order to fit all the markers. If there is 1 marker only then the map will be centered to the marker position.
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


{-| Triggers once the map is loaded.
-}
onMapReady : msg -> Map msg -> Map msg
onMapReady evt (Map map) =
    Map (IMap.onMapReady evt map)


{-| Triggers with every click on the map.
-}
onMapClick : msg -> Map msg -> Map msg
onMapClick evt (Map map) =
    Map (IMap.onMapClick evt map)



-- Plugins


{-| Provides a controllable feature of allowing the user to draw polygons on the map.
-}
withDrawingTool : DrawingTool.State -> DrawingTool.Events msg -> Map msg -> Map msg
withDrawingTool state config (Map map) =
    Map (IMap.withDrawingTool state config map)



-- Controls


{-| Embeds buttons for controlling the map viewing.
-}
withDefaultUIControls : Bool -> Map msg -> Map msg
withDefaultUIControls isEnabled (Map map) =
    Map (IMap.withDefaultUIControls isEnabled map)


{-| Provides a scrolling bar for controlling the current zooming in the map.
-}
withZoomActions : Bool -> Map msg -> Map msg
withZoomActions isEnabled (Map map) =
    Map (IMap.withZoomActions isEnabled map)


{-| Embeds buttons for the user to change the map type in runtime.
-}
withMapTypeControls : Bool -> Map msg -> Map msg
withMapTypeControls isEnabled (Map map) =
    Map (IMap.withMapTypeControls isEnabled map)


{-| Provides a button for entering the Street View mode.
-}
withStreetViewControls : Bool -> Map msg -> Map msg
withStreetViewControls isEnabled (Map map) =
    Map (IMap.withStreetViewControls isEnabled map)


{-| The final function to generate the final html
-}
toHtml : Map msg -> Html msg
toHtml (Map map) =
    IMap.toHtml map
