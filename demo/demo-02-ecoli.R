# Mix experiments under different conditions ===================================
#
# Two E. coli genotypes growing in same liquid culture:
# - One is resistant to the antibiotic ampicillin
#   because it has a beta-lactamase on a non-conjugative plasmid
# - One is sensitive to ampicillin
#
# Experimental treatments:
# - Initial strain frequency
# - Ampicillin concentration
# - Culture dilution (changes initial cell density before growth)

# Dependencies
library(dplyr)    # Data handling that makes code more readable
library(ggplot2)  # Graphics package


# Calculate and compare fitness measures ---------------------------------------

# Data included in microbimixr
head(data_Yurtsev_2013)

# Calculate fitness measures
fitness_ecoli <-
	data_Yurtsev_2013 |>
	dplyr::tibble() |>
	calculate_mix_fitness(
		var_names = c(
			initial_number_total = "OD_initial",
			initial_fraction_A = "fraction_resistant_initial",
			final_number_total = "OD_final",
			final_fraction_A = "fraction_resistant_final",
			name_A = "resistant",
			name_B = "sensitive"
		),
		keep = c("ampicillin", "dilution", "replicate", "culture_id")
	)
# Warning messages from calculate_mix_fitness()

fitness_ecoli
# Some strain frequencies are < 0, probably from correcting for background
# noise in flow cytometry

# A lot of data, so first let's just look at one treatment combination
fitness_ecoli |>
	dplyr::filter(ampicillin == 100 & dilution == 100) |>
	plot_mix_fitness()
# Negative frequency-dependent selection

# Looks like strain frequency doesn't affect total culture growth at all
dev.new(width = 6.3, height = 6, units = "in")
fitness_ecoli |>
	dplyr::filter(ampicillin %in% c(0, 50, 100, 200)) |>
	plot_total_fitness() +
	ggplot2::facet_grid(ampicillin ~ dilution)
# Or ampicillin. Just culture dilution.

# So fitness ratio captures all the interesting effects,
# and they're more linear vs initial strain frequency


# Plot fitness ratio -----------------------------------------------------------

# Make base plot with subset of data
dev.new(width = 6.25, height = 2.25, units = "in")
fig_ecoli <-
	fitness_ecoli |>
	dplyr::filter(
		ampicillin %in% c(0, 15, 50, 100) & dilution %in% c(200, 400, 800)
	) |>
	plot_fitness_ratio()

# Add panels and color scales for experimental conditions
name_amp <- "Ampicillin\n(\u03BCg/mL)"
fig_ecoli <- fig_ecoli +
	# Panels for culture dilution
	ggplot2::facet_wrap(
		~ dilution,
		labeller = ggplot2::as_labeller(function(x) paste0(x, "-fold dilution"))
	) +
	# Color/fill scale for ampicillin
	ggplot2::aes(color = factor(ampicillin), fill = factor(ampicillin)) +
	ggplot2::scale_fill_viridis_d(
		name = name_amp, option = "magma", direction = -1, begin = 0.5, end = 1
	) +
	ggplot2::scale_color_viridis_d(
		name = name_amp, option = "magma", direction = -1, begin = 0, end = 0.8
	)

fig_ecoli
# Shows that ampicillin & culture dilution have similar effects on fitness

# TODO: Make these errors more informative


