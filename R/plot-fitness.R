# Plot fitness measures ========================================================

# These functions are meant to be as self-explanatory as possible,
# so the color/fill/etc options aren't as non-repetitive as they could be.
# Might still go for single source of truth.

#' Draw plots to compare fitness measures
#'
#' `plot_mix_fitness()` shows a diagnostic overview of various fitness effects
#' in a dataset. Draws a combined plot of strain, total group, and relative
#' within-group fitness against two measures of mix frequency.
#'
#' @param data Data frame of fitness values. Wide format: each row must contain
#'   data for two microbes in the same population. Accepts data frame
#'   extensions like `tibble`.
#' @param var_names Named character vector identifying fitness and mixing
#'   variables in `data`. If `NULL`, defaults to column names returned by
#'   [calculate_mix_fitness()]. See Details.
#' @param drop_NA Use `TRUE` to silently remove missing values.
#'   `FALSE` to warn when removing missing values.
#'
#' @details
#' Expects Wrightian fitness measures like those returned by
#' [calculate_mix_fitness()].
#'
#' `var_names` must be a named vector or list that includes the following
#' elements (shown here with default values):
#' ```
#' var_names = c(
#'   name_A = "name_A",
#'   name_B = "name_B",
#'   initial_fraction_A = "initial_fraction_A",
#'   initial_ratio_A_B = "initial_ratio_A_B",
#'   fitness_A = "fitness_A",
#'   fitness_B = "fitness_B",
#'   fitness_total = "fitness_total",
#'   fitness_ratio_A_B = "fitness_ratio_A_B"
#' )
#' ```
#'
#' @returns A ggplot object
#'
#' @seealso [calculate_mix_fitness()]
#'
#' @examples
#' library(patchwork)
#'
#' # Using data from smith et al (2010)
#' fitness_myxo <- calculate_mix_fitness(
#'   data_smith_2010,
#'   var_names = c(
#'     initial_number_A = "initial_cells_evolved",
#'     initial_number_B = "initial_cells_ancestral",
#'     final_number_A = "final_spores_evolved",
#'     final_number_B = "final_spores_ancestral",
#'     name_A = "GVB206.3",
#'     name_B = "GJV10"
#'   )
#' )
#' plot_mix_fitness(fitness_myxo)
#'
#' @export
#'
plot_mix_fitness <- function(
	data, var_names = NULL, drop_NA = TRUE
) {
	# Variable names
	if (is.null(var_names)) {var_names <- fitness_vars_default()}

	# Axis options
	ylim <- get_ylim_mix_fitness(data, var_names)

	# Make subplots
	figA <- plot_fitness_strain_total(
		data,
		var_names,
		mix_scale = "fraction",
		ylim = ylim$fitness,
		drop_NA = drop_NA
	)
	figB <- plot_within_group_fitness(
		data,
		var_names,
		mix_scale = "fraction",
		ylim = ylim$fitness_ratio,
		drop_NA = drop_NA
	)
	figC <- plot_fitness_strain_total(
		data,
		var_names,
		mix_scale = "ratio",
		ylim = ylim$fitness,
		drop_NA = drop_NA
	)
	figD <- plot_within_group_fitness(
		data,
		var_names,
		mix_scale = "ratio",
		ylim = ylim$fitness_ratio,
		drop_NA = drop_NA
	)
	fig_output <- figA + figB + figC + figD

	# Size plots for page-width figure
	fig_output <- fig_output + patchwork::plot_layout(
		widths = grid::unit(c(3.2, 1.6), "inches"),
		heights = grid::unit(1.4, "inches")
		# Units affect plotting area, not total size
	)

	suppressWarnings(print(fig_output))
}

