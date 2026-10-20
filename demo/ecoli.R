# Using microbimixr with multiple experimental conditions ======================

# Dependencies
library(dplyr)    # Data handling that makes code more readable
library(ggplot2)  # Graphics

# Data included in microbimixr: resistant and sensitive E. coli under different
# antibiotic concentrations and growth regimes
head(data_Yurtsev_2013)

# Drop data with strain frequencies not in [0, 1]
# Possible artifact of correcting for background noise in flow cytometry
data_ecoli <-
	data_Yurtsev_2013 |>
	tibble() |>
	filter(
		fraction_resistant_initial > 0 & fraction_resistant_initial < 1,
		fraction_resistant_final > 0 & fraction_resistant_final < 1
	)


# Calculate and compare fitness measures ---------------------------------------

fitness_ecoli <-
	data_ecoli |>
	calculate_mix_fitness(
		var_names = c(
			initial_number_total = "OD_initial",
			initial_fraction_A = "fraction_resistant_initial",
			final_number_total = "OD_final",
			final_fraction_A = "fraction_resistant_final",
			name_A = "resistant",
			name_B = "sensitive"
		),
		keep = c("ampicillin", "dilution")
	)
fitness_ecoli

# A lot of data, so first look at one treatment combination
fitness_ecoli |>
	filter(ampicillin == 100 & dilution == 100) |>
	plot_mix_fitness()

# Fitness ratio shows negative frequency-dependent selection
# More linear vs initial strain fraction (not ratio)
# Strain frequency doesn't affect total culture growth

# Antibiotic concentration doesn't affect total growth either
fitness_ecoli |>
	filter(ampicillin > 0) |>
	ggplot(aes(x = ampicillin, y = fitness_total)) +
	scale_x_log10(name = "Ampicillin (\u03BCg/mL)") +
	scale_y_fitness(name = "Total fitness") +
	geom_point_overlap() +
	geom_smooth(linewidth = 0.5) +
	facet_wrap(
		vars(dilution),
		labeller = as_labeller(function(x) paste0(x, "-fold dilution"))
	)


# Plot fitness ratio: resistant / sensitive ------------------------------------

# Make base plot using subset of treatment conditions
fig_ecoli <-
	fitness_ecoli |>
	filter(
		ampicillin %in% c(0, 15, 50, 100),
		dilution %in% c(200, 400, 800)
	) |>
	plot_fitness_ratio()

# Add panels and color scales for experimental conditions
name_amp <- "Ampicillin\n(\u03BCg/mL)"
fig_ecoli <- fig_ecoli +
	facet_wrap(
		vars(dilution),
		labeller = as_labeller(function(x) paste0(x, "-fold dilution"))
	) +
	aes(color = factor(ampicillin), fill = factor(ampicillin)) +
	scale_fill_viridis_d(
		name = name_amp, option = "magma", direction = -1, begin = 0.5, end = 1
	) +
	scale_color_viridis_d(
		name = name_amp, option = "magma", direction = -1, begin = 0, end = 0.8
	)

# Ampicillin concentration & culture dilution have similar effects on fitness
dev.new(width = 6.25, height = 2.25, units = "in"); fig_ecoli
