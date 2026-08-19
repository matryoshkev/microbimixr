# Y-axis for fitness of groups or subpopulations

`scale_y_fitness_total()` is a y-axis scale for the total fitness of
microbial groups or subpopulations. It calls
[`ggplot2::scale_y_log10()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html)
with default settings suited to Wrightian fitness data.

## Usage

``` r
scale_y_fitness_total(
  name = waiver(),
  limits = NULL,
  breaks = waiver(),
  labels = waiver(),
  minor_breaks = waiver(),
  ...
)
```

## Arguments

- name:

  Character vector (or expression) for axis title. Or
  [`waiver()`](https://ggplot2.tidyverse.org/reference/waiver.html) to
  automatically name axis.

- limits:

  Numeric vector of length two giving axis limits. Or `NULL` for
  automatic limits that include 1 for reference (no change in abundance)
  and span a minimum 10-fold range.

- breaks:

  Numeric vector of positions for axis breaks. Or
  [`waiver()`](https://ggplot2.tidyverse.org/reference/waiver.html) for
  automatic breaks. Or `NULL` for no breaks.

- labels:

  One of:

  - Character vector giving labels for breaks (must be same length as
    `breaks`)

  - [`waiver()`](https://ggplot2.tidyverse.org/reference/waiver.html)
    for automatic labels that use a simple number format when all breaks
    are between 0.01 and 100. For wider limits they use \\10^x\\ format
    except for \\1\\.

  - Expression vector (must be the same length as `breaks`). See
    ?plotmath for details.

  - `NULL` for no labels

- minor_breaks:

  Numeric vector of positions for axis minor breaks. Or
  [`waiver()`](https://ggplot2.tidyverse.org/reference/waiver.html) for
  automatic minor breaks. Or `NULL` for no breaks.

- ...:

  Other arguments passed to
  [`ggplot2::scale_x_log10()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html)

## Value

Y-axis position scale for use with the ggplot2 package

## Details

`scale_y_fitness_total()` expects data that are absolute (unscaled)
Wrightian fitness, like the values produced by
[`calculate_mix_fitness()`](https://matryoshkev.github.io/microbimixr/reference/calculate_mix_fitness.md).
If the initial abundance of a microbial group is \\n\\ (measured as
cfu/mL for example) and its final abundance is \\n'\\, then the group's
Wrightian fitness measured over that entire time period is \\w = n' /
n\\.

## See also

[`scale_y_fitness()`](https://matryoshkev.github.io/microbimixr/reference/scale_y_fitness.md),
[`scale_y_fitness_ratio()`](https://matryoshkev.github.io/microbimixr/reference/scale_y_fitness_ratio.md)

## Examples

``` r
library("ggplot2")
fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
fig <- fitness_myxo |>
  ggplot(aes(initial_fraction_A, fitness_total)) +
  geom_point_overlap()

fig + scale_y_log10()

fig + scale_y_fitness_total()


# Axis options
fig + scale_y_fitness_total(
  name = "Sporulation efficiency\n(spores/cell)",
  limits = c(1e-8, 1)
)

```
