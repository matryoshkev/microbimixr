# Using microbimixr with multiple strain combinations ==========================

# Dependencies
library(dplyr)      # Data handling that makes code easier to read
library(ggplot2)    # Data visualization
library(patchwork)


# Inspect data and calculate fitness -------------------------------------------

# Data included in microbimixr
head(data_Madgwick_2018)

# Two Dictystelium strains forming fruiting bodies together,
# many different strain combinations

# Ten strains
with(data_Madgwick_2018, unique(c(strain_i, strain_j)))

# 34 different pairs
data_Madgwick_2018 |> select(strain_i, strain_j) |> distinct()

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


# One strain pair --------------------------------------------------------------
# NC105.1 + NC34.2 is one of the pairs with more replicates

# Compare fitness measures
fitness_dicty |>
	filter(name_A == "NC105.1", name_B == "NC34.2") |>
	plot_mix_fitness()

# Effect sizes are small: <10-fold
# Fitness ratio is negatively frequency-dependent,
#   approx linear on log-ratio mix scale
# Both strains make more spores when rare

# Better view of the strain effects
dev.new(width = 4, height = 2.5)
fitness_dicty |>
	filter(name_A == "NC105.1", name_B == "NC34.2") |>
	plot_strain_fitness(ylab = "Spores/cell", ylim = c(0.2, 2.3)) +
	ggplot2::facet_wrap(~ strain) +
	ggplot2::theme(
		legend.title         = ggplot2::element_blank(),
		legend.background    = ggplot2::element_blank(),
		legend.position      = "top",
		legend.box.spacing   = grid::unit(0, "points"),
		strip.text           = ggplot2::element_blank(),
		strip.background     = ggplot2::element_blank()
	)


# Compare strain pairs ---------------------------------------------------------

# unique(fitness_dicty$name_A)
# unique(fitness_dicty$name_B)

# Expand fitness frame so all strains get chance to be both A and B
strain_order <- c(
	"NC28.1", "NC34.2", "NC63.2", "NC80.1", "NC105.1",  # Full reciprocal
	"NC60.1", "NC99.1",  # Not reciprocal
	"NC52.3",  # Behavior B
	"NC69.1", "NC71.1"  # Behavior C
)
fitness_matrix <-
	fitness_dicty |>
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

# unique(fitness_matrix$name_A) |> sort()
# unique(fitness_matrix$name_B) |> sort()

# Focus on two sets of strains
strain_set_1 <- c("NC28.1", "NC34.2", "NC63.2", "NC105.1")
strain_set_2 <- c("NC60.1", "NC99.1")
strain_set_3 <- c("NC69.1", "NC71.1")

fitness_matrix |>
	filter(name_A %in% strain_set_3) |>
	select(name_A, name_B) |>
	distinct()


# Plot fitness ratio
dev.new(width = 6.3, height = 6.3, units = "in")
fitness_matrix |>
	filter(
		# name_A %in% c(strain_set_1, strain_set_3),
		name_A %in% c(strain_set_1, strain_set_2, strain_set_3),
		name_B %in% strain_set_1
	) |>
	plot_fitness_ratio(
		mix_scale = "ratio",
		xlab = "Initial strain ratio (top / right)",
		ylab = "Relative sporulation success (top / right)",
		xlim = c(0.03, 30),
		ylim = c(0.1, 10)
	) +
	facet_grid(
		row = vars(name_B),
		cols = vars(name_A),
		labeller = labeller(name_B = function(x) paste("+", x))
	)
# Strains NC69.1 & NC71.1 do worse than the others
# and frequency dependence might be different shape

# Plot strain fitness
dev.new(width = 6.3, height = 5, units = "in")
fitness_matrix |>
	filter(
		name_A %in% c(strain_set_1, strain_set_2, strain_set_3),
		name_B %in% strain_set_1
	) |>
	plot_strain_fitness(
		xlab = "Initial frequency black strain",
		ylab = "Sporulation success (spores/cell)",
		ylim = c(0.1, 4),
		color = c("black", "grey55"),
		fill = c("grey55", "white")
	) +
	facet_grid(row = vars(name_B), cols = vars(name_A)) +
	theme(legend.position = "none")

# TODO: Make strain fitness easy to see and plot with multiple pairs

# # dev.new(width = 4, height = 2.5, units = "in")
# dev.new(width = 2.1, height = 2.1, units = "in")
# test_fig <-
# 	filter(fitness_matrix, name_A == "NC34.2" & name_B == "NC63.2") |>
# 	plot_strain_fitness(
# 		# xlab = "Initial fraction black strain",
# 		ylab = "Sporulation success (spores/cell)",
# 		ylim = c(0.1, 4),
# 		color = c("black", "grey45"),
# 		fill = c("grey55", "white")
# 	) +
# 	facet_wrap(~ strain) +
# 	scale_x_initial_fraction(
# 		name = "Initial fraction black strain",
# 		breaks = c(0, 0.5, 1)
# 	) +
# 	theme(
# 		legend.title         = ggplot2::element_blank(),
# 		legend.background    = ggplot2::element_blank(),
# 		legend.position      = "top",
# 		legend.margin        = margin(0),
# 		legend.box.spacing   = grid::unit(3, "points"),
# 		legend.key.size      = grid::unit(12, "points"),
# 		legend.key.spacing   = grid::unit(4, "points"),
# 		strip.text           = ggplot2::element_blank(),
# 		strip.background     = ggplot2::element_blank()
# 	)
#
# # fig_strains
# # fig_strains %+%
# # 	filter(fitness_matrix, name_A == "NC71.1" & name_B == "NC28.1")
# # Doesn't work because long-format data!
#
# dev.new(width = 6.4, height = 6.4)
# 	test_fig + test_fig + test_fig + test_fig +
# 	test_fig + test_fig + test_fig + test_fig +
# 	test_fig + test_fig + test_fig + test_fig +
# 	patchwork::plot_layout(axes = "collect")

# Total sporulation success
# dev.new(width = 6.3, height = 5, units = "in")
# fitness_matrix |>
# 	filter(
# 		name_A %in% c(strain_set_1, strain_set_2),
# 		name_B %in% strain_set_1
# 	) |>
# 	plot_total_fitness(
# 		mix_scale = "ratio",
# 		xlab = "Initial strain ratio (top / right)",
# 		xlim = c(0.03, 30),
# 		# ylim = c(0.1, 10)
# 	) +
# 	facet_grid(row = vars(name_B), cols = vars(name_A))

# Strain fitness: linear via plot components
# dev.new(width = 6.3, height = 6.3)
# fitness_matrix |>
# 	ggplot(aes(x = initial_fraction_A, y = fitness_A, group = replicate)) +
# 	scale_x_initial_fraction(name = "Initial freq right") +
# 	scale_y_continuous(
# 		name = "Spores/cell (right strain)",
# 		limits = c(0, 1.5),
# 		breaks = seq(0, 2, by = 0.5),
# 		minor_breaks = NULL
# 	) +
# 	geom_line(color = gray(0.8), na.rm = TRUE) +
# 	geom_point_overlap(na.rm = TRUE) +
# 	facet_grid(row = vars(name_A), cols = vars(name_B)) +
# 	theme(text = ggplot2::element_text(size = 9))

