module Main exposing (main)

import Browser
import GoogleMaps.Map as Map
import GoogleMaps.Marker as Marker exposing (Marker)
import GoogleMaps.Plugins.DrawingTool as DrawingTool
import GoogleMaps.Polygon as Polygon exposing (Polygon)
import Html exposing (Html, button, div, h1, img, li, ol, p, text)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)



---- MODEL ----


type alias PolygonCoordinates =
    List ( Float, Float )


type alias Model =
    { mapType : Map.MapType
    , googleMapKey : String
    , showReadyText : Bool
    , clickCount : Int
    , drawingTool : DrawingTool.State
    , polygons : List PolygonCoordinates
    }


init : String -> ( Model, Cmd Msg )
init key =
    ( { mapType = Map.roadmap
      , googleMapKey = key
      , showReadyText = False
      , clickCount = 0
      , drawingTool = DrawingTool.initState
      , polygons =
            [ [ ( -3.7344654, -38.5057405 )
              , ( -3.7366108, -38.5188557 )
              , ( -3.7374002, -38.5195225 )
              , ( -3.7474947, -38.5153675 )
              ]
            ]
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = ChangeMapType Map.MapType
    | ShowReadyText
    | OnMapObjectClicked
    | OnStartDrawingClicked
    | OnStopDrawingClicked
    | OnPolygonCompleted (List ( Float, Float ))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeMapType newMapType ->
            ( { model | mapType = newMapType }, Cmd.none )

        ShowReadyText ->
            ( { model | showReadyText = True }, Cmd.none )

        OnMapObjectClicked ->
            ( { model | clickCount = model.clickCount + 1 }, Cmd.none )

        OnStartDrawingClicked ->
            ( { model
                | drawingTool =
                    DrawingTool.startDrawing model.drawingTool
              }
            , Cmd.none
            )

        OnStopDrawingClicked ->
            ( { model
                | drawingTool =
                    DrawingTool.stopDrawing model.drawingTool
              }
            , Cmd.none
            )

        OnPolygonCompleted polygonCoords ->
            ( { model
                | drawingTool =
                    DrawingTool.stopDrawing model.drawingTool
                , polygons = polygonCoords :: model.polygons
              }
            , Cmd.none
            )



---- VIEW ----


googleMapView : Model -> Html Msg
googleMapView { mapType, googleMapKey, drawingTool, polygons } =
    Map.init googleMapKey
        |> Map.withMapType mapType
        |> Map.withFitToMarkers True
        |> Map.onMapReady ShowReadyText
        |> Map.withZoom 13
        |> Map.withMarkers markers
        |> Map.withPolygons (buildPolygons polygons)
        |> Map.withDrawingTool
            drawingTool
            (DrawingTool.events OnPolygonCompleted)
        |> Map.toHtml


buildPolygons : List PolygonCoordinates -> List (Polygon Msg)
buildPolygons polygons =
    let
        polygon polyCoords =
            Polygon.init polyCoords
                |> Polygon.withStrokeColor "red"
                |> Polygon.withFillColor "rgb(0, 255,0)"
                |> Polygon.withFillOpacity 0.25
                |> Polygon.onClick OnMapObjectClicked
                |> Polygon.withClosedMode
    in
    List.map polygon polygons


markers : List (Marker Msg)
markers =
    let
        marker =
            Marker.init -3.7715105 -38.5724269
                |> Marker.onClick OnMapObjectClicked
                |> Marker.withDraggableMode
    in
    [ marker ]


drawingView : DrawingTool.State -> Html Msg
drawingView drawingTool =
    div []
        [ if DrawingTool.isDrawingEnabled drawingTool then
            button
                [ onClick OnStopDrawingClicked ]
                [ text "Stop Drawing" ]

          else
            button
                [ onClick OnStartDrawingClicked ]
                [ text "Start Drawing" ]
        ]


polygonsDebugger : List PolygonCoordinates -> Html Msg
polygonsDebugger polys =
    let
        coordDebugger ( lat, lng ) =
            ol [] [ text ("( " ++ String.fromFloat lat ++ ", " ++ String.fromFloat lng ++ " )") ]

        polygonDebugger index poly =
            p
                []
                [ text <| "Polygon " ++ String.fromInt index
                , ol [] (List.map coordDebugger poly)
                ]
    in
    polys
        |> List.reverse
        |> List.indexedMap polygonDebugger
        |> div []


view : Model -> Html Msg
view model =
    let
        readyText =
            if model.showReadyText then
                "Map Loaded"

            else
                "Loading map"
    in
    div [ style "height" "400px" ]
        [ googleMapView model
        , div []
            [ button [ onClick <| ChangeMapType Map.satellite ] [ text "Satellite" ]
            , button [ onClick <| ChangeMapType Map.roadmap ] [ text "Roadmap" ]
            , button [ onClick <| ChangeMapType Map.hybrid ] [ text "hybrid" ]
            , button [ onClick <| ChangeMapType Map.terrain ] [ text "terrain" ]
            ]
        , p [] [ text readyText ]
        , p [] [ text <| "Click " ++ String.fromInt model.clickCount ]
        , drawingView model.drawingTool
        , polygonsDebugger model.polygons
        ]



---- PROGRAM ----


main : Program String Model Msg
main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
