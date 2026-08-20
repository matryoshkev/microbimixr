# Plot within-group ratio of strain fitnesses

`plot_within_group_fitness()` draws a plot of the relative within-group
fitness of strains A and B as a function of their initial frequency

## Usage

``` r
plot_within_group_fitness(
  data,
  var_names = NULL,
  mix_scale = "fraction",
  xlab = NA,
  ylab = NA,
  xlim = c(NA, NA),
  ylim = c(NA, NA),
  color = "black",
  fill = "grey65",
  shape = 21,
  size = 1.5
)
```

## Arguments

- data:

  Data frame of fitness values and mix frequencies. Accepts data frame
  extensions like `tibble`.

- var_names:

  Named character vector identifying fitness and mixing variables in
  `data`. If `NULL`, defaults to column names returned by
  [`calculate_mix_fitness()`](https://matryoshkev.github.io/microbimixr/reference/calculate_mix_fitness.md).
  See Details.

- mix_scale:

  Determines mixing scale for x axis. When `"fraction"` (the default),
  uses initial frequency of strain A (proportion of total) from
  `initial_fraction_A` variable. When `"ratio"`, uses ratio of strain A
  to strain B (on \\\log\_{10}\\ scale) from `initial_ratio_A_B`
  variable.

- xlab, ylab:

  Optional string to replace default axis label

- xlim, ylim:

  Optional axis limits to replace default

- color:

  Point color

- fill:

  Point fill. Only affects shapes 21-25.

- shape:

  Point shape

- size:

  Point size in millimeters

## Value

A ggplot object that can be further modified using the ggplot2 package

## Details

Expects Wrightian fitness data like those returned by
[`calculate_mix_fitness()`](https://matryoshkev.github.io/microbimixr/reference/calculate_mix_fitness.md).
Relative within-group fitness is measured as the ratio of strain A
fitness to strain B fitness.

`var_names` must be a named vector or list that includes the following
elements (shown here with default values):

    var_names = c(
      name_A = "name_A",
      name_B = "name_B",
      initial_fraction_A = "initial_fraction_A",
      initial_ratio_A_B = "initial_ratio_A_B",
      fitness_ratio_A_B = "fitness_ratio_A_B"
    )

## See also

[`plot_total_group_fitness()`](https://matryoshkev.github.io/microbimixr/reference/plot_total_group_fitness.md),
[`plot_strain_fitness()`](https://matryoshkev.github.io/microbimixr/reference/plot_strain_fitness.md)

## Examples

``` r
fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
plot_within_group_fitness(fitness_myxo)


# Using ratio scale for mix frequencies
plot_within_group_fitness(fitness_myxo, mix_scale = "ratio")


# More plot options
plot_within_group_fitness(
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
