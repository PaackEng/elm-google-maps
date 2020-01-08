module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h1, img, p, text)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import Map
import Marker exposing (Marker)
import Polygon exposing (Polygon)



---- MODEL ----


type alias Model =
    { mapType : Map.MapType
    , googleMapKey : String
    , showReadyText : Bool
    , clickCount : Int
    }


init : String -> ( Model, Cmd Msg )
init key =
    ( { mapType = Map.roadmap
      , googleMapKey = key
      , showReadyText = False
      , clickCount = 0
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = ChangeMapType Map.MapType
    | ShowReadyText
    | OnMarkerClicked


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeMapType newMapType ->
            ( { model | mapType = newMapType }, Cmd.none )

        ShowReadyText ->
            ( { model | showReadyText = True }, Cmd.none )

        OnMarkerClicked ->
            ( { model | clickCount = model.clickCount + 1 }, Cmd.none )



---- VIEW ----


googleMapView : Model -> Html Msg
googleMapView { mapType, googleMapKey } =
    Map.init googleMapKey 400
        --|> Map.withMapType mapType
        --|> Map.withCustomStyle mapStyle
        --|> Map.withFitToMarkers True
        --|> Map.onMapReady ShowReadyText
        --|> Map.withZoom 13
        --|> Map.withMarkers markers
        --|> Map.withPolygons polygons
        |> Map.toHtml


polygons : List (Polygon Msg)
polygons =
    let
        polygon =
            Polygon.init
                [ ( -3.7344654, -38.5057405 )
                , ( -3.7366108, -38.5188557 )
                , ( -3.7374002, -38.5195225 )
                , ( -3.7474947, -38.5153675 )
                ]
                |> Polygon.withStrokeColor "red"
                |> Polygon.withFillColor "orange"
                |> Polygon.withFillOpacity 0.25
                |> Polygon.onClick OnMarkerClicked
                |> Polygon.withClosedMode
    in
    [ polygon ]


markers : List (Marker Msg)
markers =
    let
        marker =
            Marker.init -3.7715105 -38.5724269
                |> Marker.onClick OnMarkerClicked
                |> Marker.withDraggableMode
    in
    [ marker ]


view : Model -> Html Msg
view model =
    let
        readyText =
            if model.showReadyText then
                "Map Loaded"

            else
                "Loading map"
    in
    div []
        [ googleMapView model
        , div []
            [ button [ onClick <| ChangeMapType Map.satellite ] [ text "Satellite" ]
            , button [ onClick <| ChangeMapType Map.roadmap ] [ text "Roadmap" ]
            , button [ onClick <| ChangeMapType Map.hybrid ] [ text "hybrid" ]
            , button [ onClick <| ChangeMapType Map.terrain ] [ text "terrain" ]
            ]
        , p [] [ text readyText ]
        , p [] [ text <| "Click " ++ String.fromInt model.clickCount ]
        ]


mapStyle : String
mapStyle =
    """
[
    {
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#f5f5f5"
            }
        ]
    },
    {
        "elementType": "labels.icon",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#616161"
            }
        ]
    },
    {
        "elementType": "labels.text.stroke",
        "stylers": [
            {
                "color": "#f5f5f5"
            }
        ]
    },
    {
        "featureType": "administrative",
        "elementType": "geometry",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "administrative.land_parcel",
        "elementType": "labels",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "administrative.land_parcel",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#bdbdbd"
            }
        ]
    },
    {
        "featureType": "poi",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#eeeeee"
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "labels.text",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#757575"
            }
        ]
    },
    {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#e5e5e5"
            }
        ]
    },
    {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#9e9e9e"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#ffffff"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "labels.icon",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#757575"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#dadada"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#616161"
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "labels",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#9e9e9e"
            }
        ]
    },
    {
        "featureType": "transit",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "transit.line",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#e5e5e5"
            }
        ]
    },
    {
        "featureType": "transit.station",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#eeeeee"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#c9c9c9"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#9e9e9e"
            }
        ]
    }
]
"""



---- PROGRAM ----


main : Program String Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
