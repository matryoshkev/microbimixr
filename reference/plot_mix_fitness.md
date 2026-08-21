# Draw plots to compare fitness measures

`plot_mix_fitness()` shows a diagnostic overview of various fitness
effects in a dataset. Draws a combined plot of strain, total group, and
relative within-group fitness against two measures of mix frequency.

## Usage

``` r
plot_mix_fitness(
  data,
  var_names = NULL,
  color = c(NULL, NULL, NULL),
  fill = c(NULL, NULL, NULL),
  shape = NULL,
  size = NULL,
  drop_NA = TRUE
)
```

## Arguments

- data:

  Data frame of fitness values. Wide format: each row must contain data
  for two microbes in the same population. Accepts data frame extensions
  like `tibble`.

- var_names:

  Named character vector identifying fitness and mixing variables in
  `data`. If `NULL`, defaults to column names returned by
  [`calculate_mix_fitness()`](https://matryoshkev.github.io/microbimixr/reference/calculate_mix_fitness.md).
  See Details.

- color:

  Point colors `c(strain_A, strain_B, total_group)`

- fill:

  Point fill colors `c(strain_A, strain_B, total_group)`. Only affects
  shapes 21–25.

- shape:

  Point shape

- size:

  Point size in mm

- drop_NA:

  `TRUE` to silently remove missing values. `FALSE` to warn when
  removing missing values.

## Value

A ggplot object

## Details

Expects Wrightian fitness measures like those returned by
[`calculate_mix_fitness()`](https://matryoshkev.github.io/microbimixr/reference/calculate_mix_fitness.md).

`var_names` must be a named vector or list that includes the following
elements (shown here with default values):

    var_names = c(
      name_A = "name_A",
      name_B = "name_B",
      initial_fraction_A = "initial_fraction_A",
      initial_ratio_A_B = "initial_ratio_A_B",
      fitness_A = "fitness_A",
      fitness_B = "fitness_B",
      fitness_total = "fitness_total",
      fitness_ratio_A_B = "fitness_ratio_A_B"
    )

## See also

[`calculate_mix_fitness()`](https://matryoshkev.github.io/microbimixr/reference/calculate_mix_fitness.md)

## Examples

``` r
fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
plot_mix_fitness(fitness_myxo)


# Some plot options
plot_mix_fitness(
  fitness_myxo,
  color = c("black", "grey40", "grey40"),
  fill = c("grey50", "white", "grey75"),
  shape = 23
)

```
