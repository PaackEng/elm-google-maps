module Internals.Helpers exposing (addIf, maybeAdd, maybeFold)


maybeFold :
    (a -> b -> b)
    -> Maybe a
    -> b
    -> b
maybeFold fold maybeItem accu =
    case maybeItem of
        Just item ->
            fold item accu

        Nothing ->
            accu


maybeAdd : (a -> List b) -> Maybe a -> List b -> List b
maybeAdd map =
    maybeFold (\item accu -> map item ++ accu)


addIf : Bool -> a -> List a -> List a
addIf shouldAdd item list =
    if shouldAdd then
        item :: list

    else
        list
