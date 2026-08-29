# Plot fitness measures ========================================================

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
#' @param mix_scale Mixing frequency scale for x axis. `"fraction"` uses
#'   initial frequency of strain A (proportion of total) from
#'   `initial_fraction_A` variable in data. `"ratio"` uses ratio of strain A to
#'   strain B (on \eqn{\log_{10}} scale) from `initial_ratio_A_B`.
#'    Defaults to show both.
#' @param color Point colors `c(strain_A, strain_B, total_group)`
#' @param fill Point fill colors `c(strain_A, strain_B, total_group)`.
#'   Only affects shapes 21--25.
#' @param shape Point shape
#' @param size Point size in mm
#' @param drop_NA `TRUE` to silently remove missing values.
#'   `FALSE` to warn when removing missing values.
#'
#' @details
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
#' Expects Wrightian fitness data like those returned by
#' [calculate_mix_fitness()].
#' Does not try to plot single-strain data for plots with `mix_scale = "ratio"`.
#'
#' @returns A ggplot object
#'
#' @seealso [calculate_mix_fitness()]
#'
#' @examples
#' fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
#' plot_mix_fitness(fitness_myxo)
#'
#' # Some plot options
#' plot_mix_fitness(
#'   fitness_myxo,
#'   mix_scale = "fraction",
#'   color = c("black", "grey40", "grey40"),
#'   fill = c("grey50", "white", "grey75"),
#'   shape = 23,
#'   size = 2
#' )
#'
#' @export
#'
plot_mix_fitness <- function(
	data,
	var_names = NULL,
	mix_scale = c("fraction", "ratio"),
	color = c(NULL, NULL, NULL),
	fill = c(NULL, NULL, NULL),
	shape = NULL,
	size = NULL,
	drop_NA = TRUE
) {
	# Get variable names
	if (is.null(var_names)) {var_names <- fitness_vars_default()}

	# Axis options
	mix_scale <- rlang::arg_match(
		mix_scale, c("fraction", "ratio"), multiple = TRUE
	)
	ylim <- get_ylim_mix_fitness(data, var_names)

	# Point color and fill
	if (missing(color)) {
		color_strain_group <- waiver()
		color_group <- waiver()
	} else {
		color_strain_group <- color
		color_group <- color[[3]]
	}
	if (missing(fill)) {
		fill_strain_group <- waiver()
		fill_group <- waiver()
	} else {
		fill_strain_group <- fill
		fill_group <- fill[[3]]
	}

	# Other point options
	if (missing(shape)) {shape <- waiver()}
	if (missing(size)) {size <- waiver()}

	# Make subplots
	figA <- plot_fitness_strain_total(
		data,
		var_names,
		mix_scale = "fraction",
		ylim = ylim$fitness,
		color = color_strain_group,
		fill = fill_strain_group,
		shape = shape,
		size = size,
		drop_NA = drop_NA
	)
	figB <- plot_within_group_fitness(
		data,
		var_names,
		mix_scale = "fraction",
		ylim = ylim$fitness_ratio,
		color = color_group,
		fill = fill_group,
		shape = shape,
		size = size,
		drop_NA = drop_NA
	)
	figC <- plot_fitness_strain_total(
		data,
		var_names,
		mix_scale = "ratio",
		ylim = ylim$fitness,
		color = color_strain_group,
		fill = fill_strain_group,
		shape = shape,
		size = size,
		drop_NA = drop_NA
	)
	figD <- plot_within_group_fitness(
		data,
		var_names,
		mix_scale = "ratio",
		ylim = ylim$fitness_ratio,
		color = color_group,
		fill = fill_group,
		shape = shape,
		size = size,
		drop_NA = drop_NA
	)

	# Combine subplots
	if (("fraction" %in% mix_scale) & ("ratio" %in% mix_scale)) {
		fig_output <- figA + figB + figC + figD
	} else if ("ratio" %in% mix_scale) {
		fig_output <- figC + figD
	} else {
		fig_output <- figA + figB
	}

	# Size plots for page-width figure
	fig_output <-
		fig_output +
		patchwork::plot_layout(
			widths = grid::unit(c(3.2, 1.6), "inches"),
			heights = grid::unit(1.4, "inches")
			# Units affect plotting area, not total size
		)

	fig_output
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
#' Expects Wrightian fitness data like those returned by
#' [calculate_mix_fitness()].
#' Does not try to plot single-strain data if `mix_scale = "ratio"`.
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

	# Drop single-strain data for log mixing scales
	if (mix_scale == "ratio") {
		data <- data[is.finite(log(data[[var_names$initial_ratio_A_B]])), ]
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
#' Expects Wrightian fitness data like those returned by
#' [calculate_mix_fitness()].
#' Does not try to plot single-strain data if `mix_scale = "ratio"`.
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

	# Drop single-strain data for log mixing scales
	if (mix_scale == "ratio") {
		data <- data[is.finite(log(data[[var_names$initial_ratio_A_B]])), ]
	}

	# Make plot
	fig_output <-
		ggplot2::ggplot(data) +
		ggplot2::aes(y = .data[[var_names$fitness_total]]) +
		theme_microbimixr() +
		scale_y_fitness_total(name = ylab, limits = ylim) +
		do.call(geom_point_overlap, point_args)
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
#' Expects Wrightian fitness data like those returned by
#' [calculate_mix_fitness()]. Relative within-group fitness is measured as
#' the ratio of strain A fitness to strain B fitness.
#' Does not try to plot single-strain data.
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
	if (missing(ylab)) {
		ylab <- paste(
			"Fitness ratio\n",
			strain_names[["name_A"]], "/", strain_names[["name_B"]]
		)
	}
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
		scale_y_fitness_ratio(name = ylab, limits = ylim) +
		do.call(geom_point_overlap, point_args)
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
#   Used by plot_mix_fitness()
plot_fitness_strain_total <- function(
	data,
	var_names = fitness_vars_default(),
	mix_scale = "fraction",
	ylim = NULL,
	color = waiver(),
	fill = waiver(),
	shape = waiver(),
	size = waiver(),
	drop_NA = TRUE
) {
	# Variable names
	var_names <- as.list(var_names)
	var_names$fitness <- "fitness"
	strain_names <- get_strain_names(data, var_names)
	name_total <- "Total group"

	# Axis options
	mix_scale <- rlang::arg_match(mix_scale, c("fraction", "ratio"))

	# Point color and fill
	if (is_waiver(color)) {
		color <- c(color_strain_A(), color_strain_B(), color_group())
	}
	if (is_waiver(fill)) {
		fill <- c(fill_strain_A(), fill_strain_B(), fill_group())
	}

	# Other point options
	point_args <- list(na.rm = drop_NA)
	if (!is_waiver(shape)) {point_args <- c(point_args, list(shape = shape))}
	if (!is_waiver(size)) {point_args <- c(point_args, list(size = size))}

	# Drop single-strain data for log mixing scales
	if (mix_scale == "ratio") {
		data <- data[is.finite(log(data[[var_names$initial_ratio_A_B]])), ]
	}

	# Make long-format data
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
		ggplot2::aes(y = .data$fitness, color = .data$strain, fill = .data$strain) +
		theme_microbimixr() +
		theme_plot_mix_fitness() +
		scale_y_fitness(limits = ylim) +
		do.call(geom_point_overlap, point_args) +
		ggplot2::scale_color_manual(values = color, na.value = NA) +
		ggplot2::scale_fill_manual(values = fill, na.value = NA) +
		ggplot2::facet_wrap(~ my_facet, nrow = 1)
	fig_output <- fig_output |>
		add_mix_axis(
			mix_scale = mix_scale,
			var_names = var_names,
			strain_names = strain_names
		)

	fig_output
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

# Get strain names from names object or data column
get_strain_names <- function(data, var_names) {
	name_A <- var_names[["name_A"]]
	name_B <- var_names[["name_B"]]
	is_multistrain <- FALSE
	if (utils::hasName(data, name_A)) {
		name_A <- unique(data[[name_A]])
		if (length(name_A) > 1) {
			is_multistrain <- TRUE
			name_A <- "Strain A"
		}
	}
	if (utils::hasName(data, name_B)) {
		name_B <- unique(data[[name_B]])
		if (length(name_B) > 1) {
			is_multistrain <- TRUE
			name_B <- "Strain B"
		}
	}
	if (is_multistrain) message("Note: >1 strain combination in data")
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
	# Set default axis name using strain names
	if (is_waiver(xlab)) {
		if (mix_scale == "fraction") {
			xlab <- paste("Initial fraction", strain_names[["name_A"]])
		} else if (mix_scale == "ratio") {
			xlab <- paste(
				"Initial ratio",
				strain_names[["name_A"]], "/", strain_names[["name_B"]]
			)
		}
	}

	fig_input + switch(
		mix_scale,
		fraction = list(
			ggplot2::aes(.data[[var_names$initial_fraction_A]]),
			scale_x_initial_fraction(name = xlab, limits = xlim)
		),
		ratio = list(
			ggplot2::aes(.data[[var_names$initial_ratio_A_B]]),
			scale_x_initial_ratio(name = xlab, limits = xlim)
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

