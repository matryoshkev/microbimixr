test_that("plot functions run defaults", {
	fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
	expect_no_error(plot_mix_fitness(fitness_myxo))
	expect_no_error(plot_strain_fitness(fitness_myxo))
	expect_no_error(plot_total_group_fitness(fitness_myxo))
	expect_no_error(plot_within_group_fitness(fitness_myxo))
})

test_that("plot functions accept mixing ratio x-axis", {
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

test_that("plot functions accept expression() axis labels", {
	fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
	label <- expression(label)
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

