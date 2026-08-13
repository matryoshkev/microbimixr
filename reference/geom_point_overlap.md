# Points with improved overlap readability

`geom_point_overlap()` is a version of `geom_point()` from ggplot2 that
is easier to see when points overlap. It first draws points as normal
then draws points again with no fill. It only has a visible effect on
point shapes 21-25.

## Usage

``` r
geom_point_overlap(...)
```

## Arguments

- ...:

  Arguments passed to
  [`ggplot2::geom_point()`](https://ggplot2.tidyverse.org/reference/geom_point.html)

## Value

A geom layer for use with the ggplot2 package

## Examples

``` r
library(ggplot2)
fig <- ggplot(data = airquality, mapping = aes(x = Temp, y = Ozone))
fig + geom_point(shape = 21, size = 3, fill = "grey65", na.rm = TRUE)

fig + geom_point_overlap(size = 3, na.rm = TRUE)

```
