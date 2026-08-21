# Plot fitness of each strain separately

`plot_strain_fitness()` draws a plot of absolute fitness for each of two
microbe strains as a function of their initial frequency

## Usage

``` r
plot_strain_fitness(
  data,
  var_names = NULL,
  mix_scale = "fraction",
  xlab = NA,
  ylab = NA,
  xlim = c(NA, NA),
  ylim = c(NA, NA),
  color = c(NULL, NULL),
  fill = c(NULL, NULL),
  shape = NULL,
  size = NULL,
  drop_NA = TRUE
)
```

## Arguments

- data:

  Data frame of fitness values and mix frequencies. Wide format: each
  row must contain data for two microbes in the same population. Accepts
  data frame extensions like `tibble`.

- var_names:

  Named character vector identifying fitness and mixing variables in
  `data`. If `NULL`, defaults to column names returned by
  [`calculate_mix_fitness()`](https://matryoshkev.github.io/microbimixr/reference/calculate_mix_fitness.md).
  See Details.

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

  Point colors

- fill:

  Point fill colors. Only affects shapes 21–25.

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

`var_names` must be a named vector or list that includes the following
elements (shown here with default values):

    var_names = c(
      name_A = "name_A",
      name_B = "name_B",
      initial_fraction_A = "initial_fraction_A",
      initial_ratio_A_B = "initial_ratio_A_B",
      fitness_A = "fitness_A",
      fitness_B = "fitness_B"
    )

Expects Wrightian fitness data like those returned by
[`calculate_mix_fitness()`](https://matryoshkev.github.io/microbimixr/reference/calculate_mix_fitness.md).
Does not try to plot single-strain data if `mix_scale = "ratio"`.

## See also

[`plot_total_group_fitness()`](https://matryoshkev.github.io/microbimixr/reference/plot_total_group_fitness.md),
[`plot_within_group_fitness()`](https://matryoshkev.github.io/microbimixr/reference/plot_within_group_fitness.md)

## Examples

``` r
fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
plot_strain_fitness(fitness_myxo)


# Some plot options
plot_strain_fitness(
  fitness_myxo,
  xlab = "Initial frequency of GVB206.3",
  ylab = "Sporulation efficiency\n(spores/cell)",
  color = c("black", "grey40"),
  fill = c("grey50", "white"),
  shape = 23,
  size = 2
)

```
