test_that("plot functions run defaults without warning", {
	fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
	expect_no_warning(plot_mix_fitness(fitness_myxo))
	expect_no_warning(plot_strain_fitness(fitness_myxo))
	expect_no_warning(plot_total_group_fitness(fitness_myxo))
	expect_no_warning(plot_within_group_fitness(fitness_myxo))
})

test_that("plot functions accept expression() axis labels", {
	fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
	expect_no_warning(plot_strain_fitness(
		fitness_myxo, xlab = expression(x), ylab = expression(y)
	))
	expect_no_warning(plot_total_group_fitness(
		fitness_myxo, xlab = expression(x), ylab = expression(y)
	))
	expect_no_warning(plot_within_group_fitness(
		fitness_myxo, xlab = expression(x), ylab = expression(y)
	))
})
