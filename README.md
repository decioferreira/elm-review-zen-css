# elm-review-zen-css

Provides [`elm-review`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/) rules to support the use of [`elm-zen-css`](https://package.elm-lang.org/packages/decioferreira/elm-zen-css/latest/).


## Provided rules

- [`ZenCss.NoHtmlClasses`](https://package.elm-lang.org/packages/decioferreira/elm-review-zen-css/1.0.0/ZenCss-NoHtmlClasses) - Reports the use of `Html.Attributes.class`, `Html.Attributes.classList` and `Svg.Attributes.class`.


## Configuration

```elm
module ReviewConfig exposing (config)

import ZenCss.NoHtmlClasses
import Review.Rule exposing (Rule)

config : List Rule
config =
    [ ZenCss.NoHtmlClasses.rule
    ]
```


## Try it out

You can try the example configuration above out by running the following command:

```bash
elm-review --template decioferreira/elm-review-zen-css/example
```
