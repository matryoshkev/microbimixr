# Working with strain fitness ==================================================

# Dependencies
library(dplyr)    # Data handling that makes code easier to read
library(ggplot2)  # Graphics package
library(ggh4x)    # Nested facets in plots

# Data included in microbimixr: two Dictystelium strains making fruiting bodies
# together, many different strain combinations
head(data_Madgwick_2018)

# Calculate fitness measures
fitness_dicty <-
	data_Madgwick_2018 |>
	tibble() |>
	calculate_mix_fitness(var_names = c(
		initial_number_total = "input_cells_total",
		initial_fraction_A = "input_freq_i",
		final_number_total = "spores_total",
		final_fraction_A = "output_freq_i",
		name_A = "strain_i",
		name_B = "strain_j"
	))
	# Fitness here is spores/cell


## One strain pair -------------------------------------------------------------
# NC105.1 + NC34.2 is one of the pairs with more replicates

# Compare fitness measures
fitness_pair <- fitness_dicty |> filter(name_A == "NC105.1", name_B == "NC34.2")
plot_mix_fitness(fitness_pair)
	# Effect sizes are small: <10-fold
	# Fitness ratio is negatively frequency-dependent,
	# approx linear on log-ratio frequency scale

# Better view of the strain effects
dev.new(width = 4, height = 2.5)
plot_strain_fitness(fitness_pair, ylab = "Spores/cell", facet_strains = TRUE)
	# Both strains make more spores when rare

# Plot data with models fit to each strain separately
model_A <- lm(fitness_A ~ poly(initial_fraction_A, 3), data = fitness_pair)
model_B <- update(model_A, fitness_B ~ poly(initial_fraction_A, 3))
fitted_models <- tibble(initial_fraction_A = seq(0, 1, by = 0.02))
fitted_models <- fitted_models |>
	mutate(
		fitness_A = predict(model_A, newdata = fitted_models),
		fitness_B = predict(model_B, newdata = fitted_models),
		name_A = "NC105.1",
		name_B = "NC34.2",
		fitness_A = case_when(initial_fraction_A < 0.04 ~ NA, TRUE ~ fitness_A),
		fitness_B = case_when(initial_fraction_A > 0.96 ~ NA, TRUE ~ fitness_B)
	)
fitness_pair |>
	plot_strain_fitness(ylab = "Spores/cell", facet_strains = TRUE) +
	geom_line(data = lengthen_strain_fitness(fitted_models), na.rm = TRUE)

# Plot data with one model fit to data for both strains
model_joint <- lm(
	fitness ~ strain * poly(initial_fraction_A, 3),
	data = lengthen_strain_fitness(fitness_pair)
)
fitted_joint <- expand.grid(
	initial_fraction_A = seq(0, 1, by = 0.02),
	strain = c("NC105.1", "NC34.2")
)
fitted_joint <-
	tibble(fitted_joint) |>
	mutate(
		fitness = predict(model_joint, newdata = fitted_joint),
		name_A = "NC105.1",
		name_B = "NC34.2",
		fitness = case_when(
			initial_fraction_A == 0 & strain == name_A ~ NA,
			initial_fraction_A == 1 & strain == name_B ~ NA,
			TRUE ~ fitness
		)
	)
fitness_pair |>
	plot_strain_fitness(ylab = "Spores/cell", facet_strains = TRUE) +
	geom_line(data = fitted_joint, na.rm = TRUE)


## Multiple strain pairs -------------------------------------------------------

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
dev.new(width = 6.5, height = 4.25, units = "in")
fitness_focus |>
	plot_fitness_ratio(
		mix_scale = "ratio",
		xlab = "Initial strain ratio (top / right)",
		ylab = "Relative sporulation success (top / right)"
	) +
	facet_grid(
		cols = vars(name_A), rows = vars(name_B),
		labeller = labeller(name_B = function(x) paste("+", x))
	)
	# Strains NC69.1 & NC71.1 do worse than the others
	# and frequency dependence might be different shape

# Plot strain fitness (facet by strain)
dev.new(width = 6.5, height = 4.25, units = "in")
fitness_focus |>
	plot_strain_fitness(ylab = "Spores/cell", size = 1.2, shape = 16) +
	ggh4x::facet_nested(
		cols = vars(name_A, strain), rows = vars(name_B),
		labeller = labeller(name_B = function(x) paste("+", x)),
		strip = ggh4x::strip_nested(
			by_layer_x = TRUE,
			size = "variable",
			text_x = ggh4x::elem_list_text(
				size = c(NA, 0), margin = list(NA, margin(0, 0, 0, 0))
			)
		)
	) +
	scale_x_initial_fraction(
		name = "Initial frequency of top strain",
		breaks = c(0, 1), minor_breaks = c(0, 0.5, 1)
	) +
	theme(
		legend.position = "none",
		strip.background = element_blank(),
		strip.text = element_text(size = 9),
		strip.text.x = element_text(color = "#AB6C02"),
		strip.text.y = element_text(color = "#00259E")
	)
	# NC69.1 & NC71.1 make fewer spores in mixes. Other strains make more.
