module Pages.Home_ exposing (Model, Msg, page)

import Effect exposing (Effect)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- INIT


type alias Model =
    { name : String
    , messageFromTauri : Maybe String
    }


init : () -> ( Model, Effect Msg )
init () =
    ( { name = ""
      , messageFromTauri = Nothing
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = ChangedName String
    | SubmittedForm
    | TauriResponded String


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ChangedName name ->
            ( { model | name = name }
            , Effect.none
            )

        SubmittedForm ->
            ( model
            , Effect.sendNameToTauri model.name
            )

        TauriResponded reply ->
            ( { model | messageFromTauri = Just reply }
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Effect.listenForGreeting TauriResponded



-- VIEW


view : Model -> View Msg
view model =
    { title = "Homepage"
    , body =
        [ div
            [ class "container" ]
            [ h1 [] [ text "Elm Land ❤️ Tauri" ]
            , div
                [ class "row" ]
                [ a
                    [ href "https://elm.land"
                    , target "_blank"
                    ]
                    [ img
                        [ src "/assets/elm-land-480.png"
                        , class "logo vanilla"
                        , alt "JavaScript logo"
                        ]
                        []
                    ]
                , a
                    [ href "https://tauri.app", target "_blank" ]
                    [ img
                        [ src "/assets/tauri.svg"
                        , class "logo tauri"
                        , alt "Tauri logo"
                        ]
                        []
                    ]
                ]
            , p [] [ text "Click on a logo to learn more about each framework" ]
            , Html.form
                [ class "row", Html.Events.onSubmit SubmittedForm ]
                [ input [ placeholder "Enter a name...", Html.Events.onInput ChangedName, value model.name ] []
                , button [ type_ "submit" ] [ text "Greet" ]
                ]
            , case model.messageFromTauri of
                Just message ->
                    p [] [ text message ]

                Nothing ->
                    text ""
            ]
        ]
    }