#' Plot fitness of each strain separately
#'
#' `plot_strain_fitness()` draws a plot of absolute fitness for each of two
#' microbe strains as a function of their initial frequency
#'
#' @param data Data frame of fitness values and mix frequencies. Wide format:
#'   each row must contain data for two microbes in the same population.
#'   Accepts data frame extensions like `tibble`.
#' @param var_names Named character vector identifying fitness and mixing
#'   variables in `data`. If `NULL`, defaults to column names returned by
#'   [calculate_mix_fitness()]. See Details.
#' @param mix_scale Mixing scale for x axis. Default `"fraction"` uses initial
#'   frequency of strain A (proportion of total) from `initial_fraction_A`
#'   variable of data. `"ratio"` uses ratio of strain A to strain B (on
#'   \eqn{\log_{10}} scale) from `initial_ratio_A_B`.
#' @param xlab,ylab X and y axis labels
#' @param xlim,ylim X and y axis limits
#' @param color Point colors
#' @param fill Point fill colors. Only affects shapes 21--25.
#' @param shape Point shape
#' @param size Point size in mm
#' @param drop_NA `TRUE` to silently remove missing values.
#'   `FALSE` to warn when removing missing values.
#'
#' @details
#' Expects Wrightian fitness data like those returned by
#' [calculate_mix_fitness()].
#'
#' `var_names` must be a named vector or list that includes the following
#' elements (shown here with default values):
#' ```
#' var_names = c(
#'   name_A = "name_A",
#'   name_B = "name_B",
#'   initial_fraction_A = "initial_fraction_A",
#'   initial_ratio_A_B = "initial_ratio_A_B",
#'   fitness_A = "fitness_A",
#'   fitness_B = "fitness_B"
#' )
#' ```
#'
#' @returns
#' A ggplot object that can be further modified using the ggplot2 package
#'
#' @seealso [plot_total_group_fitness()], [plot_within_group_fitness()]
#'
#' @examples
#' fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
#' plot_strain_fitness(fitness_myxo)
#'
#' # Some plot options
#' plot_strain_fitness(
#'   fitness_myxo,
#'   xlab = "Initial frequency of GVB206.3",
#'   ylab = "Sporulation efficiency\n(spores/cell)",
#'   color = c("black", "grey40"),
#'   fill = c("grey50", "white"),
#'   shape = 23,
#'   size = 2
#' )
#'
#' @export
#'
plot_strain_fitness <- function(
	data,
	var_names = NULL,
	mix_scale = "fraction",
	xlab = NA,
	ylab = NA,
	xlim = c(NA, NA),
	ylim = c(NA, NA),
	color = c(NULL, NULL),
	fill = c(NULL, NULL),
	shape = NULL,
	size = NULL,
	drop_NA = TRUE
) {
	# Get variable and strain names
	if (is.null(var_names)) {var_names <- fitness_vars_default()}
	var_names <- as.list(var_names)
	var_names$fitness <- "fitness"
	strain_names <- get_strain_names(data, var_names)

	# Axis options
	mix_scale <- rlang::arg_match(mix_scale, c("fraction", "ratio"))
	if (missing(xlab)) {xlab <- waiver()}
	if (missing(ylab)) {ylab <- waiver()}
	if (missing(xlim)) {xlim <- NULL}
	if (missing(ylim)) {ylim <- NULL}

	# Point color and fill
	if (missing(color) | is_waiver(color)) {
		color <- c(color_strain_A(), color_strain_B())
	}
	if (missing(fill) | is_waiver(fill)) {
		fill <- c(fill_strain_A(), fill_strain_B())
	}

	# Other point options
	point_args <- list(na.rm = drop_NA)
	if (!missing(shape) & !is_waiver(shape)) {
		point_args <- c(point_args, list(shape = shape))
	}
	if (!missing(size) & !is_waiver(size)) {
		point_args <- c(point_args, list(size = size))
	}

	# Make long-format data frame for plot
	data_to_plot <- stats::reshape(
		as.data.frame(data),  # reshape() chokes on tibbles
		direction = "long",
		varying = c(var_names$fitness_A, var_names$fitness_B),
		v.names = "fitness",
		timevar = "strain",
		times = c(strain_names$name_A, strain_names$name_B)
	)
	data_to_plot$strain <- factor(
		data_to_plot$strain, levels = c(strain_names$name_A, strain_names$name_B)
	)

	# Make plot
	fig_output <-
		ggplot2::ggplot(data_to_plot) +
		ggplot2::aes(y = .data$fitness, color = .data$strain, fill = .data$strain) +
		theme_microbimixr() +
		scale_y_fitness(name = ylab, limits = ylim) +
		do.call(geom_point_overlap, point_args) +
		ggplot2::scale_color_manual(values = color) +
		ggplot2::scale_fill_manual(values = fill)

	# Add x-axis mixing scale
	fig_output <- fig_output |>
		add_mix_axis(
			mix_scale = mix_scale,
			var_names = var_names,
			strain_names = strain_names,
			xlab = xlab,
			xlim = xlim
		)

	fig_output
}

