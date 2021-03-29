module GoogleMaps.Plugins.DrawingTool exposing
    ( Events, State
    , events
    , initState
    , startDrawing, stopDrawing
    , isDrawingEnabled
    )

{-| This module allows you to draw polygons on the map

This documentation it's WIP


# Types

@docs Events, State


# Events

@docs events


# Initialize State

@docs initState


# Updating state

@docs startDrawing, stopDrawing


# Utilities

@docs isDrawingEnabled

-}

import Internals.Plugins.DrawingTool as IDrawingTool


{-| Opaque type that upholds the data required to know if drawing mode is enabled or disabled.
-}
type alias State =
    IDrawingTool.State


{-| Opaque type that lists the message(s) that will be triggered with actions while drawing.
-}
type alias Events msg =
    IDrawingTool.Events msg


{-| Initializer for [State](#State).
-}
initState : State
initState =
    IDrawingTool.init


{-| Queries if the drawing mode is currently active.
-}
isDrawingEnabled : State -> Bool
isDrawingEnabled state =
    IDrawingTool.isDrawingEnabled state


{-| Enters the drawing mode. (Allows the user to draw polygons on the map)
-}
startDrawing : State -> State
startDrawing state =
    IDrawingTool.startDrawing state


{-| Leaves the drawing mode. (Does not allows the user to draw on the map)
-}
stopDrawing : State -> State
stopDrawing state =
    IDrawingTool.stopDrawing state


{-| Initializer for [Events](#Events). Requires a message that will trigger once the user closes a polygon.
-}
events : (List ( Float, Float ) -> msg) -> Events msg
events onPolygonCompleted =
    IDrawingTool.events onPolygonCompleted
