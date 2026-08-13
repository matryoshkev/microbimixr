# X-axis for initial strain ratio

`scale_x_initial_ratio()` is an x-axis scale for the initial ratio of
strain frequencies. It calls
[`ggplot2::scale_x_log10()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html)
with default settings suited to microbial mix experiments.

## Usage

``` r
scale_x_initial_ratio(
  name = NA,
  strain_names = c(name_A = "strain A", name_B = "strain B"),
  limits = NULL,
  breaks = NA,
  labels = NA,
  minor_breaks = NULL,
  ...
)
```

## Arguments

- name:

  Character vector (or expression) for axis title. Or `NA` to
  automatically name axis using `strain_names`. Or `NULL` for no title.

- strain_names:

  Character vector or list used to automatically name axis if
  `name = NA`

- limits:

  Numeric vector of length two giving axis limits. Or `NULL` for
  automatic limits that include 1 for reference (equal 50:50 mix of
  strains) and span a minimum 10-fold range.

- breaks:

  Numeric vector of positions for axis breaks. Or `NA` for automatic
  breaks. Or `NULL` for no breaks.

- labels:

  One of:

  - Character vector giving labels for breaks (must be same length as
    `breaks`)

  - `NA` for automatic labels that use a simple number format when all
    breaks are between 0.01 and 100. For wider limits they use \\10^x\\
    format except for \\1\\.

  - Expression vector (must be the same length as `breaks`). See
    ?plotmath for details.

  - `NULL` for no labels

- minor_breaks:

  Numeric vector of positions for axis minor breaks. Or `NULL` for no
  minor breaks.

- ...:

  Other arguments passed to
  [`ggplot2::scale_x_log10()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html)

## Value

X-axis position scale for use with the ggplot2 package

## See also

[`scale_x_initial_fraction()`](https://matryoshkev.github.io/microbimixr/reference/scale_x_initial_fraction.md)

## Examples

``` r
library("ggplot2")
fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
fig <- fitness_myxo |>
  subset(is.finite(fitness_ratio_A_B)) |>
  ggplot(aes(initial_ratio_A_B, fitness_ratio_A_B)) +
  geom_point_overlap() +
  scale_y_log10()
fig


# Automatically label axis
fig + scale_x_initial_ratio(strain_names = var_names_smith_2010)


# Manually label axis
fig + scale_x_initial_ratio(name = "Initial ratio evolved / ancestral")

```
