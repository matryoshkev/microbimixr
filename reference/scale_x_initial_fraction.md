# X-axis for initial strain frequency

`scale_x_initial_fraction()` is an x-axis position scale for initial
strain frequency (fraction or proportion of total) measured on a linear
scale. It calls
[`ggplot2::scale_x_continuous()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html)
with default settings suited to microbial mix experiments.

## Usage

``` r
scale_x_initial_fraction(
  name = waiver(),
  strain_names = c(name_A = "strain A", name_B = "strain B"),
  limits = c(0, 1),
  breaks = seq(0, 1, by = 0.2),
  minor_breaks = NULL,
  ...
)
```

## Arguments

- name:

  Character string or expression to label axis. Or
  [`waiver()`](https://ggplot2.tidyverse.org/reference/waiver.html) to
  automatically name axis using `strain_names`. Or `NULL` for no title.

- strain_names:

  Character vector or list used to automatically name axis if
  `name = NA`.

- limits:

  Numeric vector of length two giving axis limits. The default `c(0, 1)`
  shows the full range of possible mix frequencies.

- breaks:

  Numeric vector of positions for axis breaks. Or `NULL` for no breaks.

- minor_breaks:

  Numeric vector of positions for axis minor breaks. Or `NULL` for no
  minor breaks.

- ...:

  Other arguments passed to
  [`ggplot2::scale_x_continuous()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html)

## Value

X-axis position scale for use with the ggplot2 package

## See also

[`scale_x_initial_ratio()`](https://matryoshkev.github.io/microbimixr/reference/scale_x_initial_ratio.md)

## Examples

``` r
library("ggplot2")
fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
fig <- fitness_myxo |>
  ggplot(aes(initial_fraction_A, fitness_total)) +
  geom_point_overlap() +
  scale_y_log10()

fig

fig + scale_x_initial_fraction(strain_names = var_names_smith_2010)


# Manually label axis
fig + scale_x_initial_fraction(name = "Initial frequency of evolved strain")

```
