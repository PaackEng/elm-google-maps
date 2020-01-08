module Internals.Helpers exposing (addIf, maybeAdd)

import Html exposing (Attribute)


maybeAdd : (a -> List (Attribute msg)) -> Maybe a -> List (Attribute msg) -> List (Attribute msg)
maybeAdd toAttrsFn maybeItem attrs =
    maybeItem
        |> Maybe.map (toAttrsFn >> List.append attrs)
        |> Maybe.withDefault attrs


addIf : Bool -> a -> List a -> List a
addIf shouldAdd item list =
    if shouldAdd then
        item :: list

    else
        list
