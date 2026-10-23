# Basic plotting ---------------------------------------------------------------

test_that("plot functions run defaults", {
	fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
	expect_no_error({
		plot_mix_fitness(fitness_myxo)
		plot_strain_fitness(fitness_myxo)
		plot_total_fitness(fitness_myxo)
		plot_fitness_ratio(fitness_myxo)
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

test_that("plot functions don't require unused mix_scale data", {
	data <- data.frame(
		initial_fraction_A = 0.5,
		initial_ratio_A_B = 1,
		fitness_A	= 10,
		fitness_B	= 20,
		fitness_total = 15,
		fitness_ratio_A_B = 10/20,
		name_A = "A",
		name_B = "B"
	)
	data_no_fraction <- data[names(data) != "initial_fraction_A"]
	data_no_ratio <- data[names(data) != "initial_ratio_A_B"]
	expect_no_error({
		plot_mix_fitness(data_no_fraction, mix_scale = "ratio")
		plot_strain_fitness(data_no_fraction, mix_scale = "ratio")
		plot_total_fitness(data_no_fraction, mix_scale = "ratio")
		plot_fitness_ratio(data_no_fraction, mix_scale = "ratio")
	})
	expect_no_error({
		plot_mix_fitness(data_no_ratio, mix_scale = "fraction")
		plot_strain_fitness(data_no_ratio, mix_scale = "fraction")
		plot_total_fitness(data_no_ratio, mix_scale = "fraction")
		plot_fitness_ratio(data_no_ratio, mix_scale = "fraction")
	})
})


# Input validation -------------------------------------------------------------
# with informative errors, warnings, and messages

test_that("plot functions report strain names missing from data", {
	data <- data.frame(
		name_A = "A",
		name_B = "B",
		initial_fraction_A = 0.5,
		initial_ratio_A_B = 1,
		fitness_A = 10,
		fitness_B = 20,
		fitness_total = 15,
		fitness_ratio_A_B = 10/20
	)

	# Strain A
	data_no_A <- data[names(data) != "name_A"]
	expect_error(regexp = "not found in data", plot_mix_fitness(data_no_A))
	expect_error(regexp = "not found in data", plot_strain_fitness(data_no_A))
	expect_error(regexp = "not found in data", plot_total_fitness(data_no_A))
	expect_error(regexp = "not found in data", plot_fitness_ratio(data_no_A))

	# Strain B
	data_no_B <- data[names(data) != "name_B"]
	expect_error(regexp = "not found in data", plot_mix_fitness(data_no_B))
	expect_error(regexp = "not found in data", plot_strain_fitness(data_no_B))
	expect_error(regexp = "not found in data", plot_total_fitness(data_no_B))
	expect_error(regexp = "not found in data", plot_fitness_ratio(data_no_B))
})

test_that("plot functions report missing data columns", {
	data <- data.frame(
		name_A = "A",
		name_B = "B",
		initial_fraction_A = 0.5,
		initial_ratio_A_B = 1,
		fitness_A = 10,
		fitness_B = 20,
		fitness_total = 15,
		fitness_ratio_A_B = 10/20
	)

	# Comparing fitness measures
	for (i in 3:length(data)) {
		expect_error(regexp = "not found in data",
			plot_mix_fitness(data[-i])
		)
	}

	# Strain fitness
	for (i in c("initial_fraction_A", "fitness_A", "fitness_B")) {
		expect_error(regexp = "not found in data",
			plot_strain_fitness(data[names(data) != i])
		)
	}
	expect_error(regexp = "not found in data",
		plot_strain_fitness(
			data[names(data) != "initial_ratio_A_B"],
			mix_scale = "ratio"
		)
	)

	# Total fitness
	for (i in c("initial_fraction_A", "fitness_total")) {
		expect_error(regexp = "not found in data",
			plot_total_fitness(data[names(data) != i])
		)
	}
	expect_error(regexp = "not found in data",
		plot_total_fitness(
			data[names(data) != "initial_ratio_A_B"],
			mix_scale = "ratio"
		)
	)

	# Fitness ratio
	for (i in c("initial_fraction_A", "fitness_ratio_A_B")) {
		expect_error(regexp = "not found in data",
			plot_fitness_ratio(data[names(data) != i])
		)
	}
	expect_error(regexp = "not found in data",
		plot_fitness_ratio(
			data[names(data) != "initial_ratio_A_B"],
			mix_scale = "ratio"
		)
	)
})

test_that("plot functions warn about nonsensical strain frequencies", {
	good_data <- data.frame(
		initial_fraction_A = 0.5,
		initial_ratio_A_B = 1,
		fitness_A = 1,
		fitness_B = 1,
		fitness_total = 1,
		fitness_ratio_A_B = 1,
		name_A = "A",
		name_B = "B"
	)

	# Initial fraction not in [0, 1]
	for (bad_fraction in c(-0.1, 1.1)) {
		suspect_data <- good_data
		suspect_data[["initial_fraction_A"]] <- bad_fraction
		expect_warning(regexp = "biologically meaningful", {
			expect_warning(regexp = "biologically meaningful", {
				plot_mix_fitness(suspect_data)
			})
		})  # 2 warnings: plot_mix_fitness() & plot_fitness_ratio()
		expect_warning(regexp = "biologically meaningful", {
			plot_strain_fitness(suspect_data)
		})
		expect_warning(regexp = "biologically meaningful", {
			plot_total_fitness(suspect_data)
		})
		expect_warning(regexp = "biologically meaningful", {
			plot_fitness_ratio(suspect_data)
		})
	}

	# Initial ratio < 0
	suspect_data <- data.frame(
		initial_fraction_A = c(0.5, 0.5),
		initial_ratio_A_B = c(1, -0.1),
		fitness_A = c(1, 1),
		fitness_B = c(1, 1),
		fitness_total = c(1, 1),
		fitness_ratio_A_B = c(1, 1),
		name_A = "A",
		name_B = "B"
	)
	expect_warning(regexp = "biologically meaningful", {
		plot_mix_fitness(suspect_data, mix_scale = "ratio")
	})  # 1 warning because plot_mix_fitness() replaces with NA
	expect_warning(regexp = "biologically meaningful", {
		plot_strain_fitness(suspect_data, mix_scale = "ratio")
	})
	expect_warning(regexp = "biologically meaningful", {
		plot_total_fitness(suspect_data, mix_scale = "ratio")
	})
	expect_warning(regexp = "biologically meaningful", {
		plot_fitness_ratio(suspect_data, mix_scale = "ratio")
	})
})

test_that("plot functions warn about nonsensical fitness values", {
	# Wrightian fitness defined over [0, Inf]
	good_data <- data.frame(
		initial_fraction_A = 0.5,
		initial_ratio_A_B = 0.5,
		fitness_A = 1,
		fitness_B = 1,
		fitness_total = 1,
		fitness_ratio_A_B = 1,
		name_A = "A",
		name_B = "B"
	)
	for (i in c("fitness_A", "fitness_B", "fitness_total", "fitness_ratio_A_B")) {
		bad_data <- good_data
		bad_data[[i]] <- bad_data[[i]] * -1
		expect_warning(regexp = "biologically meaningful", {
			plot_mix_fitness(bad_data)
		})
	}
	expect_warning(regexp = "biologically meaningful", {
		plot_strain_fitness(data.frame(
			name_A = "A", name_B = "B",
			initial_fraction_A = 0.5, fitness_A = -1, fitness_B = 1
		))
	})
	expect_warning(regexp = "biologically meaningful", {
		plot_strain_fitness(data.frame(
			name_A = "A", name_B = "B",
			initial_fraction_A = 0.5, fitness_A = 1, fitness_B = -1
		))
	})
	expect_warning(regexp = "biologically meaningful", {
		plot_total_fitness(data.frame(
			name_A = "A", name_B = "B",
			initial_fraction_A = 0.5, fitness_total = -1
		))
	})
	expect_warning(regexp = "biologically meaningful", {
		plot_fitness_ratio(data.frame(
			name_A = "A", name_B = "B",
			initial_fraction_A = 0.5, fitness_ratio_A_B = -1
		))
	})
})


# Unplottable data -------------------------------------------------------------
# with informative errors, warnings, and messages

test_that("plot functions warn about fitness zeros", {
	fitness <- data.frame(
		initial_fraction_A = 0.5,
		initial_ratio_A_B = 0.5,
		fitness_A = 1,
		fitness_B = 1,
		fitness_total = 1,
		fitness_ratio_A_B = 1,
		name_A = "A",
		name_B = "B"
	)
	for (i in c("fitness_A", "fitness_B", "fitness_total", "fitness_ratio_A_B")) {
		fitness_zero <- fitness
		fitness_zero[[i]] <- 0
		expect_warning(regexp = "undefined on log scale", {
			plot_mix_fitness(fitness_zero)
		})
	}
	expect_warning(regexp = "undefined on log scale", {
		plot_strain_fitness(data.frame(
			name_A = "A", name_B = "B",
			initial_fraction_A = 0.5, fitness_A = 0, fitness_B = 1
		))
	})
	expect_warning(regexp = "undefined on log scale", {
		plot_strain_fitness(data.frame(
			name_A = "A", name_B = "B",
			initial_fraction_A = 0.5, fitness_A = 1, fitness_B = 0
		))
	})
	expect_warning(regexp = "undefined on log scale", {
		plot_total_fitness(data.frame(
			name_A = "A", name_B = "B",
			initial_fraction_A = 0.5, fitness_total = 0
		))
	})
	expect_warning(regexp = "undefined on log scale", {
		plot_fitness_ratio(data.frame(
			name_A = "A", name_B = "B",
			initial_fraction_A = 0.5, fitness_ratio_A_B = 0
		))
	})
})

test_that("plot functions warn about infinite fitness values", {
	fitness <- data.frame(
		initial_fraction_A = 0.5,
		initial_ratio_A_B = 0.5,
		fitness_A = 1,
		fitness_B = 1,
		fitness_total = 1,
		fitness_ratio_A_B = 1,
		name_A = "A",
		name_B = "B"
	)
	for (i in c("fitness_A", "fitness_B", "fitness_total", "fitness_ratio_A_B")) {
		fitness_inf <- fitness
		fitness_inf[[i]] <- Inf
		expect_warning(regexp = "infinite", {
			plot_mix_fitness(fitness_inf)
		})
	}
	expect_warning(regexp = "infinite", {
		plot_strain_fitness(data.frame(
			name_A = "A", name_B = "B",
			initial_fraction_A = 0.5, fitness_A = Inf, fitness_B = 1
		))
	})
	expect_warning(regexp = "infinite", {
		plot_strain_fitness(data.frame(
			name_A = "A", name_B = "B",
			initial_fraction_A = 0.5, fitness_A = 1, fitness_B = Inf
		))
	})
	expect_warning(regexp = "infinite", {
		plot_total_fitness(data.frame(
			name_A = "A", name_B = "B",
			initial_fraction_A = 0.5, fitness_total = Inf
		))
	})
	expect_warning(regexp = "infinite", {
		plot_fitness_ratio(data.frame(
			name_A = "A", name_B = "B",
			initial_fraction_A = 0.5, fitness_ratio_A_B = Inf
		))
	})
})

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

