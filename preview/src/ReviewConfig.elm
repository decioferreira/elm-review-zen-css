module ReviewConfig exposing (config)

{-| Do not rename the ReviewConfig module or the config function, because
`elm-review` will look for these.

To add packages that contain rules, add them to this review project using

    `elm install author/packagename`

when inside the directory containing this file.

-}

import Review.Rule exposing (Rule)
import ZenCss.NoHtmlClasses


config : List Rule
config =
    [ ZenCss.NoHtmlClasses.rule
    ]
