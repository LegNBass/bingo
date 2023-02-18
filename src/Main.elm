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
view : Model -> Html Msg
view model = 
  div [] [
    div [ class "clear" ] [],
    div [ class "card" ] [
      div [ class "headers"] [
        div [] [ span [] [text "B"] ],
        div [] [ span [] [text "I"] ],
        div [] [ span [] [text "N"] ],
        div [] [ span [] [text "G"] ],
        div [] [ span [] [text "O"] ]
      ],
      div [ class "column 1"] [],
      div [ class "column 2"] [],
      div [ class "column 3"] [],
      div [ class "column 4"] [],
      div [ class "column 5"] []
    ],
    div [class "temp" ] [],
    button [ onClick Regenerate ] [text "Generate New Card"]
  ]