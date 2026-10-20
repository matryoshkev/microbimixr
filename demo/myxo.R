# Demonstrate basic microbimixr use ============================================

# Dependencies
library(dplyr)    # Data handling that makes code more readable
library(ggplot2)  # Graphics

# Data included in microbimixr: two Myxococcus strains forming fruiting bodies
# together, wild-type ancestral genotype and experimentally-evolved cheater
head(data_smith_2010)


# Calculate and compare fitness measures ---------------------------------------

# Fitness here is spores/cell
fitness_myxo <-
	data_smith_2010 |>
	tibble() |>
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

dev.new(); plot_mix_fitness(fitness_myxo)

# Most informative/convenient:
# - Fitness ratio vs initial ratio
# - Total fitness vs initial fraction


# Relative sporulation success: evolved / ancestral ----------------------------

# Fit statistical model
model_fitness_ratio <- lm(
	log10(fitness_ratio_A_B) ~ log10(initial_ratio_A_B),
	data = fitness_myxo,
	na.action = na.exclude
)

# Add predicted values to fitness data
fitness_myxo <- fitness_myxo |>
	mutate(fitness_ratio_predicted = 10^predict(model_fitness_ratio))

# Plot fitness ratio with fitted model
fig_fitness_ratio <-
	fitness_myxo |>
	plot_fitness_ratio(
		mix_scale = "ratio",
		ylab = "Relative sporulation success\n evolved / ancestral"
	) +
	geom_line(mapping = aes(y = fitness_ratio_predicted))
dev.new(width = 2.5, height = 2.1, units = "in"); fig_fitness_ratio

# Parameter estimates and confidence intervals
summary(model_fitness_ratio)
confint(model_fitness_ratio)


# Total sporulation success ----------------------------------------------------

# Fit statistical model
model_total_fitness <- nls(
	log10(fitness_total) ~ a + b*initial_fraction_A + c*initial_fraction_A^2,
	data = fitness_myxo,
	start = c(a = -1, b = -5, c = 0),
	na.action = na.exclude
)

# Make data frame for fitted model to be a smooth curve
fitted_total_fitness <- tibble(initial_fraction_A = seq(0,1, by = 0.02))
fitted_total_fitness <- fitted_total_fitness |>
	mutate(
		fitness_total = 10^predict(
			model_total_fitness, newdata = fitted_total_fitness
		)
	)

# Plot total sporulation success with fitted model
fig_total_fitness <-
	plot_total_fitness(
		fitness_myxo, ylab = "Total sporulation\n(spores/cell)"
	) +
	geom_line(data = fitted_total_fitness)
dev.new(width = 2.5, height = 2.1, units = "in"); fig_total_fitness

# Parameter estimates and confidence intervals
summary(model_total_fitness)
confint(model_total_fitness)

# Confidence interval for linear term includes zero
