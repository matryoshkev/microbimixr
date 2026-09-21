# Basic plotting ---------------------------------------------------------------

test_that("plot functions run defaults", {
	fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
	expect_no_error({
		plot_strain_fitness(fitness_myxo)
		plot_total_fitness(fitness_myxo)
		plot_fitness_ratio(fitness_myxo)
		plot_mix_fitness(fitness_myxo)
	})
})

test_that("plot functions accept initial ratio as x-axis scale", {
	fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
	expect_no_error({
		plot_mix_fitness(fitness_myxo, mix_scale = "ratio")
		plot_strain_fitness(fitness_myxo, mix_scale = "ratio")
		plot_total_fitness(fitness_myxo, mix_scale = "ratio")
		plot_fitness_ratio(fitness_myxo, mix_scale = "ratio")
	})
})

test_that("plot_mix_fitness() accepts single mixing scale", {
	fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
	expect_no_error({
		plot_mix_fitness(fitness_myxo, mix_scale = "fraction")
		plot_mix_fitness(fitness_myxo, mix_scale = "ratio")
	})
})

test_that("plot functions can use custom variable names", {
	fitness_data <-
		data.frame(qA = 0.5, qAqB = 1, wA = 10, wB = 20, W = 15, wAwB = 10/20)
	my_names <- c(
		initial_fraction_A = "qA",
		initial_ratio_A_B = "qAqB",
		fitness_A	= "wA",
		fitness_B	= "wB",
		fitness_total = "W",
		fitness_ratio_A_B = "wAwB",
		name_A = "A",
		name_B = "B"
	)
	expect_no_error({
		plot_mix_fitness(fitness_data, var_names = my_names)
		plot_strain_fitness(fitness_data, var_names = my_names)
		plot_total_fitness(fitness_data, var_names = my_names)
		plot_fitness_ratio(fitness_data, var_names = my_names)
	})
})


# Input validation -------------------------------------------------------------
# with informative errors, warnings, and messages

