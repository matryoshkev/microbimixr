# Basic plotting ---------------------------------------------------------------

test_that("plot functions run defaults", {
	fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
	expect_no_error(plot_mix_fitness(fitness_myxo))
	expect_no_error(plot_strain_fitness(fitness_myxo))
	expect_no_error(plot_total_group_fitness(fitness_myxo))
	expect_no_error(plot_within_group_fitness(fitness_myxo))
})

test_that("plot functions accept mixing ratio for x-axis scale", {
	fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
	expect_no_error(plot_mix_fitness(fitness_myxo, mix_scale = "ratio"))
	expect_no_error(plot_strain_fitness(fitness_myxo, mix_scale = "ratio"))
	expect_no_error(plot_total_group_fitness(fitness_myxo, mix_scale = "ratio"))
	expect_no_error(plot_within_group_fitness(fitness_myxo, mix_scale = "ratio"))
})

test_that("plot_mix_fitness() accepts single mixing scale", {
	fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
	expect_no_error(plot_mix_fitness(fitness_myxo, mix_scale = "fraction"))
	expect_no_error(plot_mix_fitness(fitness_myxo, mix_scale = "ratio"))
})


# Input validation -------------------------------------------------------------
# and informative error messages

# test_that("plot functions list variables missing in var_names", {
# 	fitness <- data.frame(
# 		initial_fraction_A = 0.5,
# 		initial_ratio_A_B = 1,
# 		fitness_A	= 10,
# 		fitness_B	= 20,
# 		fitness_total = 15,
# 		fitness_ratio_A_B = 10/20
# 	)
# 	strains <- c(name_A = "A", name_B = "B")
#
# 	# Compare fitness measures
# 	expect_snapshot(
# 		plot_mix_fitness(fitness, var_names = c(strains,
# 			# initial_fraction_A = "initial_fraction_A",
# 			initial_ratio_A_B = "initial_ratio_A_B",
# 			fitness_A = "fitness_A",
# 			fitness_B = "fitness_B",
# 			fitness_total = "fitness_total",
# 			fitness_ratio_A_B = "fitness_ratio_A_B"
# 		)),
# 		error = TRUE
# 	)
# 	expect_snapshot(
# 		plot_mix_fitness(fitness, var_names = c(strains,
# 			initial_fraction_A = "initial_fraction_A",
# 			# initial_ratio_A_B = "initial_ratio_A_B",
# 			fitness_A = "fitness_A",
# 			fitness_B = "fitness_B",
# 			fitness_total = "fitness_total",
# 			fitness_ratio_A_B = "fitness_ratio_A_B"
# 		)),
# 		error = TRUE
# 	)
# 	expect_snapshot(
# 		plot_mix_fitness(fitness, var_names = c(strains,
# 			initial_fraction_A = "initial_fraction_A",
# 			initial_ratio_A_B = "initial_ratio_A_B",
# 			# fitness_A = "fitness_A",
# 			fitness_B = "fitness_B",
# 			fitness_total = "fitness_total",
# 			fitness_ratio_A_B = "fitness_ratio_A_B"
# 		)),
# 		error = TRUE
# 	)
# 	expect_snapshot(
# 		plot_mix_fitness(fitness, var_names = c(strains,
# 			initial_fraction_A = "initial_fraction_A",
# 			initial_ratio_A_B = "initial_ratio_A_B",
# 			fitness_A = "fitness_A",
# 			# fitness_B = "fitness_B",
# 			fitness_total = "fitness_total",
# 			fitness_ratio_A_B = "fitness_ratio_A_B"
# 		)),
# 		error = TRUE
# 	)
# 	expect_snapshot(
# 		plot_mix_fitness(fitness, var_names = c(strains,
# 			initial_fraction_A = "initial_fraction_A",
# 			initial_ratio_A_B = "initial_ratio_A_B",
# 			fitness_A = "fitness_A",
# 			fitness_B = "fitness_B",
# 			# fitness_total = "fitness_total",
# 			fitness_ratio_A_B = "fitness_ratio_A_B"
# 		)),
# 		error = TRUE
# 	)
# 	expect_snapshot(
# 		plot_mix_fitness(fitness, var_names = c(strains,
# 			initial_fraction_A = "initial_fraction_A",
# 			initial_ratio_A_B = "initial_ratio_A_B",
# 			fitness_A = "fitness_A",
# 			fitness_B = "fitness_B",
# 			fitness_total = "fitness_total"
# 			# fitness_ratio_A_B = "fitness_ratio_A_B"
# 		)),
# 		error = TRUE
# 	)
#
# 	# Strain fitness
# 	expect_snapshot(
# 		plot_strain_fitness(fitness, var_names = c(strains,
# 			# initial_fraction_A = "initial_fraction_A",
# 			fitness_A = "fitness_A",
# 			fitness_B = "fitness_B"
# 		)),
# 		error = TRUE
# 	)
# 	expect_snapshot(
# 		plot_strain_fitness(fitness, mix_scale = "ratio", var_names = c(strains,
# 			# initial_ratio_A_B = "initial_ratio_A_B",
# 			fitness_A = "fitness_A",
# 			fitness_B = "fitness_B"
# 		)),
# 		error = TRUE
# 	)
# 	expect_snapshot(
# 		plot_strain_fitness(fitness, var_names = c(strains,
# 			initial_fraction_A = "initial_fraction_A",
# 			# fitness_A = "fitness_A",
# 			fitness_B = "fitness_B"
# 		)),
# 		error = TRUE
# 	)
# 	expect_snapshot(
# 		plot_strain_fitness(fitness, var_names = c(strains,
# 			initial_fraction_A = "initial_fraction_A",
# 			fitness_A = "fitness_A"
# 			# fitness_B = "fitness_B"
# 		)),
# 		error = TRUE
# 	)
#
# 	# Total fitness
# 	expect_snapshot(
# 		plot_total_group_fitness(fitness,
# 			var_names = c(strains, fitness_total = "fitness_total")
# 		),
# 		error = TRUE
# 	)
# 	expect_snapshot(
# 		plot_total_group_fitness(fitness, mix_scale = "ratio",
# 			var_names = c(strains, fitness_total = "fitness_total")
# 		),
# 		error = TRUE
# 	)
# 	expect_snapshot(
# 		plot_total_group_fitness(fitness,
# 			var_names = c(strains, initial_fraction_A = "initial_fraction_A")
# 		),
# 		error = TRUE
# 	)
#
# 	# Fitness ratio
# 	expect_snapshot(
# 		plot_within_group_fitness(fitness,
# 			var_names = c(strains, fitness_ratio_A_B = "fitness_ratio_A_B")
# 		),
# 		error = TRUE
# 	)
# 	expect_snapshot(
# 		plot_within_group_fitness(fitness, mix_scale = "ratio",
# 			var_names = c(strains, fitness_ratio_A_B = "fitness_ratio_A_B")
# 		),
# 		error = TRUE
# 	)
# 	expect_snapshot(
# 		plot_within_group_fitness(fitness,
# 			var_names = c(strains, initial_fraction_A = "initial_fraction_A")
# 		),
# 		error = TRUE
# 	)
# })
#
# test_that("plot functions report missing data columns", {
# 	# Compare fitness measures
# 	expect_snapshot(
# 		{
# 			plot_mix_fitness(
# 				data.frame(
# 					# initial_fraction_A = 0.5,
# 					initial_ratio_A_B = 1,
# 					fitness_A = 5,
# 					fitness_B = 10,
# 					fitness_total = 10,
# 					fitness_ratio_A_B = 10
# 				),
# 				var_names = fitness_vars_default()
# 			)
# 			plot_mix_fitness(
# 				data.frame(
# 					initial_fraction_A = 0.5,
# 					# initial_ratio_A_B = 1,
# 					fitness_A = 5,
# 					fitness_B = 10,
# 					fitness_total = 10,
# 					fitness_ratio_A_B = 10
# 				),
# 				var_names = fitness_vars_default()
# 			)
# 			plot_mix_fitness(
# 				data.frame(
# 					initial_fraction_A = 0.5,
# 					initial_ratio_A_B = 1,
# 					# fitness_A = 5,
# 					fitness_B = 10,
# 					fitness_total = 10,
# 					fitness_ratio_A_B = 10
# 				),
# 				var_names = fitness_vars_default()
# 			)
# 			plot_mix_fitness(
# 				data.frame(
# 					initial_fraction_A = 0.5,
# 					initial_ratio_A_B = 1,
# 					fitness_A = 5,
# 					# fitness_B = 10,
# 					fitness_total = 10,
# 					fitness_ratio_A_B = 10
# 				),
# 				var_names = fitness_vars_default()
# 			)
# 			plot_mix_fitness(
# 				data.frame(
# 					initial_fraction_A = 0.5,
# 					initial_ratio_A_B = 1,
# 					fitness_A = 5,
# 					fitness_B = 10,
# 					# fitness_total = 10,
# 					fitness_ratio_A_B = 10
# 				),
# 				var_names = fitness_vars_default()
# 			)
# 			plot_mix_fitness(
# 				data.frame(
# 					initial_fraction_A = 0.5,
# 					initial_ratio_A_B = 1,
# 					fitness_A = 5,
# 					fitness_B = 10,
# 					fitness_total = 10
# 					# fitness_ratio_A_B = 10
# 				),
# 				var_names = fitness_vars_default()
# 			)
# 		},
# 		error = TRUE
# 	)
#
# 	# Strain fitness
# 	expect_snapshot(
# 		{
# 			plot_strain_fitness(
# 				data.frame(fitness_A = 5, fitness_B = 10),
# 				var_names = fitness_vars_default()
# 			)
# 			plot_strain_fitness(
# 				data.frame(fitness_A = 5, fitness_B = 10),
# 				var_names = fitness_vars_default(),
# 				mix_scale = "ratio"
# 			)
# 			plot_strain_fitness(
# 				data.frame(fitness_B = 10, initial_fraction_A = 0.5),
# 				var_names = fitness_vars_default()
# 			)
# 			plot_strain_fitness(
# 				data.frame(fitness_A = 5, initial_fraction_A = 0.5),
# 				var_names = fitness_vars_default()
# 			)
# 			plot_strain_fitness(
# 				data.frame(),
# 				var_names = fitness_vars_default()
# 			)
# 		},
# 		error = TRUE
# 	)
#
# 	# Total fitness
# 	expect_snapshot(
# 		{
# 			plot_total_group_fitness(
# 				data.frame(fitness_total = 10),
# 				var_names = fitness_vars_default()
# 			)
# 			plot_total_group_fitness(
# 				data.frame(fitness_total = 10),
# 				var_names = fitness_vars_default(),
# 				mix_scale = "ratio"
# 			)
# 			plot_total_group_fitness(
# 				data.frame(initial_fraction_A = 0.5),
# 				var_names = fitness_vars_default()
# 			)
# 			plot_total_group_fitness(
# 				data.frame(),
# 				var_names = fitness_vars_default())
# 		},
# 		error = TRUE
# 	)
#
# 	# Fitness ratio
# 	expect_snapshot(
# 		{
# 			plot_within_group_fitness(
# 				data.frame(fitness_ratio_A_B = 5),
# 				var_names = fitness_vars_default()
# 			)
# 			plot_within_group_fitness(
# 				data.frame(fitness_ratio_A_B = 0.5),
# 				var_names = fitness_vars_default(),
# 				mix_scale = "ratio"
# 			)
# 			plot_within_group_fitness(
# 				data.frame(initial_fraction_A = 0.5),
# 				var_names = fitness_vars_default()
# 			)
# 			plot_within_group_fitness(
# 				data.frame(),
# 				var_names = fitness_vars_default()
# 			)
# 		},
# 		error = TRUE
# 	)
# })

