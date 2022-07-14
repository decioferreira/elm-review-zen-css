module ZenCss.NoHtmlStyles exposing (rule)

{-|

@docs rule

-}

import Elm.Syntax.Expression as Expression exposing (Expression)
import Elm.Syntax.Node as Node exposing (Node)
import Review.ModuleNameLookupTable as ModuleNameLookupTable exposing (ModuleNameLookupTable)
import Review.Rule as Rule exposing (Error, Rule)


type alias Context =
    { lookupTable : ModuleNameLookupTable
    }


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
    Rule.newModuleRuleSchemaUsingContextCreator "ZenCss.NoHtmlStyles" initialContext
        |> Rule.withExpressionEnterVisitor expressionVisitor
        |> Rule.fromModuleRuleSchema


initialContext : Rule.ContextCreator () Context
initialContext =
    Rule.initContextCreator (\lookupTable () -> { lookupTable = lookupTable })
        |> Rule.withModuleNameLookupTable


expressionVisitor : Node Expression -> Context -> ( List (Error {}), Context )
expressionVisitor node context =
    case Node.value node of
        Expression.FunctionOrValue _ "style" ->
            if ModuleNameLookupTable.moduleNameFor context.lookupTable node == Just [ "Html", "Attributes" ] then
                ( [ Rule.error
                        { message = "Do not use `Html.Attributes.style`"
                        , details = [ "Use the `CSS.Attributes.class` instead." ]
                        }
                        (Node.range node)
                  ]
                , context
                )

            else if ModuleNameLookupTable.moduleNameFor context.lookupTable node == Just [ "Svg", "Attributes" ] then
                ( [ Rule.error
                        { message = "Do not use `Svg.Attributes.style`"
                        , details = [ "Use the `CSS.Attributes.svgClass` instead." ]
                        }
                        (Node.range node)
                  ]
                , context
                )

            else
                ( [], context )

        _ ->
            ( [], context )
