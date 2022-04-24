module ZenCss.NoHtmlStyles exposing (rule)

{-|

@docs rule

-}

import Elm.Syntax.Exposing as Exposing
import Elm.Syntax.Expression as Expression exposing (Expression)
import Elm.Syntax.Import exposing (Import)
import Elm.Syntax.ModuleName exposing (ModuleName)
import Elm.Syntax.Node as Node exposing (Node(..))
import Review.Rule as Rule exposing (Error, Rule)


type alias Context =
    { html : ModuleContext
    , svg : ModuleContext
    }


type ModuleContext
    = NoImport
    | Import Aliasing ExposedStyle


type alias Aliasing =
    Maybe ModuleName


type ExposedStyle
    = ExposedStyle
    | NonExposedStyle


{-| Reports the use of `Html.Attributes.style` and `Svg.Attributes.style`.

    config =
        [ ZenCss.NoHtmlStyles.rule
        ]


## Fail

    import Html exposing (Html)
    import Html.Attributes as Attributes

    main : Html msg
    main =
        Html.div [ Attributes.style "color" "blue" ]
            [ Html.text "Hello!" ]


## Success

    import CSS.Attributes
    import Classes
    import Html exposing (Html)

    main : Html msg
    main =
        Html.div [ CSS.Attributes.class Classes.container ]
            [ Html.text "Hello!" ]


## When (not) to enable this rule

This rule is useful when using the `elm-zen-css` library.
This rule is not useful when inline style attributes are still required.


## Try it out

You can try this rule out by running the following command:

```bash
elm-review --template decioferreira/elm-review-zen-css/example --rules ZenCss.NoHtmlStyles
```

-}
rule : Rule
rule =
    Rule.newModuleRuleSchema "ZenCss.NoHtmlStyles"
        { html = NoImport
        , svg = NoImport
        }
        |> Rule.withImportVisitor importVisitor
        |> Rule.withExpressionEnterVisitor expressionVisitor
        |> Rule.fromModuleRuleSchema


importVisitor : Node Import -> Context -> ( List (Error {}), Context )
importVisitor node context =
    case Node.value node |> .moduleName |> Node.value of
        [ "Html", "Attributes" ] ->
            let
                aliasing : Aliasing
                aliasing =
                    Node.value node
                        |> .moduleAlias
                        |> Maybe.map Node.value

                exposedStyleBool : Bool
                exposedStyleBool =
                    Node.value node
                        |> .exposingList
                        |> Maybe.map (Node.value >> Exposing.exposesFunction "style")
                        |> Maybe.withDefault False

                exposedStyle : ExposedStyle
                exposedStyle =
                    if exposedStyleBool then
                        ExposedStyle

                    else
                        NonExposedStyle
            in
            ( [], { context | html = Import aliasing exposedStyle } )

        [ "Svg", "Attributes" ] ->
            let
                aliasing : Aliasing
                aliasing =
                    Node.value node
                        |> .moduleAlias
                        |> Maybe.map Node.value

                exposedStyleBool : Bool
                exposedStyleBool =
                    Node.value node
                        |> .exposingList
                        |> Maybe.map (Node.value >> Exposing.exposesFunction "style")
                        |> Maybe.withDefault False

                exposedStyle : ExposedStyle
                exposedStyle =
                    if exposedStyleBool then
                        ExposedStyle

                    else
                        NonExposedStyle
            in
            ( [], { context | svg = Import aliasing exposedStyle } )

        _ ->
            ( [], context )


expressionVisitor : Node Expression -> Context -> ( List (Error {}), Context )
expressionVisitor (Node range expression) context =
    case ( context.html, context.svg, expression ) of
        ( Import _ ExposedStyle, _, Expression.Application [ Node _ (Expression.FunctionOrValue [] "style"), _, _ ] ) ->
            -- then this "style" is `Html.Attributes.style`
            ( [ Rule.error errorHtmlStyle range ], context )

        ( Import aliasing _, _, Expression.Application [ Node _ (Expression.FunctionOrValue moduleName "style"), _, _ ] ) ->
            if moduleName == Maybe.withDefault [ "Html", "Attributes" ] aliasing then
                ( [ Rule.error errorHtmlStyle range ], context )

            else
                ( [], context )

        ( _, Import _ ExposedStyle, Expression.Application [ Node _ (Expression.FunctionOrValue [] "style"), _, _ ] ) ->
            -- then this "style" is `Svg.Attributes.style`
            ( [ Rule.error errorSvgStyle range ], context )

        ( _, Import aliasing _, Expression.Application [ Node _ (Expression.FunctionOrValue moduleName "style"), _, _ ] ) ->
            if moduleName == Maybe.withDefault [ "Svg", "Attributes" ] aliasing then
                ( [ Rule.error errorSvgStyle range ], context )

            else
                ( [], context )

        _ ->
            ( [], context )


errorHtmlStyle : { message : String, details : List String }
errorHtmlStyle =
    { message = "Do not use `Html.Attributes.style`"
    , details = [ "Use the `CSS.Attributes.class` instead." ]
    }


errorSvgStyle : { message : String, details : List String }
errorSvgStyle =
    { message = "Do not use `Svg.Attributes.style`"
    , details = [ "Use the `CSS.Attributes.svgClass` instead." ]
    }
