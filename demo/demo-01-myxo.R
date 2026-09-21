# Demonstrate basic microbimixr use ============================================

# Dependencies
library(dplyr)    # Data handling that makes code more readable
library(ggplot2)  # Graphics package


# Calculate & compare fitness measures -----------------------------------------

# Data included in microbimixr
head(data_smith_2010)

# Two Myxococcus strains forming fruiting bodies together:
# a wild-type ancestral genotype and an experimentally-evolved cheater

# Calculate fitness measures
fitness_myxo <-
	data_smith_2010 |>
	dplyr::tibble() |>
	calculate_mix_fitness(
		var_names = c(
			initial_number_A = "initial_cells_evolved",
			initial_number_B = "initial_cells_ancestral",
			final_number_A = "final_spores_evolved",
			final_number_B = "final_spores_ancestral",
			name_A = "evolved",
			name_B = "ancestral"
		),
		keep = "exptl_block"
	)
fitness_myxo
# Fitness here is spores/cell

# Compare fitness measures
plot_mix_fitness(fitness_myxo)

# Group measures appear most informative/convenient:
# - Within-group fitness ratio vs initial ratio
# - Total group fitness vs initial fraction


# Within-group fitness ratio ---------------------------------------------------

# Fit statistical model
model_within_group <- lm(
	log10(fitness_ratio_A_B) ~ log10(initial_ratio_A_B),
	data = fitness_myxo,
	na.action = na.exclude
)

# Add predicted values to fitness frame
fitness_myxo <- fitness_myxo |>
	dplyr::mutate(fitness_ratio_predicted = 10^predict(model_within_group))

# Plot within-group fitness ratio with fitted model
dev.new(width = 2.5, height = 2.1, units = "in")
fig_within_group <- plot_fitness_ratio(
	fitness_myxo,
	mix_scale = "ratio",
	ylab = "Relative sporulation success\n evolved / ancestral"
)
fig_within_group +
	ggplot2::geom_line(mapping = aes(y = fitness_ratio_predicted))

# Parameter estimates and confidence intervals
summary(model_within_group)
confint(model_within_group)

# The functional relationship here would be
# w_evo / w_anc = a * (q_evo / q_anc)^b
# where a = 10^intercept, b = slope


# Total-group fitness ----------------------------------------------------------

# Fit statistical model
model_total_group <- nls(
	log10(fitness_total) ~ a + b*initial_fraction_A + c*initial_fraction_A^2,
	data = fitness_myxo,
	start = c(a = -1, b = -5, c = 0),
	na.action = na.exclude
)

# Make data frame for fitted model to be a smooth curve
fitted_total_group <- dplyr::tibble(initial_fraction_A = seq(0,1, by = 0.02))
fitted_total_group <- dplyr::mutate(
	fitted_total_group,
	fitness_total = 10^predict(model_total_group, newdata = fitted_total_group)
)

# Plot total-group fitness with fitted model
dev.new(width = 2.5, height = 2.1, units = "in")
fig_total_group <- plot_total_fitness(
	fitness_myxo, ylab = "Total sporulation success\n (spores/cell)"
)
fig_total_group + ggplot2::geom_line(data = fitted_total_group)

# Parameter estimates and confidence intervals
summary(model_total_group)
confint(model_total_group)
# Confidence interval for linear term includes zero

# The functional relationship here would be
# W = 10^(a + b*q_evo + c*q_evo^2)

