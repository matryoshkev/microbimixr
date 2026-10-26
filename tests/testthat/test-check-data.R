test_that("calculate_mix_fitness() warns if `data` is missing or wrong type", {
	my_vars <- vars_possible()
	names(my_vars) <- vars_possible()
	expect_error(regexp = "missing", calculate_mix_fitness(var_names = my_vars))
	expect_error(regexp = "missing",
		calculate_mix_fitness(data = NULL, var_names = my_vars)
	)
	expect_error(regexp = "data frame", calculate_mix_fitness(my_vars))
	expect_error(regexp = "data frame",
		calculate_mix_fitness(1, var_names = my_vars)
	)
})

test_that("calculate_mix_fitness() gives informative var_names errors", {
	data <- data.frame(init_A = 1, init_B = 2, final_A = 3, final_B = 4)
	my_vars <- c(
			initial_number_A = "init_A", initial_number_B = "init_B",
			final_number_A = "final_A", final_number_B = "final_B",
			name_A = "A", name_B = "B"
	)
	expect_error(regexp = "missing", calculate_mix_fitness(data))
	expect_error(regexp = "vector or list",
		calculate_mix_fitness(data, var_names = 1)
	)
	expect_error(regexp = "not found",
		calculate_mix_fitness(data, my_vars[names(my_vars) != "name_A"])
	)
	expect_error(regexp = "not found",
		calculate_mix_fitness(data, my_vars[names(my_vars) != "name_B"])
	)
	expect_error(regexp = "calculate initial",
		calculate_mix_fitness(data, my_vars[names(my_vars) != "initial_number_A"])
	)
	expect_error(regexp = "calculate final",
		calculate_mix_fitness(data, my_vars[names(my_vars) != "final_number_A"])
	)
})

test_that("calculate_mix_fitness() warns of nonbiological data values", {
	vars <- c(
		initial_number_A = "nA_init",
		initial_number_B = "nB_init",
		initial_number_total = "N_init",
		initial_fraction_A = "qA_init",
		initial_fraction_B = "qB_init",
		final_number_A = "nA",
		final_number_B = "nB",
		final_number_total = "N",
		final_fraction_A = "qA",
		final_fraction_B = "qB",
		name_A = "name_A",
		name_B = "name_B"
	)

	# Test positive number of individuals
	expect_warning(regexp = "biologically meaningful",
		calculate_mix_fitness(var_names = vars,
			data.frame(nA_init = -2, nB_init = 1, nA = 1, nB = 1)
		)
	)
	expect_warning(regexp = "biologically meaningful",
		calculate_mix_fitness(var_names = vars,
			data.frame(nA_init = 1, nB_init = -2, nA = 1, nB = 1)
		)
	)
	expect_warning(regexp = "biologically meaningful",
		calculate_mix_fitness(var_names = vars,
			data.frame(nA_init = 1, nB_init = 1, nA = -2, nB = 1)
		)
	)
	expect_warning(regexp = "biologically meaningful",
		calculate_mix_fitness(var_names = vars,
			data.frame(nA_init = 1, nB_init = 1, nA = 1, nB = -2)
		)
	)
	expect_warning(regexp = "biologically meaningful",
		calculate_mix_fitness(var_names = vars,
			data.frame(N_init = -2, qA_init = 0.1, N = 1, qA = 0.1)
		)
	)
	expect_warning(regexp = "biologically meaningful",
		calculate_mix_fitness(var_names = vars,
			data.frame(N_init = 1, qA_init = 0.1, N = -2, qA = 0.1)
		)
	)

	# Test valid strain frequencies
	expect_warning(regexp = "biologically meaningful",
		calculate_mix_fitness(var_names = vars,
			data.frame(N_init = 1, qA_init = -0.2, N = 1, qA = 0.1)
		)
	)
	expect_warning(regexp = "biologically meaningful",
		calculate_mix_fitness(var_names = vars,
			data.frame(N_init = 1, qA_init = 0.1, N = 1, qA = -0.2)
		)
	)
	expect_warning(regexp = "biologically meaningful",
		calculate_mix_fitness(var_names = vars,
			data.frame(N_init = 1, qB_init = -0.2, N = 1, qB = 0.1)
		)
	)
	expect_warning(regexp = "biologically meaningful",
		calculate_mix_fitness(var_names = vars,
			data.frame(N_init = 1, qB_init = 0.1, N = 1, qB = -0.2)
		)
	)
	expect_warning(regexp = "biologically meaningful",
		calculate_mix_fitness(var_names = vars,
			data.frame(N_init = 1, qA_init = 2.0, N = 1, qA = 0.1)
		)
	)
	expect_warning(regexp = "biologically meaningful",
		calculate_mix_fitness(var_names = vars,
			data.frame(N_init = 1, qA_init = 0.1, N = 1, qA = 2.0)
		)
	)
	expect_warning(regexp = "biologically meaningful",
		calculate_mix_fitness(var_names = vars,
			data.frame(N_init = 1, qB_init = 2.0, N = 1, qB = 0.1)
		)
	)
	expect_warning(regexp = "biologically meaningful",
		calculate_mix_fitness(var_names = vars,
			data.frame(N_init = 1, qB_init = 0.1, N = 1, qB = 2.0)
		)
	)

	# Test more strain than total
	expect_warning(regexp = "biologically meaningful",
		calculate_mix_fitness(var_names = vars,
			data.frame(nA_init = 2, N_init = 1, nA = 1, N = 1)
		)
	)
	expect_warning(regexp = "biologically meaningful",
		calculate_mix_fitness(var_names = vars,
			data.frame(nA_init = 1, N_init = 1, nA = 2, N = 1)
		)
	)
	expect_warning(regexp = "biologically meaningful",
		calculate_mix_fitness(var_names = vars,
			data.frame(nB_init = 2, N_init = 1, nB = 1, N = 1)
		)
	)
	expect_warning(regexp = "biologically meaningful",
		calculate_mix_fitness(var_names = vars,
			data.frame(nB_init = 1, N_init = 1, nB = 2, N = 1)
		)
	)
})

# TODO:
# test_that("calculate_mix_fitness() warns if `keep` is malformed", {
# 	data <- data.frame(init_A = 1, init_B = 2, final_A = 3, final_B = 4)
# 	my_vars <- c(
# 			initial_number_A = "init_A", initial_number_B = "init_B",
# 			final_number_A = "final_A", final_number_B = "final_B",
# 			name_A = "A", name_B = "B"
# 	)
# 		calculate_mix_fitness(data, data, var_names = my_vars)
# 		calculate_mix_fitness(data, var_names = my_vars, keep = 1)
# 		calculate_mix_fitness(data, var_names = my_vars, keep = NA)
# })

