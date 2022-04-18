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


type Context
    = NoImport
    | Import { aliasing : Maybe ModuleName, exposed : Bool }


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
    Rule.newModuleRuleSchema "ZenCss.NoHtmlClasses" NoImport
        |> Rule.withImportVisitor importVisitor
        |> Rule.withExpressionEnterVisitor expressionVisitor
        |> Rule.fromModuleRuleSchema


importVisitor : Node Import -> Context -> ( List (Error {}), Context )
importVisitor node context =
    case Node.value node |> .moduleName |> Node.value of
        [ "Html", "Attributes" ] ->
            ( []
            , Import
                { aliasing =
                    Node.value node
                        |> .moduleAlias
                        |> Maybe.map Node.value
                , exposed =
                    Node.value node
                        |> .exposingList
                        |> Maybe.map (Node.value >> Exposing.exposesFunction "class")
                        |> Maybe.withDefault False
                }
            )

        _ ->
            ( [], context )


expressionVisitor : Node Expression -> Context -> ( List (Error {}), Context )
expressionVisitor (Node range expression) context =
    case ( context, expression ) of
        ( Import { exposed }, Expression.Application [ Node _ (Expression.FunctionOrValue [] "class"), _ ] ) ->
            if exposed then
                -- then this "class" is `Html.Attributes.class`
                ( [ Rule.error error range ], context )

            else
                ( [], context )

        ( Import { aliasing }, Expression.Application [ Node _ (Expression.FunctionOrValue moduleName "class"), _ ] ) ->
            if moduleName == Maybe.withDefault [ "Html", "Attributes" ] aliasing then
                ( [ Rule.error error range ], context )

            else
                ( [], context )

        _ ->
            ( [], context )


error : { message : String, details : List String }
error =
    { message = "Do not use `Html.Attributes.class`"
    , details = [ "Use the `CSS.Attributes.class` instead." ]
    }
