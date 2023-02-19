module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text, span)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Html.Lazy exposing (lazy)


-- CONSTANTS
bingo: List Char
bingo = String.toList "BINGO"

-- MAIN
main : Program () Model Msg
main =
  Browser.sandbox { init = init, update = update, view = view }

-- MODEL
type alias Model = List String


init : Model
init = []

-- UPDATE
type Msg = Regenerate

update : Msg -> Model -> Model
update msg model =
  case msg of
    Regenerate -> model

-- VIEW

mkHeaders: Char -> Html msg
mkHeaders c = div [] [ span [] [ text (String.fromChar c) ]]

buildBoxes: Char -> List (Html msg)
buildBoxes c = List.range 1 5
              |> List.map (\_ -> div [ class "number" ] [ span [] [text <| String.fromChar c] ] )

mkColumn: Int -> Char-> Model -> Html msg
mkColumn i c model = div [ class ("column " ++ (String.fromInt i)) ] (buildBoxes c)

view : Model -> Html Msg
view model = 
  div [] [
    button [ onClick Regenerate ] [text "Generate New Card"],
    div [ class "clear" ] [],
    div [ class "card" ] (
      (div [ class "headers"] (List.map mkHeaders bingo))
      :: (List.indexedMap (\i c -> mkColumn i c model) bingo)
    ),
    div [class "temp" ] []
  ]