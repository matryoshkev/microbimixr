# Variable mapping for *Myxococcus* data

Describes how the variables in
[`data_smith_2010`](https://matryoshkev.github.io/microbimixr/reference/data_smith_2010.md)
map to microbial abundance measures used by
[`calculate_mix_fitness()`](https://matryoshkev.github.io/microbimixr/reference/calculate_mix_fitness.md).

## Usage

``` r
var_names_smith_2010
```

## Format

`var_names_smith_2010` is a character vector with 6 elements:

    c(
      initial_number_A = "initial_cells_evolved",
      initial_number_B = "initial_cells_ancestral",
      final_number_A = "final_spores_evolved",
      final_number_B = "final_spores_ancestral",
      name_A = "GVB206.3",
      name_B = "GJV10
    )
