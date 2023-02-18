module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text, span)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)



-- MAIN


main : Program () Model Msg
main =
  Browser.sandbox { init = init, update = update, view = view }

-- MODEL
type alias Model = Int


init : Model
init = 0

-- UPDATE
type Msg = Regenerate

update : Msg -> Model -> Model
update msg model =
  case msg of
    Regenerate -> model

-- VIEW

mkHeaders: Char -> Html msg
mkHeaders c = div [] [ span [] [ text (String.fromChar c) ]]

mkColumn: Int -> Html msg
mkColumn i = div [ class ("column " ++ (String.fromInt i)) ] []

view : Model -> Html Msg
view model = 
  div [] [
    button [ onClick Regenerate ] [text "Generate New Card"],
    div [ class "clear" ] [],
    div [ class "card" ] (
      (div [ class "headers"] (List.map mkHeaders (String.toList "BINGO")))
      :: (List.map mkColumn (List.range 1 5))
    ),
    div [class "temp" ] []
  ]