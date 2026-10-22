# Plot within-group ratio of strain fitnesses

`plot_fitness_ratio()` draws a plot of the relative within-group fitness
of strains A and B as a function of their initial frequency

## Usage

``` r
plot_fitness_ratio(
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
`initial_ratio_A_B`, and `fitness_ratio_A_B`. Relative within-group
fitness is measured as the ratio of strain A fitness to strain B
fitness. Does not try to plot single-strain data.

## See also

[`plot_total_fitness()`](https://matryoshkev.github.io/microbimixr/reference/plot_total_fitness.md),
[`plot_strain_fitness()`](https://matryoshkev.github.io/microbimixr/reference/plot_strain_fitness.md)

## Examples

``` r
fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
plot_fitness_ratio(fitness_myxo)


# Using ratio scale for mix frequencies
plot_fitness_ratio(fitness_myxo, mix_scale = "ratio")


# More plot options
plot_fitness_ratio(
  fitness_myxo,
  mix_scale = "ratio",
  ylim = c(0.01, 100),
  xlab = "Initial ratio evolved / ancestral",
  ylab = "Relative sporulation success\nevolved / ancestral",
  color = "darkblue",
  fill = "lightblue",
  shape = 23,
  size = 2
)

```
