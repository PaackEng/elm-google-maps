module Internals.Map exposing
    ( Map
    , MapType(..)
    , init
    , onMapClick
    , onMapReady
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

import Html exposing (Attribute, Html, node)
import Html.Attributes exposing (attribute, style)
import Internals.Helpers exposing (addIf, maybeAdd)
import Internals.Map.Events as Events exposing (Events)
import Marker exposing (Marker)
import Polygon exposing (Polygon)


type alias Map msg =
    { apiKey : ApiKey
    , markers : List (Marker msg)
    , polygons : List (Polygon msg)
    , mapType : MapType
    , center : Maybe ( Float, Float )
    , minZoom : Int
    , maxZoom : Int
    , zoom : Int
    , mapStyle : Maybe String
    , shouldFitToMarkers : Bool
    , controls : Controls
    , events : Events msg
    }


type alias Controls =
    { defaultUI : Bool
    , zoom : Bool
    , mapType : Bool
    , streetView : Bool
    }


type MapType
    = Roadmap
    | Satellite
    | Hybrid
    | Terrain


type alias ApiKey =
    String


init : ApiKey -> Map msg
init apiKey =
    { apiKey = apiKey
    , markers = []
    , polygons = []
    , mapType = Roadmap
    , center = Nothing
    , minZoom = 0
    , maxZoom = 20
    , zoom = 14
    , mapStyle = Nothing
    , shouldFitToMarkers = False
    , controls = initControls
    , events = Events.init
    }


initControls : Controls
initControls =
    { defaultUI = True
    , zoom = True
    , mapType = True
    , streetView = True
    }


withCenter : Float -> Float -> Map msg -> Map msg
withCenter latitude longitude map =
    { map | center = Just ( latitude, longitude ) }



-- TODO: Type all the styles!


withCustomStyle : String -> Map msg -> Map msg
withCustomStyle mapStyle map =
    { map | mapStyle = Just mapStyle }


withMapType : MapType -> Map msg -> Map msg
withMapType mapType map =
    { map | mapType = mapType }


withZoom : Int -> Map msg -> Map msg
withZoom zoom map =
    { map | zoom = zoom }


withMinZoom : Int -> Map msg -> Map msg
withMinZoom minZoom map =
    { map | minZoom = minZoom }


withMaxZoom : Int -> Map msg -> Map msg
withMaxZoom maxZoom map =
    { map | maxZoom = maxZoom }


withFitToMarkers : Bool -> Map msg -> Map msg
withFitToMarkers shouldFitToMarkers map =
    { map | shouldFitToMarkers = shouldFitToMarkers }


withMarkers : List (Marker msg) -> Map msg -> Map msg
withMarkers markers map =
    { map | markers = markers }


withPolygons : List (Polygon msg) -> Map msg -> Map msg
withPolygons polygons map =
    { map | polygons = polygons }



-- Events


onMapReady : msg -> Map msg -> Map msg
onMapReady evt ({ events } as map) =
    { map | events = { events | onMapReady = Just evt } }



-- TODO: find a way to get the latitude and longitude, otherwise is an useless event


onMapClick : msg -> Map msg -> Map msg
onMapClick evt ({ events } as map) =
    { map | events = { events | onMapClick = Just evt } }



-- Controls


withDefaultUIControls : Bool -> Map msg -> Map msg
withDefaultUIControls isEnabled ({ controls } as map) =
    { map | controls = { controls | defaultUI = isEnabled } }


withZoomActions : Bool -> Map msg -> Map msg
withZoomActions isEnabled ({ controls } as map) =
    { map | controls = { controls | zoom = isEnabled } }


withMapTypeControls : Bool -> Map msg -> Map msg
withMapTypeControls isEnabled ({ controls } as map) =
    { map | controls = { controls | mapType = isEnabled } }


withStreetViewControls : Bool -> Map msg -> Map msg
withStreetViewControls isEnabled ({ controls } as map) =
    { map | controls = { controls | streetView = isEnabled } }


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


toHtml : Map msg -> Html msg
toHtml map =
    let
        attributes =
            map
                |> baseAttributes
                |> List.append (Events.toHtmlAttributes map.events)
                |> controlsAttributes map.controls
                |> centerAttributes map.center
                |> maybeAdd (\mapStyle -> [ attribute "styles" mapStyle ]) map.mapStyle
                |> addIf map.shouldFitToMarkers (attribute "fit-to-markers" "true")

        markers =
            List.map Marker.toHtml map.markers

        polygons =
            List.map Polygon.toHtml map.polygons
    in
    node "google-map" attributes (List.append markers polygons)


baseAttributes : Map msg -> List (Attribute msg)
baseAttributes map =
    [ attribute "api-key" map.apiKey
    , attribute "click-events" "true"
    , intToAttribute "zoom" map.zoom
    , intToAttribute "min-zoom" map.minZoom
    , intToAttribute "max-zoom" map.maxZoom
    , style "height" "100%"
    , mapTypeToAttribute map.mapType
    ]


controlsAttributes : Controls -> List (Attribute msg) -> List (Attribute msg)
controlsAttributes controls attrs =
    attrs
        |> addIf (not controls.defaultUI) (attribute "disable-default-ui" "true")
        |> addIf (not controls.zoom) (attribute "disable-zoom" "true")
        |> addIf (not controls.mapType) (attribute "disable-map-type-control" "true")
        |> addIf (not controls.streetView) (attribute "disable-street-view-control" "true")


centerAttributes : Maybe ( Float, Float ) -> List (Attribute msg) -> List (Attribute msg)
centerAttributes center attrs =
    attrs
        |> maybeAdd
            (\( latitude, longitude ) ->
                [ attribute "latitude" (String.fromFloat latitude)
                , attribute "longitude" (String.fromFloat longitude)
                ]
            )
            center


intToAttribute : String -> Int -> Attribute msg
intToAttribute attrName value =
    attribute attrName <| String.fromInt value
