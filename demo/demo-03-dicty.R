# Using microbimixr with multiple strain combinations ==========================

# Dependencies
library(dplyr)    # Data handling that makes code easier to read
library(ggplot2)  # Graphics package


# Calculate and compare fitness measures ---------------------------------------

# Data included in microbimixr
head(data_Madgwick_2018)

# Two Dictystelium strains forming fruiting bodies together,
# many different strain combinations

# Calculate fitness measures
fitness_dicty <-
	data_Madgwick_2018 |>
	tibble() |>
	calculate_mix_fitness(
		var_names = c(
			initial_number_total = "input_cells_total",
			initial_fraction_A = "input_freq_i",
			final_number_total = "spores_total",
			final_fraction_A = "output_freq_i",
			name_A = "strain_i",
			name_B = "strain_j"
		),
		keep = "replicate"
	)
# Fitness here is spores/cell

# Compare fitness measures
# NC105.1 + NC34.2 is one of the strain pairs with more replicates
dev.new()
fitness_dicty |>
	filter(name_A == "NC105.1", name_B == "NC34.2") |>
	plot_mix_fitness()

# Effect sizes are small: <10-fold
# Fitness ratio is negatively frequency-dependent,
#   approx linear on log-ratio mix scale

# Better view of the strain effects
dev.new(width = 4, height = 2.25)
fitness_dicty |>
	filter(name_A == "NC105.1", name_B == "NC34.2") |>
	plot_strain_fitness(ylab = "Spores/cell", ylim = c(0.2, 2.3)) +
	facet_wrap(~ strain) +
	theme(legend.position = "none")
# Both strains make more spores when rare


# Compare strain pairs ---------------------------------------------------------

# Expand fitness frame so all strains get chance to be both A and B
strain_order <- c(
	"NC28.1", "NC34.2", "NC63.2", "NC80.1", "NC105.1", "NC60.1", "NC99.1",
	"NC52.3", "NC69.1", "NC71.1"
)
fitness_dicty <- fitness_dicty |>
	rename(
		name_A = name_B,
		name_B = name_A,
		fitness_A = fitness_B,
		fitness_B = fitness_A,
	) |>
	mutate(
		initial_fraction_A = 1 - initial_fraction_A,
		initial_ratio_A_B = 1 / initial_ratio_A_B,
		fitness_ratio_A_B = 1 / fitness_ratio_A_B,
	) |>
	bind_rows(fitness_dicty) |>
	mutate(
		name_A = factor(name_A, levels = strain_order),
		name_B = factor(name_B, levels = strain_order)
	)

# Focus on one set of strain combinations
fitness_focus <-
	fitness_dicty |>
	filter(
		name_A %in% c("NC34.2", "NC60.1", "NC99.1", "NC69.1", "NC71.1"),
		name_B %in% c("NC28.1", "NC63.2", "NC105.1")
	)

# Plot fitness ratio
dev.new(width = 6.4, height = 4.25, units = "in")
fitness_focus |>
	plot_fitness_ratio(
		mix_scale = "ratio",
		xlab = "Initial strain ratio (top / right)",
		ylab = "Relative sporulation success (top / right)"
	) +
	facet_grid(
		rows = vars(name_B),
		cols = vars(name_A),
		labeller = labeller(name_B = function(x) paste("+", x))
	)
# Strains NC69.1 & NC71.1 do worse than the others
# and frequency dependence might be different shape

# Plot strain fitness
dev.new(width = 6.4, height = 4.25, units = "in")
fitness_focus |>
	plot_strain_fitness(
		ylab = "Sporulation success (spores/cell)", size = 1.2
	) +
	scale_x_initial_fraction(
		name = "Initial frequency of top strain", breaks = c(0, 0.5, 1)
	) +
	facet_grid(
		cols = vars(name_A, strain),
		rows = vars(name_B),
		labeller = labeller(
			name_B = function(x) paste("+", x),
			strain = function(x) paste("")
		)
	) +
	theme(
		legend.position = "none",
		strip.text.x = element_text(color = "tan4", face = "bold"),
		strip.text.y = element_text(color = "lightsteelblue4", face = "bold"),
		strip.background = element_blank()
	)

# TODO:
# Needs cleaner top labels, nested spacing. Try ggh4x::facet_nested()

