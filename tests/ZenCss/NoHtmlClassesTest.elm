module ZenCss.NoHtmlClassesTest exposing (all)

import Review.Test
import Test exposing (Test, describe, test)
import ZenCss.NoHtmlClasses exposing (rule)


all : Test
all =
    describe "ZenCss.NoHtmlClasses"
        [ test "should report an error when Html.Attributes.class is used" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Html.Attributes

main : Html msg
main =
    Html.div [ Html.Attributes.class "container" ]
        [ Html.text "Hello!" ]
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Html.Attributes.class`"
                            , details = [ "Use the `CSS.Attributes.class` instead." ]
                            , under = "Html.Attributes.class \"container\""
                            }
                        ]
        , test "should report an error when Html.Attributes.class is aliased" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Html.Attributes as Attributes

main : Html msg
main =
    Html.div [ Attributes.class "container" ]
        [ Html.text "Hello!" ]
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Html.Attributes.class`"
                            , details = [ "Use the `CSS.Attributes.class` instead." ]
                            , under = "Attributes.class \"container\""
                            }
                        ]
        , test "should report an error when Html.Attributes.class is exposed" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (class)

main : Html msg
main =
    Html.div [ class "container" ]
        [ Html.text "Hello!" ]
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Html.Attributes.class`"
                            , details = [ "Use the `CSS.Attributes.class` instead." ]
                            , under = "class \"container\""
                            }
                        ]
        , test "should report an error when Html.Attributes.class is aliased and exposed (using alias)" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Html.Attributes as Attributes exposing (class)

main : Html msg
main =
    Html.div [ Attributes.class "container" ]
        [ Html.text "Hello!" ]
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Html.Attributes.class`"
                            , details = [ "Use the `CSS.Attributes.class` instead." ]
                            , under = "Attributes.class \"container\""
                            }
                        ]
        , test "should report an error when Html.Attributes.class is aliased and exposed (using exposed)" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Html.Attributes as Attributes exposing (class)

main : Html msg
main =
    Html.div [ class "container" ]
        [ Html.text "Hello!" ]
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Html.Attributes.class`"
                            , details = [ "Use the `CSS.Attributes.class` instead." ]
                            , under = "class \"container\""
                            }
                        ]
        ]
