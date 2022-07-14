module ZenCss.NoHtmlStylesTest exposing (all)

import Review.Test
import Test exposing (Test, describe, test)
import ZenCss.NoHtmlStyles exposing (rule)


all : Test
all =
    describe "ZenCss.NoHtmlStyles"
        [ htmlAttributesStyle
        , svgAttributesStyle
        ]


htmlAttributesStyle : Test
htmlAttributesStyle =
    describe "Html.Attributes.style"
        [ test "should report an error when Html.Attributes.style is used" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Html.Attributes

main : Html msg
main =
    Html.div [ Html.Attributes.style "color" "blue" ]
        [ Html.text "Hello!" ]
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Html.Attributes.style`"
                            , details = [ "Use the `CSS.Attributes.class` instead." ]
                            , under = "Html.Attributes.style"
                            }
                        ]
        , test "should report an error when Html.Attributes.style is aliased" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Html.Attributes as Attributes

main : Html msg
main =
    Html.div [ Attributes.style "color" "blue" ]
        [ Html.text "Hello!" ]
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Html.Attributes.style`"
                            , details = [ "Use the `CSS.Attributes.class` instead." ]
                            , under = "Attributes.style"
                            }
                        ]
        , test "should report an error when Html.Attributes.style is exposed" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (style)

main : Html msg
main =
    Html.div [ style "color" "blue" ]
        [ Html.text "Hello!" ]
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Html.Attributes.style`"
                            , details = [ "Use the `CSS.Attributes.class` instead." ]
                            , under = "style"
                            }
                            |> Review.Test.atExactly { start = { row = 8, column = 16 }, end = { row = 8, column = 21 } }
                        ]
        , test "should report an error when Html.Attributes.style is aliased and exposed (using alias)" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Html.Attributes as Attributes exposing (style)

main : Html msg
main =
    Html.div [ Attributes.style "color" "blue" ]
        [ Html.text "Hello!" ]
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Html.Attributes.style`"
                            , details = [ "Use the `CSS.Attributes.class` instead." ]
                            , under = "Attributes.style"
                            }
                        ]
        , test "should report an error when Html.Attributes.style is aliased and exposed (using exposed)" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Html.Attributes as Attributes exposing (style)

main : Html msg
main =
    Html.div [ style "color" "blue" ]
        [ Html.text "Hello!" ]
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Html.Attributes.style`"
                            , details = [ "Use the `CSS.Attributes.class` instead." ]
                            , under = "style"
                            }
                            |> Review.Test.atExactly { start = { row = 8, column = 16 }, end = { row = 8, column = 21 } }
                        ]
        ]


svgAttributesStyle : Test
svgAttributesStyle =
    describe "Svg.Attributes.style"
        [ test "should report an error when Svg.Attributes.style is used" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Svg
import Svg.Attributes

main : Html msg
main =
    Svg.svg [ Svg.Attributes.style "color" "blue" ] []
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Svg.Attributes.style`"
                            , details = [ "Use the `CSS.Attributes.svgClass` instead." ]
                            , under = "Svg.Attributes.style"
                            }
                        ]
        , test "should report an error when Svg.Attributes.style is aliased" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Svg
import Svg.Attributes as Attributes

main : Html msg
main =
    Svg.svg [ Attributes.style "color" "blue" ] []
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Svg.Attributes.style`"
                            , details = [ "Use the `CSS.Attributes.svgClass` instead." ]
                            , under = "Attributes.style"
                            }
                        ]
        , test "should report an error when Svg.Attributes.style is exposed" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Svg
import Svg.Attributes exposing (style)

main : Html msg
main =
    Svg.svg [ style "color" "blue" ] []
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Svg.Attributes.style`"
                            , details = [ "Use the `CSS.Attributes.svgClass` instead." ]
                            , under = "style"
                            }
                            |> Review.Test.atExactly { start = { row = 9, column = 15 }, end = { row = 9, column = 20 } }
                        ]
        , test "should report an error when Svg.Attributes.style is aliased and exposed (using alias)" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Svg
import Svg.Attributes as Attributes exposing (style)

main : Html msg
main =
    Svg.svg [ Attributes.style "color" "blue" ] []
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Svg.Attributes.style`"
                            , details = [ "Use the `CSS.Attributes.svgClass` instead." ]
                            , under = "Attributes.style"
                            }

                        -- |> Review.Test.atExactly
                        ]
        , test "should report an error when Svg.Attributes.style is aliased and exposed (using exposed)" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Svg
import Svg.Attributes as Attributes exposing (style)

main : Html msg
main =
    Svg.svg [ style "color" "blue" ] []
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Svg.Attributes.style`"
                            , details = [ "Use the `CSS.Attributes.svgClass` instead." ]
                            , under = "style"
                            }
                            |> Review.Test.atExactly { start = { row = 9, column = 15 }, end = { row = 9, column = 20 } }
                        ]
        ]
