module Main exposing (..)

import Browser
import Random exposing (Generator)
import Random.Set exposing (set)
import Html exposing (Html, button, div, text, span)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Set exposing (Set)
-- import Html.Lazy exposing (lazy)


-- CONSTANTS

type BingoLetter = B | I | N | G | O

bingo: List BingoLetter
bingo = [B, I, N, G, O]

-- MAIN
main : Program () Model Msg
main =
  Browser.element { init = init, subscriptions = subscriptions, update = update, view = view }

-- MODEL
type alias Model = {
    b : (List Int),
    i : (List Int),
    n : (List Int),
    g : (List Int),
    o : (List Int)
  }


generateCard: Generator Model
generateCard =
  let
    genRow: Int -> Int -> Generator (Set Int)
    genRow lower upper = set 5 <| Random.int lower upper
    convertAndSort: Int -> Int -> Generator (List Int)
    convertAndSort lower upper = Random.map (\s -> List.sort <| Set.toList s) <| genRow lower upper
  in
    Random.map5 Model
      (convertAndSort  1 15)
      (convertAndSort 16 30)
      (convertAndSort 31 45)
      (convertAndSort 46 60)
      (convertAndSort 61 75)


init : () -> (Model, Cmd Msg)
init _ = (Model [] [] [] [] [], Cmd.none)

-- UPDATE
type Msg = Generate | NewCard Model

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Generate -> (model, Random.generate NewCard generateCard)
    NewCard ll -> (ll, Cmd.none)

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

-- VIEW
renderLetter: BingoLetter -> String
renderLetter bl = case bl of
    B -> "B"
    I -> "I"
    N -> "N"
    G -> "G"
    O -> "O"

mkHeaders: BingoLetter -> Html msg
mkHeaders bl = div [] [ span [] [ text (renderLetter bl) ]]

buildBoxes: BingoLetter -> List Int -> List (Html msg)
buildBoxes bl nums =
  let
    defaultDiv: Int -> Html msg
    defaultDiv n = div [ class "number" ] [ span [] [text <| String.fromInt n] ]
    -- The "N" column should have a FREE space in the middle
    inner: Int -> Int -> Html msg
    inner i n = case bl of
      N -> if i == 2 then div [ class "number" ] [ span [] [text "FREE" ] ] else defaultDiv n
      _ -> defaultDiv n
  in
    List.indexedMap inner nums

mkColumn: Int -> BingoLetter-> Model -> Html msg
mkColumn i bl model = div [ class ("column " ++ (String.fromInt i)) ] (
  buildBoxes bl (case bl of
    B -> model.b
    I -> model.i
    N -> model.n
    G -> model.g
    O -> model.o
  ))

view : Model -> Html Msg
view model =
  div [] [
    button [ onClick Generate ] [text "Generate New Card"],
    div [ class "clear" ] [],
    div [ class "card" ] (
      (div [ class "headers"] (List.map mkHeaders bingo)) :: (List.indexedMap (\i bl -> mkColumn i bl model) bingo)
    ),
    div [class "temp" ] []
  ]