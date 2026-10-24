test_that("calculate_mix_fitness() works as expected with included datasets", {
	expect_no_error({
		data_smith_2010 |> calculate_mix_fitness(var_names = var_names_smith_2010)
		data_Madgwick_2018 |> calculate_mix_fitness(var_names = c(
			initial_number_total = "input_cells_total",
			initial_fraction_A = "input_freq_i",
			final_number_total = "spores_total",
			final_fraction_A = "output_freq_i",
			name_A = "strain_i",
			name_B = "strain_j"
		))
	})
	expect_warning(regexp = "biologically meaningful",
		expect_warning(regexp = "biologically meaningful",{
			data_Yurtsev_2013 |> calculate_mix_fitness(var_names = c(
				initial_number_total = "OD_initial",
				initial_fraction_A = "fraction_resistant_initial",
				final_number_total = "OD_final",
				final_fraction_A = "fraction_resistant_final",
				name_A = "AmpR",
				name_B = "AmpS"
			))
		}
	))
})

test_that("fitness math works with all data combos", {
	my_vars <- vars_possible()
	names(my_vars) <- vars_possible()
	fitness_target <- data.frame(
		name_A = "name_A",
		name_B = "name_B",
		initial_fraction_A = 1/4,
		initial_ratio_A_B = 1/3,
		fitness_A = 3,
		fitness_B = 5/3,
		fitness_total = 8/4,
		fitness_ratio_A_B = 3/(5/3)
	)
	expect_identical(fitness_target,
		calculate_mix_fitness(var_names = my_vars, data.frame(
			initial_number_A = 1,
			initial_number_B = 3,
			final_number_A = 3,
			final_number_B = 5
		))
	)
	expect_identical(fitness_target,
		calculate_mix_fitness(var_names = my_vars, data.frame(
			initial_number_total = 4,
			initial_fraction_A = 1/4,
			final_number_total = 8,
			final_fraction_A = 3/8
		))
	)
	expect_identical(fitness_target,
		calculate_mix_fitness(var_names = my_vars, data.frame(
			initial_number_total = 4,
			initial_fraction_B = 3/4,
			final_number_total = 8,
			final_fraction_B = 5/8
		))
	)
	expect_identical(fitness_target,
		calculate_mix_fitness(var_names = my_vars, data.frame(
			initial_number_A = 1,
			initial_number_total = 4,
			final_number_A = 3,
			final_number_total = 8
		))
	)
	expect_identical(fitness_target,
		calculate_mix_fitness(var_names = my_vars, data.frame(
			initial_number_B = 3,
			initial_number_total = 4,
			final_number_B = 5,
			final_number_total = 8
		))
	)
})

test_that("calculate_mix_fitness() can use strain names given in var_names", {
	fitness <- calculate_mix_fitness(
		data.frame(init_A = 1, init_B = 2, final_A = 3, final_B = 4),
		var_names = c(
			initial_number_A = "init_A", initial_number_B = "init_B",
			final_number_A = "final_A", final_number_B = "final_B",
			name_A = "My strain A", name_B = "My strain B"
		)
	)
	expect_equal(fitness$name_A, "My strain A")
	expect_equal(fitness$name_B, "My strain B")
})

test_that("calculate_mix_fitness() can use strain names in data", {
	fitness <- calculate_mix_fitness(
		data.frame(
			init_A = 1, init_B = 2, final_A = 3, final_B = 4,
			strain_A = "My strain A", strain_B = "My strain B"
		),
		var_names = c(
			initial_number_A = "init_A", initial_number_B = "init_B",
			final_number_A = "final_A", final_number_B = "final_B",
			name_A = "strain_A", name_B = "strain_B"
		)
	)
	expect_equal(fitness$name_A, "My strain A")
	expect_equal(fitness$name_B, "My strain B")
})
