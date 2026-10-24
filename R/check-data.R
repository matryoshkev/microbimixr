# Check abundance data =========================================================

check_data_names <- function(var_names) {
	# Require var_names
	if (missing(var_names) || is.null(var_names)) {
		rlang::abort(
			"argument var_names is missing, with no default",
			call = call("calculate_mix_fitness")
		)
	}

	# Require var_names be character vector or list
	if (!(is.character(var_names) || is.list(var_names))) {
		rlang::abort(
			"var_names must be a named character vector or list",
			call = call("calculate_mix_fitness")
		)
	}

	check_data_sufficient(var_names, "initial")
	check_data_sufficient(var_names, "final")
	check_strain_names(var_names)
}

# Check if var_names has enough to calculate population state
check_data_sufficient <- function(var_names, time_point) {
	time_point <- rlang::arg_match(time_point, c("initial", "final"))
	possible <- vars_possible()[grepl(time_point, vars_possible())]
	provided <- possible[utils::hasName(var_names, possible)]
	if (length(provided) < 2) {
		rlang::abort(
			paste(
				"Too few data columns listed in var_names to calculate",
				time_point, "population state"
			),
			call = call("calculate_mix_fitness"),
			body = paste("* Variables listed:", provided)
		)
	}
}

# Require strain names
check_strain_names <- function(var_names) {
	for (name_var in c("name_A", "name_B")) {
		if (!utils::hasName(var_names, name_var)) {
			rlang::abort(
				paste0(name_var, " not found in var_names"),
				call = call("calculate_mix_fitness")
			)
	  }
		if (!is.character(var_names[[name_var]])) {
			rlang::abort(
				paste0(name_var, " in var_names must be a character string"),
				call = call("calculate_mix_fitness")
			)
		}
	}
}

# Warn if any abundance data are not biologically meaningful
check_data_values <- function(data, var_names) {
	var_names <- as.list(var_names)

	# Counts and densities
	count_vars <- vars_possible()[grepl("number", vars_possible())]
	for (count_var in count_vars) check_counts(data, var_names[[count_var]])

	# Fractions/proportions/frequencies
	freq_vars <- vars_possible()[grepl("fraction", vars_possible())]
	for (freq_var in freq_vars) check_fractions(data, var_names[[freq_var]])

	# Strain vs total count/density
	for (strain_var in c("initial_number_A", "initial_number_B")) {
			check_differences(
				data, var_names[[strain_var]], var_names[["initial_number_total"]]
			)
	}
	for (strain_var in c("final_number_A", "final_number_B")) {
			check_differences(
				data, var_names[[strain_var]], var_names[["final_number_total"]]
			)
	}
}

# Warn if any count/density data not biologically meaningful
check_counts <- function(data, var_name) {
	if (is.null(var_name)) return()
	if (any(data[[var_name]] < 0, na.rm = TRUE)) {
		rlang::warn(
			paste("Some", var_name, "values < 0", "-- not biologically meaningful"),
			call = call("calculate_mix_fitness")
		)
	}
}

# Warn if any fraction/frequency data not biologically meaningful
check_fractions <- function(data, var_name) {
	if (is.null(var_name)) return()
	if (any(c(data[[var_name]] < 0, data[[var_name]] > 1), na.rm = TRUE)) {
		rlang::warn(
			paste(
				"Some", var_name,
				"values not in range [0, 1] -- not biologically meaningful"
			),
			call = call("calculate_mix_fitness")
		)
	}
}

# Warn if strain count/density > total count/density
check_differences <- function(data, strain_var, total_var) {
	if (is.null(strain_var) || is.null(total_var)) return()
	if (any(c(data[[strain_var]] > data[[total_var]]), na.rm = TRUE)) {
		rlang::warn(
			paste(
				"Some", strain_var, "values >", total_var,
				"-- not biologically meaningful"
			),
			call = call("calculate_mix_fitness")
		)
	}
}
