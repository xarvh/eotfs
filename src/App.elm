module Main exposing (..)

import Html
import Json.Decode as Json exposing (at, string)
import Set


-- import Time exposing (Time)


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
        }


type Msg
    = Noop


update : Msg -> Model -> Model
update msg model =
    model


view model =
    Html.text ""


main =
    Html.programWithFlags
        { init = \flags -> ( init flags, Cmd.none )
        , update = \msg model -> ( update msg model, Cmd.none )
        , view = view
        , subscriptions = \model -> Sub.none
        }
