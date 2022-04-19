module ZenCss.NoHtmlClasses exposing (rule)

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
    { html : HtmlContext
    , svg : SvgContext
    }


type HtmlContext
    = HtmlNoImport
    | HtmlImport Aliasing ExposedClass ExposedClassList


type SvgContext
    = SvgNoImport
    | SvgImport Aliasing ExposedClass


type alias Aliasing =
    Maybe ModuleName


type ExposedClass
    = ExposedClass
    | NonExposedClass


type ExposedClassList
    = ExposedClassList
    | NonExposedClassList


{-| Reports the use of `Html.Attributes.class`, `Html.Attributes.classList` and
`Svg.Attributes.class`.

    config =
        [ ZenCss.NoHtmlClasses.rule
        ]


## Fail

    import Html exposing (Html)
    import Html.Attributes as Attributes

    main : Html msg
    main =
        Html.div [ Attributes.class "container" ]
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
This rule is not useful when references to CSS classes are still required.


## Try it out

You can try this rule out by running the following command:

```bash
elm-review --template decioferreira/elm-review-zen-css/example --rules ZenCss.NoHtmlClasses
```

-}
rule : Rule
rule =
    Rule.newModuleRuleSchema "ZenCss.NoHtmlClasses"
        { html = HtmlNoImport
        , svg = SvgNoImport
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

                exposedClassBool : Bool
                exposedClassBool =
                    Node.value node
                        |> .exposingList
                        |> Maybe.map (Node.value >> Exposing.exposesFunction "class")
                        |> Maybe.withDefault False

                exposedClass : ExposedClass
                exposedClass =
                    if exposedClassBool then
                        ExposedClass

                    else
                        NonExposedClass

                exposedClassListBool : Bool
                exposedClassListBool =
                    Node.value node
                        |> .exposingList
                        |> Maybe.map (Node.value >> Exposing.exposesFunction "classList")
                        |> Maybe.withDefault False

                exposedClassList : ExposedClassList
                exposedClassList =
                    if exposedClassListBool then
                        ExposedClassList

                    else
                        NonExposedClassList
            in
            ( [], { context | html = HtmlImport aliasing exposedClass exposedClassList } )

        [ "Svg", "Attributes" ] ->
            let
                aliasing : Aliasing
                aliasing =
                    Node.value node
                        |> .moduleAlias
                        |> Maybe.map Node.value

                exposedClassBool : Bool
                exposedClassBool =
                    Node.value node
                        |> .exposingList
                        |> Maybe.map (Node.value >> Exposing.exposesFunction "class")
                        |> Maybe.withDefault False

                exposedClass : ExposedClass
                exposedClass =
                    if exposedClassBool then
                        ExposedClass

                    else
                        NonExposedClass
            in
            ( [], { context | svg = SvgImport aliasing exposedClass } )

        _ ->
            ( [], context )


expressionVisitor : Node Expression -> Context -> ( List (Error {}), Context )
expressionVisitor (Node range expression) context =
    case ( context.html, context.svg, expression ) of
        ( HtmlImport _ ExposedClass _, _, Expression.Application [ Node _ (Expression.FunctionOrValue [] "class"), _ ] ) ->
            -- then this "class" is `Html.Attributes.class`
            ( [ Rule.error errorHtmlClass range ], context )

        ( HtmlImport aliasing _ _, _, Expression.Application [ Node _ (Expression.FunctionOrValue moduleName "class"), _ ] ) ->
            if moduleName == Maybe.withDefault [ "Html", "Attributes" ] aliasing then
                ( [ Rule.error errorHtmlClass range ], context )

            else
                ( [], context )

        ( HtmlImport _ _ ExposedClassList, _, Expression.Application [ Node _ (Expression.FunctionOrValue [] "classList"), _ ] ) ->
            -- then this "classList" is `Html.Attributes.classList`
            ( [ Rule.error errorHtmlClassList range ], context )

        ( HtmlImport aliasing _ _, _, Expression.Application [ Node _ (Expression.FunctionOrValue moduleName "classList"), _ ] ) ->
            if moduleName == Maybe.withDefault [ "Html", "Attributes" ] aliasing then
                ( [ Rule.error errorHtmlClassList range ], context )

            else
                ( [], context )

        ( _, SvgImport _ ExposedClass, Expression.Application [ Node _ (Expression.FunctionOrValue [] "class"), _ ] ) ->
            -- then this "class" is `Svg.Attributes.class`
            ( [ Rule.error errorSvgClass range ], context )

        ( _, SvgImport aliasing _, Expression.Application [ Node _ (Expression.FunctionOrValue moduleName "class"), _ ] ) ->
            if moduleName == Maybe.withDefault [ "Svg", "Attributes" ] aliasing then
                ( [ Rule.error errorSvgClass range ], context )

            else
                ( [], context )

        _ ->
            ( [], context )


errorHtmlClass : { message : String, details : List String }
errorHtmlClass =
    { message = "Do not use `Html.Attributes.class`"
    , details = [ "Use the `CSS.Attributes.class` instead." ]
    }


errorHtmlClassList : { message : String, details : List String }
errorHtmlClassList =
    { message = "Do not use `Html.Attributes.classList`"
    , details = [ "Use the `CSS.Attributes.classList` instead." ]
    }


errorSvgClass : { message : String, details : List String }
errorSvgClass =
    { message = "Do not use `Svg.Attributes.class`"
    , details = [ "Use the `CSS.Attributes.svgClass` instead." ]
    }
