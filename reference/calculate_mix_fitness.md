# Calculate fitness measures

Calculate several measures of microbial fitness from a data frame of the
initial and final abundances of two microbes.

## Usage

``` r
calculate_mix_fitness(data, var_names, keep = NULL)
```

## Arguments

- data:

  Data frame of initial and final abundance values. Each row must
  contain data for two microbes in the same population. Accepts data
  frame extensions like `tibble`. See Details.

- var_names:

  Named character vector of columns in `data` that describe initial and
  final abundances. See Details.

- keep:

  Optional character vector of columns in `data` to keep in output (e.g.
  treatment variables, experimental block)

## Value

A data frame of same type as `data` with the following columns:

- `name_A`:

  Name of strain A

- `name_B`:

  Name of strain B

- ...:

  Other columns specified by `keep`

- `initial_fraction_A`:

  Initial frequency of strain A. Fraction of all cells or virions.

- `initial_ratio_A_B`:

  Initial ratio of strain A to strain B frequencies

- `fitness_A`:

  Fitness of strain A

- `fitness_B`:

  Fitness of strain B

- `fitness_total`:

  Total-group fitness. Sum of both strains.

- `fitness_ratio_A_B`:

  Within-group relative fitness measured as `fitness_A` / `fitness_B`

All `fitness` values are unscaled Wrightian fitness measured over the
entire time period between the initial and final abundances. If \\n_i\\
and \\n'\_i\\ are the initial and final abundances of microbe \\i\\,
then its Wrightian fitness is \$\$w_i = n'\_i / n_i\$\$ If the absolute
abundance of a microbe increases 100-fold, its fitness will be \\w =
100\\. If it decreases to 10% of its initial abundance, its fitness will
be \\w = 0.1\\. These fitness measures are robust across microbial
species and types of interaction, make fitness effects quantitatively
comparable across systems, and can be meaningfully incorporated into
theoretical models of microbial social evolution. They are best
visualized and analyzed over \\\log\_{10}\\ scales.

## Details

`var_names` must identify variables in `data` that are sufficient to
identify initial and final abundance of both strains. For initial
abundance, this must be two of:

- `initial_number_A`

- `initial_number_B`

- `initial_number_total`

- `initial_fraction_A`

- `initial_fraction_B`

For final abundance, this must be two of:

- `final_number_A`

- `final_number_B`

- `final_number_total`

- `final_fraction_A`

- `final_fraction_B`

Values of `number` vars in `data` can be counts or densities, but
`initial` and `final` must have same units.

`var_names` must also contain `name_A` and `name_B` naming the microbes
in `data.` If these values are column names in `data`, `data` values
will be used in the output frame. Otherwise the output frame will use
the string values as names.

## References

smith j and Inglis RF (2021) Evaluating kin and group selection as tools
for quantitative analysis of microbial data. Proceedings B 288:20201657.
<https://doi.org/10.1098/rspb.2020.1657>

## Examples

``` r
# Data with cell counts for each strain
fitness_smith_2010 <- calculate_mix_fitness(
  data_smith_2010,
  var_names = c(
    initial_number_A = "initial_cells_evolved",
    initial_number_B = "initial_cells_ancestral",
    final_number_A   = "final_spores_evolved",
    final_number_B   = "final_spores_ancestral",
    name_A = "Evolved GVB206.3",
    name_B = "Ancestral GJV10"
  ),
  keep = "exptl_block"
)
head(fitness_smith_2010)
#>             name_A          name_B exptl_block initial_fraction_A
#> 1 Evolved GVB206.3 Ancestral GJV10  2009-04-29         1.00000000
#> 2 Evolved GVB206.3 Ancestral GJV10  2009-04-29         0.98901099
#> 3 Evolved GVB206.3 Ancestral GJV10  2009-04-29         0.90000000
#> 4 Evolved GVB206.3 Ancestral GJV10  2009-04-29         0.50000000
#> 5 Evolved GVB206.3 Ancestral GJV10  2009-04-29         0.10000000
#> 6 Evolved GVB206.3 Ancestral GJV10  2009-04-29         0.01098901
#>   initial_ratio_A_B    fitness_A  fitness_B fitness_total fitness_ratio_A_B
#> 1               Inf 1.200000e-07         NA  1.200000e-07                NA
#> 2       90.00000000 1.555556e-07 0.00000400  1.978022e-07        0.03888889
#> 3        9.00000000 2.600000e-06 0.00000480  2.820000e-06        0.54166667
#> 4        1.00000000 4.280000e-04 0.00156000  9.940000e-04        0.27435897
#> 5        0.11111111 4.200000e-02 0.01400000  1.680000e-02        3.00000000
#> 6        0.01111111 8.420000e-01 0.02288889  3.189011e-02       36.78640777

# Data with total density and strain frequency
fitness_Yurtsev_2013 <- calculate_mix_fitness(
  data_Yurtsev_2013,
  var_names = c(
    initial_number_total = "OD_initial",
    initial_fraction_A = "fraction_resistant_initial",
    final_number_total = "OD_final",
    final_fraction_A = "fraction_resistant_final",
    name_A = "AmpR",
    name_B = "AmpS"
  ),
  keep = c("ampicillin", "dilution", "replicate")
)
#> Warning: Some fraction_resistant_initial values not in range [0, 1]: Not biologically meaningful
#> Warning: Some fraction_resistant_final values not in range [0, 1]: Not biologically meaningful
# Warns of nonbiological values in data: some resistant fractions < 0
# Artifact of subtracting background during flow cytometry?
head(fitness_Yurtsev_2013)
#>   name_A name_B ampicillin dilution replicate initial_fraction_A
#> 1   AmpR   AmpS          0      100         0      -0.0003784523
#> 2   AmpR   AmpS          0      100         0       0.0473674563
#> 3   AmpR   AmpS          0      100         0       0.0831943961
#> 4   AmpR   AmpS          0      100         0       0.1360970434
#> 5   AmpR   AmpS          0      100         0       0.1909207725
#> 6   AmpR   AmpS          0      100         0       0.2346178261
#>   initial_ratio_A_B fitness_A fitness_B fitness_total fitness_ratio_A_B
#> 1     -0.0003783091  51.82082  115.6992     115.72341         0.4478925
#> 2      0.0497226938  55.19903  104.4084     102.07749         0.5286838
#> 3      0.0907437691  67.25088  102.9718     100.00000         0.6531001
#> 4      0.1575374205  72.68639  132.5415     124.39537         0.5484049
#> 5      0.2359729011  67.18882  123.0941     112.42060         0.5458331
#> 6      0.3065368309  54.90398  104.8752      93.15104         0.5235174
```
