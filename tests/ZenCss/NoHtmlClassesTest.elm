module ZenCss.NoHtmlClassesTest exposing (all)

import Review.Test
import Test exposing (Test, describe, test)
import ZenCss.NoHtmlClasses exposing (rule)


all : Test
all =
    describe "ZenCss.NoHtmlClasses"
        [ htmlAttributesClass
        , htmlAttributesClassList
        , svgAttributesClass
        ]


htmlAttributesClass : Test
htmlAttributesClass =
    describe "Html.Attributes.class"
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


htmlAttributesClassList : Test
htmlAttributesClassList =
    describe "Html.Attributes.classList"
        [ test "should report an error when Html.Attributes.classList is used" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Html.Attributes

main : Html msg
main =
    Html.div [ Html.Attributes.classList [ ( "container", True ) ] ]
        [ Html.text "Hello!" ]
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Html.Attributes.classList`"
                            , details = [ "Use the `CSS.Attributes.classList` instead." ]
                            , under = "Html.Attributes.classList [ ( \"container\", True ) ]"
                            }
                        ]
        , test "should report an error when Html.Attributes.classList is aliased" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Html.Attributes as Attributes

main : Html msg
main =
    Html.div [ Attributes.classList [ ( "container", True ) ] ]
        [ Html.text "Hello!" ]
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Html.Attributes.classList`"
                            , details = [ "Use the `CSS.Attributes.classList` instead." ]
                            , under = "Attributes.classList [ ( \"container\", True ) ]"
                            }
                        ]
        , test "should report an error when Html.Attributes.classList is exposed" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (classList)

main : Html msg
main =
    Html.div [ classList [ ( "container", True ) ] ]
        [ Html.text "Hello!" ]
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Html.Attributes.classList`"
                            , details = [ "Use the `CSS.Attributes.classList` instead." ]
                            , under = "classList [ ( \"container\", True ) ]"
                            }
                        ]
        , test "should report an error when Html.Attributes.classList is aliased and exposed (using alias)" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Html.Attributes as Attributes exposing (classList)

main : Html msg
main =
    Html.div [ Attributes.classList [ ( "container", True ) ] ]
        [ Html.text "Hello!" ]
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Html.Attributes.classList`"
                            , details = [ "Use the `CSS.Attributes.classList` instead." ]
                            , under = "Attributes.classList [ ( \"container\", True ) ]"
                            }
                        ]
        , test "should report an error when Html.Attributes.classList is aliased and exposed (using exposed)" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Html.Attributes as Attributes exposing (classList)

main : Html msg
main =
    Html.div [ classList [ ( "container", True ) ] ]
        [ Html.text "Hello!" ]
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Html.Attributes.classList`"
                            , details = [ "Use the `CSS.Attributes.classList` instead." ]
                            , under = "classList [ ( \"container\", True ) ]"
                            }
                        ]
        ]


svgAttributesClass : Test
svgAttributesClass =
    describe "Svg.Attributes.class"
        [ test "should report an error when Svg.Attributes.class is used" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Svg
import Svg.Attributes

main : Html msg
main =
    Svg.svg [ Svg.Attributes.class "container" ] []
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Svg.Attributes.class`"
                            , details = [ "Use the `CSS.Attributes.svgClass` instead." ]
                            , under = "Svg.Attributes.class \"container\""
                            }
                        ]
        , test "should report an error when Svg.Attributes.class is aliased" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Svg
import Svg.Attributes as Attributes

main : Html msg
main =
    Svg.svg [ Attributes.class "container" ] []
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Svg.Attributes.class`"
                            , details = [ "Use the `CSS.Attributes.svgClass` instead." ]
                            , under = "Attributes.class \"container\""
                            }
                        ]
        , test "should report an error when Svg.Attributes.class is exposed" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Svg
import Svg.Attributes exposing (class)

main : Html msg
main =
    Svg.svg [ class "container" ] []
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Svg.Attributes.class`"
                            , details = [ "Use the `CSS.Attributes.svgClass` instead." ]
                            , under = "class \"container\""
                            }
                        ]
        , test "should report an error when Svg.Attributes.class is aliased and exposed (using alias)" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Svg
import Svg.Attributes as Attributes exposing (class)

main : Html msg
main =
    Svg.svg [ Attributes.class "container" ] []
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Svg.Attributes.class`"
                            , details = [ "Use the `CSS.Attributes.svgClass` instead." ]
                            , under = "Attributes.class \"container\""
                            }
                        ]
        , test "should report an error when Svg.Attributes.class is aliased and exposed (using exposed)" <|
            \() ->
                """module Main exposing (..)

import Html exposing (Html)
import Svg
import Svg.Attributes as Attributes exposing (class)

main : Html msg
main =
    Svg.svg [ class "container" ] []
"""
                    |> Review.Test.run rule
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Do not use `Svg.Attributes.class`"
                            , details = [ "Use the `CSS.Attributes.svgClass` instead." ]
                            , under = "class \"container\""
                            }
                        ]
        ]
