# Draw plots to compare fitness measures

`plot_mix_fitness()` shows a diagnostic overview of various fitness
effects in a dataset. Draws a combined plot of strain, total group, and
relative within-group fitness against two measures of mix frequency.

## Usage

``` r
plot_mix_fitness(data, var_names = NULL)
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
library(patchwork)

# Using data from smith et al (2010)
fitness_smith_2010 <- calculate_mix_fitness(
  data_smith_2010,
  var_names = c(
    initial_number_A = "initial_cells_evolved",
    initial_number_B = "initial_cells_ancestral",
    final_number_A = "final_spores_evolved",
    final_number_B = "final_spores_ancestral",
    name_A = "GVB206.3",
    name_B = "GJV10"
  )
)
plot_mix_fitness(fitness_smith_2010)

```
