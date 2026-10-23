# Convert strain fitness data from wide to long format

`lengthen_strain_fitness()` converts wide-format fitness data (where
each row has values for both strains in an experiment) to its equivalent
long format (where each strain has its own row). Useful when fitting
models to strain fitness data. For more details see the strain fitness
vignette:
[`vignette("strain-fitness", package = "microbimixr")`](https://matryoshkev.github.io/microbimixr/articles/strain-fitness.md).

## Usage

``` r
lengthen_strain_fitness(data)
```

## Arguments

- data:

  Data frame with columns `name_A`, `name_B`, `fitness_A`, and
  `fitness_B`.

## Value

Returns a data frame with a new `strain` column containing values from
`name_A` or `name_B` and a new `fitness` column replacing `fitness_A`
and `fitness_B`. `name_A` and `name_B` kept to identify strain pairs.
Other columns kept as-is.

## Examples

``` r
# Make example data
strain_fitness <- data.frame(
  initial_fraction_A = c(0, 0.5, 1),
  fitness_A = c(NA, 150, 100),
  fitness_B = c(100, 50, NA)
)
strain_fitness$name_A <- "Evolved"
strain_fitness$name_B <- "Ancestral"
strain_fitness$exptl_block <- "A"

# Show wide and long formats
strain_fitness
#>   initial_fraction_A fitness_A fitness_B  name_A    name_B exptl_block
#> 1                0.0        NA       100 Evolved Ancestral           A
#> 2                0.5       150        50 Evolved Ancestral           A
#> 3                1.0       100        NA Evolved Ancestral           A
lengthen_strain_fitness(strain_fitness)
#>   initial_fraction_A  name_A    name_B exptl_block    strain fitness
#> 1                0.0 Evolved Ancestral           A   Evolved      NA
#> 2                0.5 Evolved Ancestral           A   Evolved     150
#> 3                1.0 Evolved Ancestral           A   Evolved     100
#> 4                0.0 Evolved Ancestral           A Ancestral     100
#> 5                0.5 Evolved Ancestral           A Ancestral      50
#> 6                1.0 Evolved Ancestral           A Ancestral      NA
```
