# elm-review-zen-css

Provides [`elm-review`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/) rules to REPLACEME.


## Provided rules

- [`ZenCss.NoHtmlClasses`](https://package.elm-lang.org/packages/decioferreira/elm-review-zen-css/1.0.0/ZenCss-NoHtmlClasses) - Reports REPLACEME.


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