test_that("plot functions list variables missing in var_names", {
	fitness_data <- data.frame(
		initial_fraction_A = 0.5,
		initial_ratio_A_B = 1,
		fitness_A	= 10,
		fitness_B	= 20,
		fitness_total = 15,
		fitness_ratio_A_B = 10/20
	)
	strains <- c(name_A = "Strain A", name_B = "Strain B")

	# Compare fitness measures
	expect_error(
		plot_mix_fitness(fitness_data, var_names = c(strains,
			# initial_fraction_A = "initial_fraction_A",
			initial_ratio_A_B = "initial_ratio_A_B",
			fitness_A = "fitness_A",
			fitness_B = "fitness_B",
			fitness_total = "fitness_total",
			fitness_ratio_A_B = "fitness_ratio_A_B"
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_mix_fitness(fitness_data, var_names = c(strains,
			initial_fraction_A = "initial_fraction_A",
			# initial_ratio_A_B = "initial_ratio_A_B",
			fitness_A = "fitness_A",
			fitness_B = "fitness_B",
			fitness_total = "fitness_total",
			fitness_ratio_A_B = "fitness_ratio_A_B"
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_mix_fitness(fitness_data, var_names = c(strains,
			initial_fraction_A = "initial_fraction_A",
			initial_ratio_A_B = "initial_ratio_A_B",
			# fitness_A = "fitness_A",
			fitness_B = "fitness_B",
			fitness_total = "fitness_total",
			fitness_ratio_A_B = "fitness_ratio_A_B"
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_mix_fitness(fitness_data, var_names = c(strains,
			initial_fraction_A = "initial_fraction_A",
			initial_ratio_A_B = "initial_ratio_A_B",
			fitness_A = "fitness_A",
			# fitness_B = "fitness_B",
			fitness_total = "fitness_total",
			fitness_ratio_A_B = "fitness_ratio_A_B"
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_mix_fitness(fitness_data, var_names = c(strains,
			initial_fraction_A = "initial_fraction_A",
			initial_ratio_A_B = "initial_ratio_A_B",
			fitness_A = "fitness_A",
			fitness_B = "fitness_B",
			# fitness_total = "fitness_total",
			fitness_ratio_A_B = "fitness_ratio_A_B"
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_mix_fitness(fitness_data, var_names = c(strains,
			initial_fraction_A = "initial_fraction_A",
			initial_ratio_A_B = "initial_ratio_A_B",
			fitness_A = "fitness_A",
			fitness_B = "fitness_B",
			fitness_total = "fitness_total"
			# fitness_ratio_A_B = "fitness_ratio_A_B"
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_mix_fitness(fitness_data, var_names = strains),
		regexp = "not found in"
	)

	# Strain fitness
	expect_error(
		plot_strain_fitness(fitness_data, var_names = c(strains,
			# initial_fraction_A = "initial_fraction_A",
			fitness_A = "fitness_A",
			fitness_B = "fitness_B"
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_strain_fitness(fitness_data, mix_scale = "ratio", var_names = c(strains,
			# initial_ratio_A_B = "initial_ratio_A_B",
			fitness_A = "fitness_A",
			fitness_B = "fitness_B"
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_strain_fitness(fitness_data, var_names = c(strains,
			initial_fraction_A = "initial_fraction_A",
			# fitness_A = "fitness_A",
			fitness_B = "fitness_B"
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_strain_fitness(fitness_data, var_names = c(strains,
			initial_fraction_A = "initial_fraction_A",
			fitness_A = "fitness_A"
			# fitness_B = "fitness_B"
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_strain_fitness(fitness_data, var_names = strains),
		regexp = "not found in"
	)

	# Total fitness
	expect_error(
		plot_total_fitness(fitness_data, var_names = c(strains,
			# initial_fraction_A = "initial_fraction_A",
			fitness_total = "fitness_total"
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_total_fitness(fitness_data, mix_scale = "ratio",
			var_names = c(strains,
				# initial_ratio_A_B = "initial_ratio_A_B",
				fitness_total = "fitness_total"
			)
		),
		regexp = "not found in"
	)
	expect_error(
		plot_total_fitness(fitness_data, var_names = c(strains,
			initial_fraction_A = "initial_fraction_A"
			# fitness_total = "fitness_total"
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_total_fitness(fitness_data, var_names = strains),
		regexp = "not found in"
	)

	# Fitness ratio
	expect_error(
		plot_fitness_ratio(fitness_data, var_names = c(strains,
			# initial_fraction_A = "initial_fraction_A",
			fitness_ratio_A_B = "fitness_ratio_A_B"
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_fitness_ratio(fitness_data, mix_scale = "ratio",
			var_names = c(strains,
				# initial_ratio_A_B = "initial_ratio_A_B",
				fitness_ratio_A_B = "fitness_ratio_A_B"
			)
		),
		regexp = "not found in"
	)
	expect_error(
		plot_fitness_ratio(fitness_data, var_names = c(strains,
			# initial_fraction_A = "initial_fraction_A",
			fitness_ratio_A_B = "fitness_ratio_A_B"
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_fitness_ratio(fitness_data, var_names = strains),
		regexp = "not found in"
	)
})

test_that("plot functions report missing data columns", {
	# Compare fitness measures
	expect_error(
		plot_mix_fitness(var_names = fitness_vars_default(), data = data.frame(
			# initial_fraction_A = 0.5,
			initial_ratio_A_B = 1,
			fitness_A = 5,
			fitness_B = 10,
			fitness_total = 10,
			fitness_ratio_A_B = 10
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_mix_fitness(var_names = fitness_vars_default(), data = data.frame(
			initial_fraction_A = 0.5,
			# initial_ratio_A_B = 1,
			fitness_A = 5,
			fitness_B = 10,
			fitness_total = 10,
			fitness_ratio_A_B = 10
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_mix_fitness(var_names = fitness_vars_default(), data = data.frame(
			initial_fraction_A = 0.5,
			initial_ratio_A_B = 1,
			# fitness_A = 5,
			fitness_B = 10,
			fitness_total = 10,
			fitness_ratio_A_B = 10
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_mix_fitness(var_names = fitness_vars_default(), data = data.frame(
			initial_fraction_A = 0.5,
			initial_ratio_A_B = 1,
			fitness_A = 5,
			# fitness_B = 10,
			fitness_total = 10,
			fitness_ratio_A_B = 10
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_mix_fitness(var_names = fitness_vars_default(), data = data.frame(
			initial_fraction_A = 0.5,
			initial_ratio_A_B = 1,
			fitness_A = 5,
			fitness_B = 10,
			# fitness_total = 10,
			fitness_ratio_A_B = 10
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_mix_fitness(var_names = fitness_vars_default(), data = data.frame(
			initial_fraction_A = 0.5,
			initial_ratio_A_B = 1,
			fitness_A = 5,
			fitness_B = 10,
			fitness_total = 10
			# fitness_ratio_A_B = 10
		)),
		regexp = "not found in"
	)
	expect_error(
		plot_mix_fitness(var_names = fitness_vars_default(), data = data.frame()),
		regexp = "not found in"
	)

	# Strain fitness
	expect_error(
		plot_strain_fitness(
			data.frame(fitness_A = 5, fitness_B = 10),
			var_names = fitness_vars_default()
		),
		regexp = "not found in"
	)
	expect_error(
		plot_strain_fitness(
			data.frame(fitness_A = 5, fitness_B = 10),
			var_names = fitness_vars_default(),
			mix_scale = "ratio"
		),
		regexp = "not found in"
	)
	expect_error(
		plot_strain_fitness(
			data.frame(fitness_B = 10, initial_fraction_A = 0.5),
			var_names = fitness_vars_default()
		),
		regexp = "not found in"
	)
	expect_error(
		plot_strain_fitness(
			data.frame(fitness_A = 5, initial_fraction_A = 0.5),
			var_names = fitness_vars_default()
		),
		regexp = "not found in"
	)
	expect_error(
		plot_strain_fitness(data.frame(), var_names = fitness_vars_default()),
		regexp = "not found in"
	)

	# Total fitness
	expect_error(
		plot_total_fitness(
			data.frame(fitness_total = 10),
			var_names = fitness_vars_default()
		),
		regexp = "not found in"
	)
	expect_error(
		plot_total_fitness(
			data.frame(fitness_total = 10),
			var_names = fitness_vars_default(),
			mix_scale = "ratio"
		),
		regexp = "not found in"
	)
	expect_error(
		plot_total_fitness(
			data.frame(initial_fraction_A = 0.5),
			var_names = fitness_vars_default()
		),
		regexp = "not found in"
	)
	expect_error(
		plot_total_fitness(data.frame(), var_names = fitness_vars_default()),
		regexp = "not found in"
	)

	# Fitness ratio
	expect_error(
		plot_fitness_ratio(
			data.frame(fitness_ratio_A_B = 5),
			var_names = fitness_vars_default()
		),
		regexp = "not found in"
	)
	expect_error(
		plot_fitness_ratio(
			data.frame(fitness_ratio_A_B = 0.5),
			var_names = fitness_vars_default(),
			mix_scale = "ratio"
		),
		regexp = "not found in"
	)
	expect_error(
		plot_fitness_ratio(
			data.frame(initial_fraction_A = 0.5),
			var_names = fitness_vars_default()
		),
		regexp = "not found in"
	)
	expect_error(
		plot_fitness_ratio(
			data.frame(),
			var_names = fitness_vars_default()
		),
		regexp = "not found in"
	)
})

test_that("plot functions warn about nonsensical fitness values < 0", {
	var_names <- fitness_vars_default()
	names(var_names) <- fitness_vars_default()
	expect_warning(regexp = "biologically meaningful", {
		plot_mix_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1,
			initial_ratio_A_B = 0.1,
			fitness_A = -2,
			fitness_B = 1,
			fitness_total = 1,
			fitness_ratio_A_B = 1
		))
	})
	expect_warning(regexp = "biologically meaningful", {
		plot_mix_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1,
			initial_ratio_A_B = 0.1,
			fitness_A = 1,
			fitness_B = -2,
			fitness_total = 1,
			fitness_ratio_A_B = 1
		))
	})
	expect_warning(regexp = "biologically meaningful", {
		plot_mix_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1,
			initial_ratio_A_B = 0.1,
			fitness_A = 1,
			fitness_B = 1,
			fitness_total = -2,
			fitness_ratio_A_B = 1
		))
	})
	expect_warning(regexp = "biologically meaningful", {
		plot_mix_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1,
			initial_ratio_A_B = 0.1,
			fitness_A = 1,
			fitness_B = 1,
			fitness_total = 1,
			fitness_ratio_A_B = -2
		))
	})
	expect_warning(regexp = "biologically meaningful", {
		plot_strain_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1, fitness_A = -2, fitness_B = 1
		))
	})
	expect_warning(regexp = "biologically meaningful", {
		plot_strain_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1, fitness_A = 1, fitness_B = -2
		))
	})
	expect_warning(regexp = "biologically meaningful", {
		plot_total_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1, fitness_total = -2
		))
	})
	expect_warning(regexp = "biologically meaningful", {
		plot_fitness_ratio(var_names = var_names, data.frame(
			initial_fraction_A = 0.1, fitness_ratio_A_B = -2
		))
	})
})

test_that("plot functions warn about fitness zeros", {
	var_names <- fitness_vars_default()
	names(var_names) <- fitness_vars_default()
	expect_warning(regexp = "undefined on log scale", {
		plot_mix_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1,
			initial_ratio_A_B = 0.1,
			fitness_A = 0,
			fitness_B = 1,
			fitness_total = 1,
			fitness_ratio_A_B = 1
		))
	})
	expect_warning(regexp = "undefined on log scale", {
		plot_mix_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1,
			initial_ratio_A_B = 0.1,
			fitness_A = 1,
			fitness_B = 0,
			fitness_total = 1,
			fitness_ratio_A_B = 1
		))
	})
	expect_warning(regexp = "undefined on log scale", {
		plot_mix_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1,
			initial_ratio_A_B = 0.1,
			fitness_A = 1,
			fitness_B = 1,
			fitness_total = 0,
			fitness_ratio_A_B = 1
		))
	})
	expect_warning(regexp = "undefined on log scale", {
		plot_mix_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1,
			initial_ratio_A_B = 0.1,
			fitness_A = 1,
			fitness_B = 1,
			fitness_total = 1,
			fitness_ratio_A_B = 0
		))
	})
	expect_warning(regexp = "undefined on log scale", {
		plot_strain_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1, fitness_A = 0, fitness_B = 1
		))
	})
	expect_warning(regexp = "undefined on log scale", {
		plot_strain_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1, fitness_A = 1, fitness_B = 0
		))
	})
	expect_warning(regexp = "undefined on log scale", {
		plot_total_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1, fitness_total = 0
		))
	})
	expect_warning(regexp = "undefined on log scale", {
		plot_fitness_ratio(var_names = var_names, data.frame(
			initial_fraction_A = 0.1, fitness_ratio_A_B = 0
		))
	})
})

test_that("plot functions warn about infinite fitness values", {
	var_names <- fitness_vars_default()
	names(var_names) <- fitness_vars_default()
	expect_warning(regexp = "infinite", {
		plot_mix_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1,
			initial_ratio_A_B = 0.1,
			fitness_A = Inf,
			fitness_B = 1,
			fitness_total = 1,
			fitness_ratio_A_B = 1
		))
	})
	expect_warning(regexp = "infinite", {
		plot_mix_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1,
			initial_ratio_A_B = 0.1,
			fitness_A = 1,
			fitness_B = Inf,
			fitness_total = 1,
			fitness_ratio_A_B = 1
		))
	})
	expect_warning(regexp = "infinite", {
		plot_mix_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1,
			initial_ratio_A_B = 0.1,
			fitness_A = 1,
			fitness_B = 1,
			fitness_total = Inf,
			fitness_ratio_A_B = 1
		))
	})
	expect_warning(regexp = "infinite", {
		plot_mix_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1,
			initial_ratio_A_B = 0.1,
			fitness_A = 1,
			fitness_B = 1,
			fitness_total = 1,
			fitness_ratio_A_B = Inf
		))
	})
	expect_warning(regexp = "infinite", {
		plot_strain_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1, fitness_A = Inf, fitness_B = 1
		))
	})
	expect_warning(regexp = "infinite", {
		plot_strain_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1, fitness_A = 1, fitness_B = Inf
		))
	})
	expect_warning(regexp = "infinite", {
		plot_total_fitness(var_names = var_names, data.frame(
			initial_fraction_A = 0.1, fitness_total = Inf
		))
	})
	expect_warning(regexp = "infinite", {
		plot_fitness_ratio(var_names = var_names, data.frame(
			initial_fraction_A = 0.1, fitness_ratio_A_B = Inf
		))
	})
})

	# Warn about values not biologically meaningful
	# TODO: Mix ratio < 0
	# TODO: Mix fraction not in [0, 1]
	# Message about values undefined on log scale -- rlang::inform()
	# TODO: Mix ratio 0 & Inf


# Plot customization -----------------------------------------------------------

test_that("plot functions accept expression() axis labels", {
	fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
	label <- expression("axis label")
	expect_no_error({
		plot_strain_fitness(fitness_myxo, xlab = label, ylab = label)
		plot_total_fitness(fitness_myxo, xlab = label, ylab = label)
		plot_fitness_ratio(fitness_myxo, xlab = label, ylab = label)
	})
})

test_that("plot functions accept point args", {
	fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
	color <- c("black", "grey55", "grey35")
	fill <- c("grey45", "white", "grey75")
	shape <- 23
	size <- 2
	expect_no_error({
		plot_mix_fitness(
			fitness_myxo, color = color, fill = fill, shape = shape, size = size
		)
		plot_strain_fitness(
			fitness_myxo, color = color, fill = fill, shape = shape, size = size
		)
		plot_total_fitness(
			fitness_myxo, color = color, fill = fill, shape = shape, size = size
		)
		plot_fitness_ratio(
			fitness_myxo, color = color, fill = fill, shape = shape, size = size
		)
	})
})

