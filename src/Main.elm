module Main exposing (..)

import Browser
import Random exposing (Generator)
import Random.Set exposing (set)
import Dict exposing (Dict)
import Html exposing (Html, button, div, text, span)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Set exposing (Set)
-- import Html.Lazy exposing (lazy)


-- CONSTANTS
bingo: List Char
bingo = String.toList "BINGO"

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
    genUnique: List Int -> Generator Int 
    genUnique used = Random.int 1 75 |> Random.andThen (
      \n -> if List.member n used then
              genUnique used -- Tail Recursion possible in elm?
            else
            -- Is there such thing as a generator literal
              (Random.int n n)
      )

    genRow: Generator (List Int)
    genRow = Random.list 5 <| genUnique []
  in 
    Random.map5 Model genRow genRow genRow genRow genRow 


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

mkHeaders: Char -> Html msg
mkHeaders c = div [] [ span [] [ text (String.fromChar c) ]]

buildBoxes: Char -> List (Html msg)
buildBoxes c = List.range 1 5 -- TODO: Get the number list from the model here and use them in the lambda
              |> List.map (\_ -> div [ class "number" ] [ span [] [text <| String.fromChar c] ] )

mkColumn: Int -> Char-> Model -> Html msg
mkColumn i c model = div [ class ("column " ++ (String.fromInt i)) ] (buildBoxes c)

view : Model -> Html Msg
view model = 
  div [] [
    button [ onClick Generate ] [text "Generate New Card"],
    div [ class "clear" ] [],
    div [ class "card" ] (
      (div [ class "headers"] (List.map mkHeaders bingo)) :: (List.indexedMap (\i c -> mkColumn i c model) bingo)
    ),
    div [class "temp" ] []
  ]