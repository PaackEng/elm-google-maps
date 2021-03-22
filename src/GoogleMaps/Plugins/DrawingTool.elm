module GoogleMaps.Plugins.DrawingTool exposing
    ( Config
    , State
    , initState
    , isDrawingEnabled
    , startDrawing
    , stopDrawing
    )

import Internals.Plugins.DrawingTool as IDrawingTool


type alias State =
    IDrawingTool.State


type alias Config msg =
    IDrawingTool.Config msg


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
