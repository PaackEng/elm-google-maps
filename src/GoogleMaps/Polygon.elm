module GoogleMaps.Polygon exposing
    ( Polygon, Latitude, Longitude
    , init
    , withClosedMode, withFillColor, withFillOpacity, withStrokeColor, withStrokeWeight, withZIndex
    , onClick
    )

{-| This module allows you to create polygons to be used along with GoogleMaps.Map

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
            |> Polygon.onClick OnMarkerClicked
            |> Polygon.withClosedMode

    mapView : String -> Html Msg
    mapView apiKey =
        Map.init apiKey
            |> Map.withPolygons [ myPolygon ]
            |> Map.toHtml


# Types

@docs Polygon, Latitude, Longitude


# Basics

@docs init


# Modifiers

@docs withClosedMode, withFillColor, withFillOpacity, withStrokeColor, withStrokeWeight, withZIndex


# Events

@docs onClick

-}

import Html exposing (Html)
import Internals.Polygon as IPolygon


{-| -}
type alias Polygon msg =
    IPolygon.Polygon msg


{-| -}
type alias Latitude =
    Float


{-| -}
type alias Longitude =
    Float


{-| -}
init : List ( Latitude, Latitude ) -> Polygon msg
init points =
    IPolygon.init points


{-| There is no default color

this function accepts the same formats as the CSS color values

E.g `"rbg(255,255,0)", "orange" or "#ff00ff"`

-}
withFillColor : String -> Polygon msg -> Polygon msg
withFillColor color polygon =
    IPolygon.withFillColor color polygon


{-| The default is 0
-}
withFillOpacity : Float -> Polygon msg -> Polygon msg
withFillOpacity opacity polygon =
    IPolygon.withFillOpacity opacity polygon


{-| The default is 3
-}
withStrokeWeight : Int -> Polygon msg -> Polygon msg
withStrokeWeight strokeWeight polygon =
    IPolygon.withStrokeWeight strokeWeight polygon


{-| The default is black

this function accepts the same formats as the CSS color values

E.g `"rbg(255,255,0)", "orange" or "#ff00ff"`

-}
withStrokeColor : String -> Polygon msg -> Polygon msg
withStrokeColor strokeColor polygon =
    IPolygon.withStrokeColor strokeColor polygon


{-| -}
withZIndex : Int -> Polygon msg -> Polygon msg
withZIndex zIndex polygon =
    IPolygon.withZIndex zIndex polygon


{-| It forces the polygon to be a closed shape
-}
withClosedMode : Polygon msg -> Polygon msg
withClosedMode polygon =
    IPolygon.withClosedMode polygon


{-| -}
onClick : msg -> Polygon msg -> Polygon msg
onClick msg polygon =
    IPolygon.onClick msg polygon