# # TODO
# test_that("plot functions indicate unplottable fitness values"), {
# 	# inform() zeroes undefined on log scale
# 	# inform() Inf undefined on log scale
# 	# warn() < 0 not biologically meaningful
# 	# warn() NaN not biologically meaningful
# }


# Plot customization -----------------------------------------------------------

test_that("plot functions accept expression() axis labels", {
	fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
	label <- expression("label")
	expect_no_error(plot_strain_fitness(
		fitness_myxo, xlab = label, ylab = label
	))
	expect_no_error(plot_total_group_fitness(
		fitness_myxo, xlab = label, ylab = label
	))
	expect_no_error(plot_within_group_fitness(
		fitness_myxo, xlab = label, ylab = label
	))
})

test_that("plot functions accept point args", {
	fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
	color <- c("black", "grey55", "grey35")
	fill <- c("grey45", "white", "grey75")
	shape <- 23
	size <- 2
	expect_no_error(plot_mix_fitness(
		fitness_myxo, color = color, fill = fill, shape = shape, size = size
	))
	expect_no_error(plot_strain_fitness(
		fitness_myxo, color = color, fill = fill, shape = shape, size = size
	))
	expect_no_error(plot_total_group_fitness(
		fitness_myxo, color = color, fill = fill, shape = shape, size = size
	))
	expect_no_error(plot_within_group_fitness(
		fitness_myxo, color = color, fill = fill, shape = shape, size = size
	))
})