#' Plot fitness of total group or subpopulation
#'
#' `plot_total_group_fitness()` draws a plot of total-group fitness as a
#' function of initial strain frequency
#'
#' @inheritParams plot_strain_fitness
#' @param data Data frame of fitness values and mix frequencies.
#'   Accepts data frame extensions like `tibble`.
#' @param color Point color
#' @param fill Point fill color. Only affects shapes 21-25.
#'
#' @details
#' Expects Wrightian fitness data like those returned by
#' [calculate_mix_fitness()].
#'
#' `var_names` must be a named vector or list that includes the following
#' elements (shown here with default values):
#' ```
#' var_names = c(
#'   name_A = "name_A",
#'   name_B = "name_B",
#'   initial_fraction_A = "initial_fraction_A",
#'   initial_ratio_A_B = "initial_ratio_A_B",
#'   fitness_total = "fitness_total"
#' )
#' ```
#'
#' @returns
#' A ggplot object that can be further modified using the ggplot2 package
#'
#' @seealso [plot_within_group_fitness()], [plot_strain_fitness()]
#'
#' @examples
#' fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
#' plot_total_group_fitness(fitness_myxo)
#'
#' # Using ratio scale for mix frequencies
#' plot_total_group_fitness(fitness_myxo, mix_scale = "ratio")
#'
#' # Other plot options
#' plot_total_group_fitness(
#'   fitness_myxo,
#'   ylim = c(1e-8, 1),
#'   xlab = "Initial frequency of evolved strain",
#'   ylab = "Sporulation efficiency\n(spores / cell)",
#'   color = "darkblue",
#'   fill = "lightblue",
#'   shape = 23,
#'   size = 2
#' )
#'
#' @export
#'
plot_total_group_fitness <- function(
	data,
	var_names = NULL,
	mix_scale = "fraction",
	xlab = NA,
	ylab = NA,
	xlim = c(NA, NA),
	ylim = c(NA, NA),
	color = NULL,
	fill = NULL,
	shape = NULL,
	size = NULL,
	drop_NA = TRUE
) {
	# Get variable and strain names
	if (is.null(var_names)) {var_names <- fitness_vars_default()}
	var_names <- as.list(var_names)
	strain_names <- get_strain_names(data, var_names)

	# Axis options
	mix_scale <- rlang::arg_match(mix_scale, c("fraction", "ratio"))
	if (missing(xlab)) {xlab <- waiver()}
	if (missing(ylab)) {ylab <- waiver()}
	if (missing(xlim)) {xlim <- NULL}
	if (missing(ylim)) {ylim <- NULL}

	# Point options
	point_args <- list(na.rm = drop_NA)
	if (missing(color) | is_waiver(color)) {color <- color_group()}
	if (missing(fill) | is_waiver(fill)) {fill <- fill_group()}
	point_args <- c(point_args, list(color = color, fill = fill))
	if (!missing(shape) & !is_waiver(shape)) {
		point_args <- c(point_args, list(shape = shape))
	}
	if (!missing(size) & !is_waiver(size)) {
		point_args <- c(point_args, list(size = size))
	}

	# Make plot
	fig_output <-
		ggplot2::ggplot(data) +
		ggplot2::aes(y = .data[[var_names$fitness_total]]) +
		theme_microbimixr() +
		scale_y_fitness_total(name = ylab, limits = ylim) +
		do.call(geom_point_overlap, point_args)

	# Add x-axis mixing scale
	fig_output <- fig_output |>
		add_mix_axis(
			mix_scale = mix_scale,
			var_names = var_names,
			strain_names = strain_names,
			xlab = xlab,
			xlim = xlim
		)

	fig_output
}

