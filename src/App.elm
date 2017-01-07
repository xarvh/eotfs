module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Json.Decode as Json exposing (at, string)
import Set


type alias Post =
    { threadName : String
    , author : String
    , content : List String
    , timestamp : String
    }


postDecoder =
    Json.map4 Post
        (at [ "thread" ] string)
        (at [ "author" ] string)
        (at [ "content" ] (Json.list string))
        (at [ "timestamp" ] string)


type alias Model =
    { db : List Post
    , threadNames : List String
    }


init : Json.Value -> Model
init flags =
    let
        db =
            flags
                |> Json.decodeValue (Json.list postDecoder)
                |> Result.withDefault []
                |> List.sortBy .timestamp

        threadNames =
            db
                |> List.map .threadName
                |> (Set.fromList >> Set.toList)
                |> List.sort
    in
        { db = db
        , threadNames = threadNames
        }


type Msg
    = Noop


update : Msg -> Model -> Model
update msg model =
    model



{-
   VIEW
-}


getPosts : Model -> List Post
getPosts model =
    List.take 10 model.db


viewThreadName : String -> Html Msg
viewThreadName threadName =
    div
        [ class "threadName" ]
        [ text threadName ]


viewPost : Post -> Html Msg
viewPost post =
    div
        [ class "post" ]
        [ div [ class "author" ] [ text post.author ]
        , div [ class "content" ] (List.map text post.content)
        ]


view : Model -> Html Msg
view model =
    div
        [ class "root" ]
        [ model.threadNames
            |> List.map viewThreadName
            |> div [ class "toc" ]
        , getPosts model
            |> List.map viewPost
            |> div [ class "posts" ]
        ]


main =
    Html.programWithFlags
        { init = \flags -> ( init flags, Cmd.none )
        , update = \msg model -> ( update msg model, Cmd.none )
        , view = view
        , subscriptions = \model -> Sub.none
        }
