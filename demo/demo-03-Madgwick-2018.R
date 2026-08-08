# Example usage of microbimixr: Madwick et al (2018) data
# Shows advanced microbimixr features and potential data issues

library(dplyr)    # Data handling that makes code more readable
library(ggplot2)  # To customize microbimixr plots


# Calculate fitness ------------------------------------------------------------

# Data observations are total cell counts and genotype frequency
head(data_Madgwick_2018)
var_names_Madgwick <- c(
	initial_number_total = "input_cells_total",
	initial_fraction_A = "input_freq_i",
	final_number_total = "spores_total",
	final_fraction_A = "output_freq_i",
	name_A = "strain_i",
  name_B = "strain_j"
)

# Calculate fitness measures
fitness_Madgwick <-
	data_Madgwick_2018 %>%
	tibble() %>%
	calculate_mix_fitness(var_names = var_names_Madgwick)


# Diagnostic plot of fitness effects -------------------------------------------

# Focus on one strain pair: NC105.1 + NC63.2
fitness_NC105_NC63 <-
	fitness_Madgwick %>%
	filter(name_A == "NC105.1" & name_B == "NC63.2")

dev.new(width = 6.25, height = 4.5, units = "in")
fitness_NC105_NC63 %>% plot_mix_fitness()
# Within-group relative fitness is more linear over log-ratio mix scale


# Plot specific fitness measures -------------------------------------------

dev.new(width = 5, height = 2.5)
fitness_Madgwick |>
	filter(name_A == "NC105.1" & name_B == "NC63.2") |>
	plot_strain_fitness() +
	ggplot2::facet_wrap(~ strain)

dev.new(width = 3, height = 2.5)
fitness_Madgwick |>
	filter(name_A == "NC105.1" & name_B == "NC63.2") |>
	plot_total_group_fitness()

dev.new(width = 3, height = 2.5)
fitness_NC105_NC63 |>
	plot_within_group_fitness(mix_scale = "ratio")

dev.new(width = 6.25, height = 6.5)
fitness_Madgwick |>
	plot_within_group_fitness(mix_scale = "ratio") +
	ggplot2::facet_grid(name_A ~ name_B)


# Tmp for dev -------------------------------------------


fitness_Madgwick |>
	filter(name_A == "NC105.1" & name_B == "NC63.2") |>
	select(fitness_A) |>
	range(na.rm = TRUE) |>
	expand_limits_log10()

dev.new(width = 5, height = 2.5)
fitness_Madgwick |>
	filter(name_A == "NC105.1" & name_B == "NC63.2") |>
	ggplot() +
	aes(x = initial_fraction_A, y = fitness_A) +
	geom_point_overlap(shape = 21) +
	scale_x_initial_fraction() +
	scale_y_fitness(limits = NULL)
	# scale_y_fitness()




# mgcv::gam(
# 	fitness_total ~ s(initial_fraction_A, k = 3),
# 	data = fitness_NC105_NC63,
# 	method = "REML"
# )
