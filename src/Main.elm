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
    convertAndSort: Set Int -> List Int
    convertAndSort s = List.sort <| Set.toList s
    genRow: Int -> Int -> Generator (Set Int)
    genRow lower upper = set 5 <| Random.int lower upper
  in 
    Random.map5 Model 
      (Random.map convertAndSort <| genRow  1 15)
      (Random.map convertAndSort <| genRow 16 30)
      (Random.map convertAndSort <| genRow 31 45)
      (Random.map convertAndSort <| genRow 46 60)
      (Random.map convertAndSort <| genRow 61 75) 


init : () -> (Model, Cmd Msg)
init _ = (Model [] [] [] [] [], Cmd.none)

-- UPDATE
type Msg = Generate | NewCard Model

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Generate -> (model, Random.generate NewCard generateCard) --TODO: generate a new card
    NewCard ll -> (ll, Cmd.none) --TODO: Add newly random numbers to the model

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

buildBoxes: List Int -> List (Html msg)
buildBoxes nums = nums
              |> List.map (\n -> div [ class "number" ] [ span [] [text <| String.fromInt n] ] )

mkColumn: Int -> BingoLetter-> Model -> Html msg
mkColumn i bl model = div [ class ("column " ++ (String.fromInt i)) ] (
  buildBoxes ( case bl of 
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