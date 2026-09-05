test_that("calculate_mix_fitness() works with included datasets", {
	expect_no_error(
		calculate_mix_fitness(data_smith_2010, var_names = c(
			initial_number_A = "initial_cells_evolved",
			initial_number_B = "initial_cells_ancestral",
			final_number_A = "final_spores_evolved",
			final_number_B = "final_spores_ancestral",
			name_A = "GVB206.3",
			name_B = "GJV10"
		))
	)
	expect_warning(expect_warning(
		# Two warnings: nonbio values for initial & final fraction
		calculate_mix_fitness(data_Yurtsev_2013, var_names = c(
			initial_number_total = "OD_initial",
			initial_fraction_A = "fraction_resistant_initial",
			final_number_total = "OD_final",
			final_fraction_A = "fraction_resistant_final",
			name_A = "AmpR",
			name_B = "AmpS"
		))
	))
	expect_no_error(
		calculate_mix_fitness(data_Madgwick_2018, var_names = c(
			initial_number_total = "input_cells_total",
			initial_fraction_A = "input_freq_i",
			final_number_total = "spores_total",
			final_fraction_A = "output_freq_i",
			name_A = "strain_i",
			name_B = "strain_j"
		))
	)
})

# TODO:
test_that("calculate_mix_fitness() can use all valid data combos", {
	my_data <- data.frame(
		num_A_init = 1,
		num_B_init = 1,
		num_total_init = 2,
		freq_A_init = 1/2,
		freq_B_init = 1/2,
		num_A_final = 2,
		num_B_final = 2,
		num_total_final = 4,
		freq_A_final = 2/4,
		freq_B_final = 2/4
	)
	expect_no_error(
		calculate_mix_fitness(my_data, var_names = c(
			initial_number_A = "num_A_init",
			initial_number_B = "num_B_init",
			final_number_A = "num_A_final",
			final_number_B = "num_B_final",
			name_A = "A",
			name_B = "B"
		))
	)
	expect_no_error(
		calculate_mix_fitness(my_data, var_names = c(
			initial_number_total = "num_total_init",
			initial_fraction_A = "freq_A_init",
			final_number_total = "num_total_final",
			final_fraction_A = "freq_A_final",
			name_A = "A",
			name_B = "B"
		))
	)
	expect_no_error(
		calculate_mix_fitness(my_data, var_names = c(
			initial_number_total = "num_total_init",
			initial_fraction_B = "freq_B_init",
			final_number_total = "num_total_final",
			final_fraction_B = "freq_B_final",
			name_A = "A",
			name_B = "B"
		))
	)
	expect_no_error(
		calculate_mix_fitness(my_data, var_names = c(
			initial_number_A = "num_A_init",
			initial_number_total = "num_total_init",
			final_number_A = "num_A_final",
			final_number_total = "num_total_final",
			name_A = "A",
			name_B = "B"
		))
	)
	expect_no_error(
		calculate_mix_fitness(my_data, var_names = c(
			initial_number_B = "num_B_init",
			initial_number_total = "num_total_init",
			final_number_B = "num_B_final",
			final_number_total = "num_total_final",
			name_A = "A",
			name_B = "B"
		))
	)
})

# TODO:
# test_that("calculate_mix_fitness() warns of nonbiological data values", {
# })

# TODO: test that calculate_mix_fitness() errors if data is insufficient

test_that("calculate_mix_fitness() can use specified strain names", {
	expect_no_error(
		data.frame(init_A = 1, init_B = 2, final_A = 3, final_B = 4) |>
		calculate_mix_fitness(var_names = c(
			initial_number_A = "init_A",
			initial_number_B = "init_B",
			final_number_A = "final_A",
			final_number_B = "final_B",
			name_A = "My strain A",
			name_B = "My strain B"
		))
	)
})

test_that("calculate_mix_fitness() can use strain names from data", {
	expect_no_error(
		data.frame(
			init_A = 1, init_B = 2, final_A = 3, final_B = 4,
			strain_A = "My strain A", strain_B = "My strain B"
		) |>
		calculate_mix_fitness(var_names = c(
			initial_number_A = "init_A",
			initial_number_B = "init_B",
			final_number_A = "final_A",
			final_number_B = "final_B",
			name_A = "strain_A",
			name_B = "strain_B"
		))
	)
})

# TODO: test that calculate_mix_fitness() errors if strain names missing or invalid

