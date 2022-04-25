module Internals.Map exposing
    ( JourneySharing
    , LocationProvider
    , Map
    , MapType(..)
    , init
    , onMapClick
    , onMapReady
    , toHtml
    , withCenter
    , withCustomStyle
    , withDefaultUIControls
    , withDrawingTool
    , withFitToMarkers
    , withJourneySharing
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

import Html exposing (Attribute, Html, node)
import Html.Attributes exposing (attribute, style)
import Internals.Helpers exposing (addIf, maybeFold)
import Internals.Map.Events as Events exposing (Events)
import Internals.Marker as Marker exposing (Marker)
import Internals.Plugins.DrawingTool as DrawingTool
import Internals.Polygon as Polygon exposing (Polygon)


type Map msg
    = Map (Options msg)


type alias Options msg =
    { apiKey : ApiKey
    , markers : List (Marker msg)
    , polygons : List (Polygon msg)
    , mapType : MapType
    , journeySharing : Maybe JourneySharing
    , center : Maybe ( Float, Float )
    , minZoom : Int
    , maxZoom : Int
    , zoom : Int
    , mapStyle : Maybe String
    , shouldFitToMarkers : Bool
    , controls : Controls
    , events : Events msg
    , plugins : Plugins msg
    }


type alias Controls =
    { defaultUI : Bool
    , zoom : Bool
    , mapType : Bool
    , streetView : Bool
    }


type alias Plugins msg =
    { drawingTool : Maybe ( DrawingTool.State, DrawingTool.Events msg )
    }


type MapType
    = Roadmap
    | Satellite
    | Hybrid
    | Terrain


type alias JourneySharing =
    { token : String
    , locationProvider : LocationProvider
    }


type alias LocationProvider =
    { projectId : String
    , deliveryVehicleId : String
    }


type alias ApiKey =
    String


init : ApiKey -> Map msg
init apiKey =
    Map
        { apiKey = apiKey
        , markers = []
        , polygons = []
        , mapType = Roadmap
        , journeySharing = Nothing
        , center = Nothing
        , minZoom = 0
        , maxZoom = 20
        , zoom = 14
        , mapStyle = Nothing
        , shouldFitToMarkers = False
        , controls = initControls
        , plugins = initPlugins
        , events = Events.init
        }


initControls : Controls
initControls =
    { defaultUI = True
    , zoom = True
    , mapType = True
    , streetView = True
    }


initPlugins : Plugins msg
initPlugins =
    { drawingTool = Nothing
    }


withCenter : Float -> Float -> Map msg -> Map msg
withCenter latitude longitude (Map map) =
    Map { map | center = Just ( latitude, longitude ) }



-- TODO: Type all the styles!


withCustomStyle : String -> Map msg -> Map msg
withCustomStyle mapStyle (Map map) =
    Map { map | mapStyle = Just mapStyle }


withMapType : MapType -> Map msg -> Map msg
withMapType mapType (Map map) =
    Map { map | mapType = mapType }


withJourneySharing : JourneySharing -> Map msg -> Map msg
withJourneySharing journeySharing (Map map) =
    Map { map | journeySharing = Just journeySharing }


withZoom : Int -> Map msg -> Map msg
withZoom zoom (Map map) =
    Map { map | zoom = zoom }


withMinZoom : Int -> Map msg -> Map msg
withMinZoom minZoom (Map map) =
    Map { map | minZoom = minZoom }


withMaxZoom : Int -> Map msg -> Map msg
withMaxZoom maxZoom (Map map) =
    Map { map | maxZoom = maxZoom }


withFitToMarkers : Bool -> Map msg -> Map msg
withFitToMarkers shouldFitToMarkers (Map map) =
    Map { map | shouldFitToMarkers = shouldFitToMarkers }


withMarkers : List (Marker msg) -> Map msg -> Map msg
withMarkers markers (Map map) =
    Map { map | markers = markers }


withPolygons : List (Polygon msg) -> Map msg -> Map msg
withPolygons polygons (Map map) =
    Map { map | polygons = polygons }



-- Plugins


withDrawingTool : DrawingTool.State -> DrawingTool.Events msg -> Map msg -> Map msg
withDrawingTool state config (Map ({ plugins } as map)) =
    Map { map | plugins = { plugins | drawingTool = Just ( state, config ) } }



-- Events


onMapReady : msg -> Map msg -> Map msg
onMapReady evt (Map ({ events } as map)) =
    Map { map | events = { events | onMapReady = Just evt } }



-- TODO: find a way to get the latitude and longitude, otherwise is an useless event


onMapClick : msg -> Map msg -> Map msg
onMapClick evt (Map ({ events } as map)) =
    Map { map | events = { events | onMapClick = Just evt } }



-- Controls


withDefaultUIControls : Bool -> Map msg -> Map msg
withDefaultUIControls isEnabled (Map ({ controls } as map)) =
    Map { map | controls = { controls | defaultUI = isEnabled } }


withZoomActions : Bool -> Map msg -> Map msg
withZoomActions isEnabled (Map ({ controls } as map)) =
    Map { map | controls = { controls | zoom = isEnabled } }


withMapTypeControls : Bool -> Map msg -> Map msg
withMapTypeControls isEnabled (Map ({ controls } as map)) =
    Map { map | controls = { controls | mapType = isEnabled } }


withStreetViewControls : Bool -> Map msg -> Map msg
withStreetViewControls isEnabled (Map ({ controls } as map)) =
    Map { map | controls = { controls | streetView = isEnabled } }


mapTypeToAttribute : MapType -> Attribute msg
mapTypeToAttribute mapType =
    attribute "map-type" <|
        case mapType of
            Roadmap ->
                "roadmap"

            Satellite ->
                "satellite"

            Hybrid ->
                "hybrid"

            Terrain ->
                "terrain"


journeySharingToAttributes : JourneySharing -> List (Attribute msg) -> List (Attribute msg)
journeySharingToAttributes { token, locationProvider } attributes =
    attribute "fleet-engine-access-token" token
        :: attribute "fleet-engine-project-id" locationProvider.projectId
        :: attribute "delivery-vehicle-id" locationProvider.deliveryVehicleId
        :: attributes


toHtml : Map msg -> Html msg
toHtml (Map map) =
    let
        attributes =
            map
                |> baseAttributes
                |> List.append (Events.toHtmlAttributes map.events)
                |> controlsAttributes map.controls
                |> centerAttributes map.center
                |> maybeFold (\value accu -> attribute "styles" value :: accu) map.mapStyle
                |> addIf map.shouldFitToMarkers (attribute "fit-to-markers" "true")
                |> maybeFold journeySharingToAttributes map.journeySharing

        markers =
            List.map Marker.toHtml map.markers

        polygons =
            List.map Polygon.toHtml map.polygons

        plugins =
            case map.plugins.drawingTool of
                Just ( drawingToolState, drawingToolEvents ) ->
                    [ DrawingTool.toHtml drawingToolState drawingToolEvents ]

                Nothing ->
                    []

        children =
            List.concat [ markers, polygons, plugins ]
    in
    node "google-map" attributes children


baseAttributes : Options msg -> List (Attribute msg)
baseAttributes options =
    [ attribute "api-key" options.apiKey
    , attribute "click-events" "true"
    , attribute "single-info-window" "true"
    , intToAttribute "zoom" options.zoom
    , intToAttribute "min-zoom" options.minZoom
    , intToAttribute "max-zoom" options.maxZoom
    , style "height" "100%"
    , mapTypeToAttribute options.mapType
    ]


controlsAttributes : Controls -> List (Attribute msg) -> List (Attribute msg)
controlsAttributes controls attrs =
    attrs
        |> addIf (not controls.defaultUI) (attribute "disable-default-ui" "true")
        |> addIf (not controls.zoom) (attribute "disable-zoom" "true")
        |> addIf (not controls.mapType) (attribute "disable-map-type-control" "true")
        |> addIf (not controls.streetView) (attribute "disable-street-view-control" "true")


centerAttributes : Maybe ( Float, Float ) -> List (Attribute msg) -> List (Attribute msg)
centerAttributes center =
    maybeFold
        (\( latitude, longitude ) accu ->
            attribute "latitude" (String.fromFloat latitude)
                :: attribute "longitude" (String.fromFloat longitude)
                :: accu
        )
        center


intToAttribute : String -> Int -> Attribute msg
intToAttribute attrName value =
    attribute attrName <| String.fromInt value
