# Check fitness data to plot ===================================================

check_fitness_data <- function(data, vars, mix_scale, caller) {
	data |>
	check_fitness_columns(vars, mix_scale, caller) |>
	check_mix_values(vars, mix_scale, caller) |>
	check_fitness_values(vars, mix_scale, caller)
}

# Check variables we want to plot are columns in data
check_fitness_columns <- function(data, vars, mix_scale, caller) {
	if ("fraction" %in% mix_scale) {vars <- c(vars, "initial_fraction_A")}
	if ("ratio" %in% mix_scale) {vars <- c(vars, "initial_ratio_A_B")}
	missing <- NULL
	for (var in vars) {
		if (!utils::hasName(data, var)) {missing <- c(missing, var)}
	}
	if (!is.null(missing)) {
		rlang::abort(
			paste0("Column `", missing, "` not found in data"), call = call(caller)
		)
	}
	data
}

# Check data for nonbiological initial frequencies
check_mix_values <- function (data, vars, mix_scale, caller) {
	# Initial fraction not in [0, 1]
	if ("fraction" %in% mix_scale) {
		mix_var <- "initial_fraction_A"
		if (any(!is.na(data[[mix_var]]) & data[[mix_var]] < 0)) {
			rlang::warn(
				paste("Some", mix_var, "values < 0 -- not biologically meaningful"),
				call = call(caller)
			)
		}
		if (any(!is.na(data[[mix_var]]) & data[[mix_var]] > 1)) {
			rlang::warn(
				paste("Some", mix_var, "values > 1 -- not biologically meaningful"),
				call = call(caller)
			)
		}
		# Keep these values because they are plottable
	}
	# Initial ratio < 0
	if ("ratio" %in% mix_scale) {
		mix_var <- "initial_ratio_A_B"
		if (any(!is.na(data[[mix_var]]) & data[[mix_var]] < 0)) {
			data[!is.na(data[[mix_var]]) & data[[mix_var]] < 0, mix_var] <- NA
			rlang::warn(
				paste("Some", mix_var, "values < 0 -- not biologically meaningful"),
				call = call(caller)
			)
		}
	}
	data
}

# Check for unplottable fitness values & replace with NA
check_fitness_values <- function(data, vars, mix_scale = NULL, caller) {
	# Wrightian fitness measures range from zero to infinity:
	#   fitness_A          [0, Inf)
	#   fitness_B          [0, Inf)
	#   fitness_total      [0, Inf)
	#   fitness_ratio_A_B  [0, Inf]
	for (var in vars) {
		# Fitness < 0 not biologically meaningful
		if (any(!is.na(data[[var]]) & data[[var]] < 0)) {
			data[!is.na(data[[var]]) & data[[var]] < 0, var] <- NA
			rlang::warn(
				paste("Some", var, "values < 0 -- not biologically meaningful"),
				call = call(caller)
			)
		}

		# Fitness zeros undefined on log scale
		if (any(data[[var]] == 0, na.rm = TRUE)) {
			data[data[[var]] == 0, var] <- NA
			rlang::warn(
				paste("Some", var, "values = 0 -- undefined on log scale"),
				call = call(caller)
			)
		}

		# Fitness Inf not plotted
		if (any(is.infinite(data[[var]]), na.rm = TRUE)) {
			data[is.infinite(data[[var]]), var] <- NA
			rlang::warn(
				paste("Some", var, "values infinite, not plotted"),
				call = call(caller)
			)
		}
	}
	data
}

# Check that strain names are a column in the fitness data frame
check_fitness_strains <- function(data, caller) {
	if (!utils::hasName(data, "name_A")) {
		rlang::abort("Column `name_A` not found in data", call = call(caller))
	}
	if (!utils::hasName(data, "name_B")) {
		rlang::abort("Column `name_B` not found in data", call = call(caller))
	}
}

