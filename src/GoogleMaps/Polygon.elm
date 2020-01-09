module GoogleMaps.Polygon exposing
    ( Polygon, Latitude, Longitude
    , init
    , withClosedMode, withFillColor, withFillOpacity, withStrokeColor, withStrokeWeight, withZIndex
    , onClick
    , toHtml
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


# Don't touch this :o

@docs toHtml

-}

import Html exposing (Html)
import Internals.Polygon as IPolygon


{-| -}
type Polygon msg
    = Polygon (IPolygon.Polygon msg)


{-| -}
type alias Latitude =
    Float


{-| -}
type alias Longitude =
    Float


{-| -}
init : List ( Latitude, Latitude ) -> Polygon msg
init points =
    Polygon <| IPolygon.init points


{-| There is no default color

this function accepts the same formats as the css color values

E.g `"rbg(255,255,0)", "orange" or "#ff00ff"`

-}
withFillColor : String -> Polygon msg -> Polygon msg
withFillColor color (Polygon polygon) =
    Polygon <| IPolygon.withFillColor color polygon


{-| The default is 0
-}
withFillOpacity : Float -> Polygon msg -> Polygon msg
withFillOpacity opacity (Polygon polygon) =
    Polygon <| IPolygon.withFillOpacity opacity polygon


{-| The default is 3
-}
withStrokeWeight : Int -> Polygon msg -> Polygon msg
withStrokeWeight strokeWeight (Polygon polygon) =
    Polygon <| IPolygon.withStrokeWeight strokeWeight polygon


{-| The default is black

this function accepts the same formats as the css color values

E.g `"rbg(255,255,0)", "orange" or "#ff00ff"`

-}
withStrokeColor : String -> Polygon msg -> Polygon msg
withStrokeColor strokeColor (Polygon polygon) =
    Polygon <| IPolygon.withStrokeColor strokeColor polygon


{-| -}
withZIndex : Int -> Polygon msg -> Polygon msg
withZIndex zIndex (Polygon polygon) =
    Polygon <| IPolygon.withZIndex zIndex polygon


{-| it forces the polygon to be a closed shape
-}
withClosedMode : Polygon msg -> Polygon msg
withClosedMode (Polygon polygon) =
    Polygon <| IPolygon.withClosedMode polygon


{-| -}
onClick : msg -> Polygon msg -> Polygon msg
onClick msg (Polygon polygon) =
    Polygon <| IPolygon.onClick msg polygon


{-| You should not use this function, GoogleMaps.Map uses it in order to render the polygon.
-}
toHtml : Polygon msg -> Html msg
toHtml (Polygon polygon) =
    IPolygon.toHtml polygon
