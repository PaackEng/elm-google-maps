module Map exposing
    ( Map
    , MapType
    , hybrid
    , init
    , onMapClick
    , onMapReady
    , roadmap
    , satellite
    , terrain
    , toHtml
    , withCenter
    , withCustomStyle
    , withDefaultUIControls
    , withFitToMarkers
    , withMapType
    , withMapTypeControls
    , withMarkers
    , withMaxZoom
    , withMinZoom
    , withPolygons
    , withStreetViewControls
    , withZoom
    , withZoomActions
    )

import Html exposing (Html)
import Internals.Map as IMap
import Marker exposing (Marker)
import Polygon exposing (Polygon)


type MapType
    = MapType IMap.MapType


type alias ApiKey =
    String


type alias Latitude =
    Float


type alias Longitude =
    Float


type Map msg
    = Map (IMap.Map msg)


init : ApiKey -> Map msg
init apiKey =
    Map (IMap.init apiKey)


withCenter : Latitude -> Longitude -> Map msg -> Map msg
withCenter latitude longitude (Map map) =
    Map (IMap.withCenter latitude longitude map)


withZoom : Int -> Map msg -> Map msg
withZoom zoom (Map map) =
    Map (IMap.withZoom zoom map)


withMinZoom : Int -> Map msg -> Map msg
withMinZoom zoom (Map map) =
    Map (IMap.withMinZoom zoom map)


withMaxZoom : Int -> Map msg -> Map msg
withMaxZoom zoom (Map map) =
    Map (IMap.withMaxZoom zoom map)


withMapType : MapType -> Map msg -> Map msg
withMapType (MapType mapType) (Map map) =
    Map (IMap.withMapType mapType map)


withCustomStyle : String -> Map msg -> Map msg
withCustomStyle mapStyle (Map map) =
    Map (IMap.withCustomStyle mapStyle map)


withFitToMarkers : Bool -> Map msg -> Map msg
withFitToMarkers shouldFit (Map map) =
    Map (IMap.withFitToMarkers shouldFit map)


satellite : MapType
satellite =
    MapType IMap.Satellite


roadmap : MapType
roadmap =
    MapType IMap.Roadmap


hybrid : MapType
hybrid =
    MapType IMap.Hybrid


terrain : MapType
terrain =
    MapType IMap.Terrain


withMarkers : List (Marker msg) -> Map msg -> Map msg
withMarkers markers (Map map) =
    Map (IMap.withMarkers markers map)


withPolygons : List (Polygon msg) -> Map msg -> Map msg
withPolygons polygons (Map map) =
    Map (IMap.withPolygons polygons map)



-- Events


onMapReady : msg -> Map msg -> Map msg
onMapReady evt (Map map) =
    Map (IMap.onMapReady evt map)


onMapClick : msg -> Map msg -> Map msg
onMapClick evt (Map map) =
    Map (IMap.onMapClick evt map)



-- Controls


withDefaultUIControls : Bool -> Map msg -> Map msg
withDefaultUIControls isEnabled (Map map) =
    Map (IMap.withDefaultUIControls isEnabled map)


withZoomActions : Bool -> Map msg -> Map msg
withZoomActions isEnabled (Map map) =
    Map (IMap.withZoomActions isEnabled map)


withMapTypeControls : Bool -> Map msg -> Map msg
withMapTypeControls isEnabled (Map map) =
    Map (IMap.withMapTypeControls isEnabled map)


withStreetViewControls : Bool -> Map msg -> Map msg
withStreetViewControls isEnabled (Map map) =
    Map (IMap.withStreetViewControls isEnabled map)


toHtml : Map msg -> Html msg
toHtml (Map map) =
    IMap.toHtml map