#' Plot within-group ratio of strain fitnesses
#'
#' `plot_within_group_fitness()` draws a plot of the relative within-group
#' fitness of strains A and B as a function of their initial frequency
#'
#' @inheritParams plot_total_group_fitness
#'
#' @details
#' Expects Wrightian fitness data like those returned by
#' [calculate_mix_fitness()]. Relative within-group fitness is measured as
#' the ratio of strain A fitness to strain B fitness.
#'
#' `var_names` must be a named vector or list that includes the following
#' elements (shown here with default values):
#' ```
#' var_names = c(
#'   name_A = "name_A",
#'   name_B = "name_B",
#'   initial_fraction_A = "initial_fraction_A",
#'   initial_ratio_A_B = "initial_ratio_A_B",
#'   fitness_ratio_A_B = "fitness_ratio_A_B"
#' )
#' ```
#'
#' @returns
#' A ggplot object that can be further modified using the ggplot2 package
#'
#' @seealso [plot_total_group_fitness()], [plot_strain_fitness()]
#'
#' @examples
#' fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
#' plot_within_group_fitness(fitness_myxo)
#'
#' # Using ratio scale for mix frequencies
#' plot_within_group_fitness(fitness_myxo, mix_scale = "ratio")
#'
#' # More plot options
#' plot_within_group_fitness(
#'   fitness_myxo,
#'   mix_scale = "ratio",
#'   ylim = c(0.01, 100),
#'   xlab = "Initial ratio evolved / ancestral",
#'   ylab = "Relative sporulation success\nevolved / ancestral",
#'   color = "darkblue",
#'   fill = "lightblue",
#'   shape = 23,
#'   size = 2
#' )
#'
#' @export
#'
plot_within_group_fitness <- function(
	data,
	var_names = NULL,
	mix_scale = "fraction",
	xlab = NA,
	ylab = NA,
	xlim = c(NA, NA),
	ylim = c(NA, NA),
	color = NULL,
	fill = NULL,
	shape = NULL,
	size = NULL,
	drop_NA = TRUE
) {
	# Get variable and strain names
	if (is.null(var_names)) {var_names <- fitness_vars_default()}
	var_names <- as.list(var_names)
	strain_names <- get_strain_names(data, var_names)

	# Axis options
	mix_scale <- rlang::arg_match(mix_scale, c("fraction", "ratio"))
	if (missing(xlab)) {xlab <- waiver()}
	if (missing(ylab)) {ylab <- waiver()}
	if (missing(xlim)) {xlim <- NULL}
	if (missing(ylim)) {ylim <- NULL}

	# Point options
	point_args <- list(na.rm = drop_NA)
	if (missing(color) | is_waiver(color)) {color <- color_group()}
	if (missing(fill) | is_waiver(fill)) {fill <- fill_group()}
	point_args <- c(point_args, list(color = color, fill = fill))
	if (!missing(shape) & !is_waiver(shape)) {
		point_args <- c(point_args, list(shape = shape))
	}
	if (!missing(size) & !is_waiver(size)) {
		point_args <- c(point_args, list(size = size))
	}

	# Filter out single-strain data
	if (mix_scale == "fraction") {
		mixvar <- var_names$initial_fraction_A
		data <- data[(data[[mixvar]] > 0) & (data[[mixvar]] < 1), ]
	} else if (mix_scale == "ratio") {
		mixvar <- var_names$initial_ratio_A_B
		data <- data[(is.finite(data[[mixvar]])) & (data[[mixvar]] > 0), ]
	}

	# Make plot
	fig_output <-
		ggplot2::ggplot(data) +
		ggplot2::aes(y = .data[[var_names$fitness_ratio_A_B]]) +
		theme_microbimixr() +
		scale_y_fitness_ratio(
			 name = ylab, strain_names = strain_names, limits = ylim
		) +
		do.call(geom_point_overlap, point_args)
		# geom_point_overlap(
		# 	color = color, fill = fill, shape = shape, size = size, na.rm = drop_NA
		# )

	# Add x-axis mixing scale
	fig_output <- fig_output |>
		add_mix_axis(
			mix_scale = mix_scale,
			var_names = var_names,
			strain_names = strain_names,
			xlab = xlab,
			xlim = xlim
		)

	fig_output
}


