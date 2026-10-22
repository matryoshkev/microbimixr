# Plot fitness of total group or subpopulation

`plot_total_fitness()` draws a plot of total-group fitness as a function
of initial strain frequency

## Usage

``` r
plot_total_fitness(
  data,
  mix_scale = "fraction",
  xlab = NA,
  ylab = NA,
  xlim = c(NA, NA),
  ylim = c(NA, NA),
  color = NULL,
  fill = NULL,
  shape = NULL,
  size = NULL,
  drop_NA = TRUE
)
```

## Arguments

- data:

  Data frame of fitness values and mix frequencies. See details. Accepts
  data frame extensions like `tibble`.

- mix_scale:

  Mixing scale for x axis. Default `"fraction"` uses initial frequency
  of strain A (proportion of total) from `initial_fraction_A` variable
  of data. `"ratio"` uses ratio of strain A to strain B (on
  \\\log\_{10}\\ scale) from `initial_ratio_A_B`.

- xlab, ylab:

  X and y axis labels

- xlim, ylim:

  X and y axis limits

- color:

  Point color

- fill:

  Point fill color. Only affects shapes 21-25.

- shape:

  Point shape

- size:

  Point size in mm

- drop_NA:

  `TRUE` to silently remove missing values. `FALSE` to warn when
  removing missing values.

## Value

A ggplot object that can be further modified using the ggplot2 package

## Details

Expects data frame of Wrightian fitness values like those returned by
[`calculate_mix_fitness()`](https://matryoshkev.github.io/microbimixr/reference/calculate_mix_fitness.md),
with columns `name_A`, `name_B`, `initial_fraction_A`,
`initial_ratio_A_B`, and `fitness_total`. Does not try to plot
single-strain data if `mix_scale = "ratio"`.

## See also

[`plot_fitness_ratio()`](https://matryoshkev.github.io/microbimixr/reference/plot_fitness_ratio.md),
[`plot_strain_fitness()`](https://matryoshkev.github.io/microbimixr/reference/plot_strain_fitness.md)

## Examples

``` r
fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
plot_total_fitness(fitness_myxo)


# Using ratio scale for mix frequencies
plot_total_fitness(fitness_myxo, mix_scale = "ratio")


# Other plot options
plot_total_fitness(
  fitness_myxo,
  ylim = c(1e-8, 1),
  xlab = "Initial frequency of evolved strain",
  ylab = "Sporulation efficiency\n(spores / cell)",
  color = "darkblue",
  fill = "lightblue",
  shape = 23,
  size = 2
)

```
