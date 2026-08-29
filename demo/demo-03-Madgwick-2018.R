# Example usage of microbimixr: Madwick et al (2018) data
# Shows advanced microbimixr features

library(dplyr)    # Data handling that makes code easier to read
library(ggplot2)  # Data visualization


head(data_Madgwick_2018)
# Data are total cell counts and genotype frequency

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
fitness_dicty


# Strain pair NC105.1 + NC34.2 -------------------------------------------------
# One of the strain pairs with more replicates

fitness_dicty |>
	filter(name_A == "NC105.1", name_B == "NC34.2") |>
	plot_mix_fitness()

# Both strains make more spores when rare, but effect sizes are small
# Within-group fitness ratio is negatively frequency-depdenent,
#   linear on log-ratio mix scale

# Strain fitness
dev.new(width = 4, height = 2)
fitness_dicty |>
	filter(name_A == "NC105.1", name_B == "NC34.2") |>
	plot_strain_fitness(ylab = "Spores/cell", ylim = c(0.2, 2.3)) +
	ggplot2::facet_wrap(~ strain) +
	theme(legend.position = "none")

# fitness_dicty |>
# 	filter(name_A == "NC105.1", name_B == "NC34.2") |>
# 	plot_strain_fitness()

# Multilevel fitness measures
dev.new(width = 4.5, height = 2)
fig_total <-
	fitness_dicty |>
	filter(name_A == "NC105.1" & name_B == "NC63.2") |>
	plot_total_group_fitness(
		ylab = "Total spores/cell", ylim = c(0.2, 2)
	)
fig_within <-
	fitness_dicty |>
	filter(name_A == "NC105.1", name_B == "NC34.2") |>
	plot_within_group_fitness(
		mix_scale = "ratio",
		ylab = "Sporulation success\nNC105.1 / NC34.2",
		ylim = c(0.4, 4)
	)
fig_total + fig_within

fig_total <-
	fitness_dicty |>
	filter(name_A == "NC105.1" & name_B == "NC63.2") |>
	plot_total_group_fitness()
fig_within <-
	fitness_dicty |>
	filter(name_A == "NC105.1", name_B == "NC34.2") |>
	plot_within_group_fitness(mix_scale = "ratio")
fig_total + fig_within


# Multiple strain pairs --------------------------------------------------------

# Focus on subset of strain pairs
# Fill out fitness frame so every strain gets chance to be both A and B
strain_order <- c("NC28.1", "NC34.2", "NC63.2", "NC80.1", "NC105.1")
fitness_matrix <-
	fitness_dicty |>
	filter(name_A %in% strain_order & name_B %in% strain_order) |>
	mutate(
			name_A = factor(name_A, levels = strain_order),
			name_B = factor(name_B, levels = strain_order)
	)
fitness_matrix <-
	fitness_matrix |>
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
	bind_rows(fitness_matrix)

# Plot fitness measures
dev.new(width = 6.3, height = 6.3)

# Within-group fitness
fitness_matrix |>
	plot_within_group_fitness(
		xlab = "Initial strain ratio (top / right)",
		ylab = "Relative sporulation success (top / right)",
		mix_scale = "ratio",
		xlim = c(0.03, 30),
		ylim = c(0.2, 5)
	) +
	ggplot2::facet_grid(name_B ~ name_A)

# fitness_matrix |>
# 	plot_within_group_fitness() +
# 	ggplot2::facet_grid(name_B ~ name_A)

# Total-group fitness
fitness_matrix |>
	plot_total_group_fitness(
		# mix_scale = "ratio",
		# xlab = "Initial ratio: top strain / right strain",
		xlab = "Initial frequency (top strain)",
		ylab = "Total spores/cell",
		ylim = c(0.1, 2)
	) +
	ggplot2::facet_grid(name_B ~ name_A)

# Total-group fitness (linear via plot components)
fitness_matrix |>
	ggplot(aes(x = initial_fraction_A, y = fitness_total, group = replicate)) +
	scale_x_initial_fraction(
		name = "Initial frequency (top strain)",
		minor_breaks = seq(0, 1, by = 0.2)
	) +
	scale_y_continuous(
		name = "Total spores/cell",
		limits = c(0, 1.5),
		breaks = seq(0, 2, by = 0.5),
		minor_breaks = NULL
	) +
	geom_hline(yintercept = 1, color = "white", linewidth = 1) +
	geom_point_overlap(na.rm = TRUE) +
	ggplot2::facet_grid(name_B ~ name_A)

# Strain fitness via plot components
fitness_matrix |>
	ggplot(aes(x = initial_fraction_A, y = fitness_A)) +
	scale_x_initial_fraction(
		name = "Initial frequency (top strain)",
		# breaks = c(0, 0.5, 1),
		minor_breaks = seq(0, 1, by = 0.2)
	) +
	scale_y_fitness(
		name = "Spores/cell (top strain)",
		limits = c(0.1, 4)
		# minor_breaks = NULL
	) +
	geom_hline(yintercept = 1, color = "white", linewidth = 1) +
	geom_point_overlap(na.rm = TRUE) +
	ggplot2::facet_grid(name_B ~ name_A) +
	ggplot2::theme(
		text = ggplot2::element_text(size = 9)
	)



# Tmp for dev -------------------------------------------

# mgcv::gam(
# 	fitness_total ~ s(initial_fraction_A, k = 3),
# 	data = fitness_NC105_NC63,
# 	method = "REML"
# )