# Helper functions =============================================================

# Plot strain and total-group fitness
# Used by plot_mix_fitness() (not exported)
plot_fitness_strain_total <- function(
	data,
	var_names = fitness_vars_default(),
	mix_scale = "fraction",
	ylim = NULL,
	drop_NA = TRUE
) {
	# Variable names
	var_names <- as.list(var_names)
	var_names$fitness <- "fitness"
	strain_names <- get_strain_names(data, var_names)
	name_total <- "Total group"

	# Scale options
	mix_scale <- rlang::arg_match(mix_scale, c("fraction", "ratio"))

	# Make long-format data
	# data_for_plot <- format_to_plot_fitness(data, var_names, mix_scale)
	data_for_plot <- stats::reshape(
		as.data.frame(data),
		direction = "long",
		varying = c(
			var_names$fitness_A, var_names$fitness_B, var_names$fitness_total
		),
		v.names = "fitness",
		timevar = "strain",
		times = c(strain_names$name_A, strain_names$name_B, name_total)
	)
	data_for_plot$strain <- factor(
		data_for_plot$strain,
		levels = c(strain_names$name_A, strain_names$name_B, name_total)
	)
	data_for_plot$my_facet <- data_for_plot$strain == name_total

	# Make plot
	fig_output <-
		ggplot2::ggplot(data_for_plot) +
		ggplot2::aes(
			y = .data$fitness,
			color = .data$strain,
			fill = .data$strain
		) +
		theme_microbimixr() +
		theme_plot_mix_fitness() +
		scale_y_fitness(limits = ylim) +
		geom_point_overlap(na.rm = drop_NA) +
		scale_color_strain() +
		scale_fill_strain() +
		ggplot2::facet_wrap(~ my_facet, nrow = 1)

	# Add x-axis mixing scale
	fig_output <- fig_output |>
		add_mix_axis(
			mix_scale = mix_scale,
			var_names = var_names,
			strain_names = strain_names
		)

	# Return ggplot object
	fig_output
}

# Default names for fitness and mixing variables
fitness_vars_default <- function() {
	c(
		name_A = "name_A",
		name_B = "name_B",
		initial_fraction_A = "initial_fraction_A",
		initial_ratio_A_B = "initial_ratio_A_B",
		fitness = "fitness",
		fitness_A = "fitness_A",
		fitness_B = "fitness_B",
		fitness_total = "fitness_total",
		fitness_ratio_A_B = "fitness_ratio_A_B"
	)
}

# Get shared y-axis limits for fitness & fitness_ratio
#   So log10(fitness) and log10(fitness_ratio) are visually comparable
#   Used by plot_mix_fitness()
get_ylim_mix_fitness <- function(data, var_names) {
	var_names <- as.list(var_names)

	# Range: strain & total-group fitness
	fitness <- c(
		data[[var_names$fitness_A]],
		data[[var_names$fitness_B]],
		data[[var_names$fitness_total]],
		1
	)
	fitness <- fitness[is.finite(fitness) & fitness > 0]
	span_fitness <- log10(range(fitness)[2] / range(fitness)[1])

	# Range: Within-group fitness ratio
	fitness_ratio <- c(data[[var_names$fitness_ratio_A_B]], 1)
	fitness_ratio <- fitness_ratio[is.finite(fitness_ratio) & fitness_ratio > 0]
	span_fitness_ratio <- log10(range(fitness_ratio)[2] / range(fitness_ratio)[1])

	# Shared range (10-fold minimum)
	span_shared <- max(span_fitness, span_fitness_ratio, 1)
	span_shared <- span_shared + span_shared * 0.1

	# Limits
	midpoint_fitness <- mean(log10(range(fitness)))
	midpoint_fitness_ratio <- mean(log10(range(fitness_ratio)))
	ylim_fitness <- c(
		10^(midpoint_fitness - span_shared/2),
		10^(midpoint_fitness + span_shared/2)
	)
	ylim_fitness_ratio <- c(
		10^(midpoint_fitness_ratio - span_shared/2),
		10^(midpoint_fitness_ratio + span_shared/2)
	)

	list(fitness = ylim_fitness, fitness_ratio = ylim_fitness_ratio)
}

