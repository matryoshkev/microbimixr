# Social exploitation of antibiotic resistance by *E. coli*

This data describes the growth of bacterial populations over a single
cycle in a variety of environments (different ampicillin concentrations)
from a variety of initial starting conditions (changing both the total
initial cell density and the relative abundance of resistant and
sensitive bacteria).

## Usage

``` r
data_Yurtsev_2013
```

## Format

`data_Yurtsev_2013` is a data frame with 2304 rows and 8 columns:

- ampicillin:

  Antibiotic concentration in micrograms per mL

- dilution:

  The amount by which the culture was diluted

- culture_id:

  Provided for convenience, but **not unique**, use ampicillin
  concentrations and replicate to identify cultures uniquely

- replicate:

  Integer to indicate from which experiment the data came from

- OD_initial:

  Initial population density (measured in units of optical density),
  population density at beginning of growth cycle measurement corrected
  for non-linear effects and background

- OD_final:

  Final population density (measured in units of optical density),
  population density at end of growth cycle measurement corrected for
  non-linear effects and background

- fraction_resistant_initial:

  Initial fraction of resistant cells (measured using flow cytometry),
  fraction of resistant cells at the beginning of the growth cycle

- fraction_resistant_final:

  Final fraction of resistant cells (measured using flow cytometry),
  fraction of resistant cells at end of growth cycle

## Source

<https://bitbucket.org/eugene_yurtsev/bacterialcheatingproject>

## References

Yurtsev EA, Chao HX, Datta MS, Artemova T, and Gore J (2013) Bacterial
cheating drives the population dynamics of cooperative antibiotic
resistance plasmids. Molecular Systems Biology 9:683.
<https://doi.org/10.1038/msb.2013.39>
