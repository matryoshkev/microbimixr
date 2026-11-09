# Strain colors ----------------------------------------------------------------

test_that("strain colors are legible and distinct", {
	skip(message = "Visual test")

	# Make dataset with strain combos
	fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
	fitness_AB <- fitness_CD <- fitness_EF <- fitness_GH <- fitness_myxo
	fitness_AB$name_A <- "A"
	fitness_AB$name_B <- "B"
	fitness_CD$name_A <- "C"
	fitness_CD$name_B <- "D"
	fitness_EF$name_A <- "E"
	fitness_EF$name_B <- "F"
	fitness_GH$name_A <- "G"
	fitness_GH$name_B <- "H"
	fitness <- rbind(fitness_AB, fitness_CD, fitness_EF, fitness_GH)
	fitness$strains <- paste(fitness$name_A, "+", fitness$name_B)

	# One strain pair
	dev.new(width = 4, height = 2.25, units = "in")
	fitness_myxo |> plot_strain_fitness(facet_strains = TRUE) +
		ggplot2::geom_smooth(
			method = "lm", formula = y ~ poly(x, 2),
			na.rm = TRUE, se = FALSE, linewidth = 0.5
		)

	# Eight strains
	dev.new(width = 4.1, height = 3.5, units = "in")
	plot_strain_fitness(fitness) +
		ggplot2::geom_smooth(
			method = "lm", formula = y ~ poly(x, 2),
			na.rm = TRUE, se = FALSE, linewidth = 0.5
		) +
		ggplot2::facet_wrap(ggplot2::vars(strains), ncol = 2) +
		ggplot2::theme(legend.position = "right")
})