# Get strain names from fitness vars or data
get_strain_names <- function(data, var_names) {
	name_A <- var_names[["name_A"]]
	name_B <- var_names[["name_B"]]
	if (utils::hasName(data, name_A)) { name_A <- data[[name_A]][[1]] }
	if (utils::hasName(data, name_B)) { name_B <- data[[name_B]][[1]] }
	list(name_A = name_A, name_B = name_B)
}

# Add x-axis mixing scale to ggplot object
add_mix_axis <- function(
	fig_input,
	mix_scale,
	var_names,
	strain_names,
	xlab = waiver(),
	xlim = NULL
) {
	fig_input + switch(
		mix_scale,
		fraction = list(
			ggplot2::aes(.data[[var_names$initial_fraction_A]]),
			scale_x_initial_fraction(
				name = xlab, strain_names = strain_names, limits = xlim
			)
		),
		ratio = list(
			ggplot2::aes(.data[[var_names$initial_ratio_A_B]]),
			scale_x_initial_ratio(
				name = xlab, strain_names = strain_names, limits = xlim
			)
		)
	)
}

# Format data to plot strain and/or total-group fitness
# format_to_plot_fitness <- function(
# 	data,
# 	var_names = fitness_vars_default(),
# 	mix_scale
# ) {
# 	var_names <- as.list(var_names)
# 	# name_A <- data[[var_names$name_A]][[1]]
# 	# name_B <- data[[var_names$name_B]][[1]]
# 	name_A <- var_names$name_A[[1]]
# 	name_B <- var_names$name_B[[1]]
# 	name_total <- "Total group"
#
# 	output <- as.data.frame(data)  # So reshape() doesn't choke on tibbles
# 	output$initial_fraction_A <- output[[var_names$initial_fraction_A]]
# 	output$initial_ratio_A_B  <- output[[var_names$initial_ratio_A_B]]
# 	output$fitness_A          <- output[[var_names$fitness_A]]
# 	output$fitness_B          <- output[[var_names$fitness_B]]
# 	output$fitness_total      <- output[[var_names$fitness_total]]
# 	output <- subset(
# 		output,
# 		select = c(
# 			"initial_fraction_A", "initial_ratio_A_B",
# 			"fitness_A", "fitness_B", "fitness_total"
# 		)
# 	)
# 	output <- stats::reshape(
# 		output,
# 		direction = "long",
# 		varying = c("fitness_A", "fitness_B", "fitness_total"),
# 		v.names = c("fitness"),
# 		times = c(name_A, name_B, name_total),
# 		timevar = "strain"
# 	)
# 	output$strain <- factor(
# 		output$strain,
# 		levels = c(name_A, name_B, name_total)
# 	)
# 	output$my_facet <- output$strain == name_total
#
# 	# Drop rows with no value for fitness
# 	if (mix_scale == "ratio") {
# 		# Drop rows where mixing ratio undefined on log scale
# 		output <- output[is.finite(output$initial_fraction_A), ]
# 		output <- output[output$initial_ratio_A_B > 0, ]
# 		# output <- output[is.finite(output[[var_initial_ratio]]), ]
# 		# output <- output[output[[var_initial_ratio]] > 0, ]
# 	}
#
# 	output
# }

