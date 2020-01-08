module GoogleMaps.Polygon exposing
    ( Polygon
    , init
    , onClick
    , toHtml
    , withClosedMode
    , withFillColor
    , withFillOpacity
    , withStrokeColor
    , withStrokeWeight
    , withZIndex
    )

import Html exposing (Html)
import Internals.Polygon as IPolygon


type Polygon msg
    = Polygon (IPolygon.Polygon msg)


init : List ( Float, Float ) -> Polygon msg
init points =
    Polygon <| IPolygon.init points


toHtml : Polygon msg -> Html msg
toHtml (Polygon polygon) =
    IPolygon.toHtml polygon


withFillColor : String -> Polygon msg -> Polygon msg
withFillColor color (Polygon polygon) =
    Polygon <| IPolygon.withFillColor color polygon


withFillOpacity : Float -> Polygon msg -> Polygon msg
withFillOpacity opacity (Polygon polygon) =
    Polygon <| IPolygon.withFillOpacity opacity polygon


withStrokeWeight : Int -> Polygon msg -> Polygon msg
withStrokeWeight strokeWeight (Polygon polygon) =
    Polygon <| IPolygon.withStrokeWeight strokeWeight polygon


withStrokeColor : String -> Polygon msg -> Polygon msg
withStrokeColor strokeColor (Polygon polygon) =
    Polygon <| IPolygon.withStrokeColor strokeColor polygon


withZIndex : Int -> Polygon msg -> Polygon msg
withZIndex zIndex (Polygon polygon) =
    Polygon <| IPolygon.withZIndex zIndex polygon


withClosedMode : Polygon msg -> Polygon msg
withClosedMode (Polygon polygon) =
    Polygon <| IPolygon.withClosedMode polygon


onClick : msg -> Polygon msg -> Polygon msg
onClick msg (Polygon polygon) =
    Polygon <| IPolygon.onClick msg polygon
