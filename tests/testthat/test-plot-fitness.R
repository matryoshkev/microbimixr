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

test_that("lengthen_strain_fitness() works", {
	data <- data.frame(
		initial_fraction_A = c(0, 0.5, 1),
		fitness_A = c(NA, 150, 100),
		fitness_B = c(100, 50, NA)
	)
	data$name_A <- "Evolved"
	data$name_B <- "Ancestral"
	data$exptl_block <- "A"
	expect_no_error(lengthen_strain_fitness(data))
})

