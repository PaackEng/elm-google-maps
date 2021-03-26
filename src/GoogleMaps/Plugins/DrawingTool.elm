module GoogleMaps.Plugins.DrawingTool exposing
    ( Events
    , State
    , events
    , initState
    , isDrawingEnabled
    , startDrawing
    , stopDrawing
    )

import Internals.Plugins.DrawingTool as IDrawingTool


type alias State =
    IDrawingTool.State


type alias Events msg =
    IDrawingTool.Events msg


initState : State
initState =
    IDrawingTool.init


isDrawingEnabled : State -> Bool
isDrawingEnabled state =
    IDrawingTool.isDrawingEnabled state


startDrawing : State -> State
startDrawing state =
    IDrawingTool.startDrawing state


stopDrawing : State -> State
stopDrawing state =
    IDrawingTool.stopDrawing state


events : (List ( Float, Float ) -> msg) -> Events msg
events onPolygonCompleted =
    IDrawingTool.events onPolygonCompleted
