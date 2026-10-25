# Plot fitness measures ========================================================

#' Draw plots to compare fitness measures
#'
#' `plot_mix_fitness()` shows a diagnostic overview of various fitness effects
#' in a dataset. Draws a combined plot of strain, total group, and relative
#' within-group fitness against two measures of mix frequency.
#'
#' @param data Data frame of fitness values like those returned by
#'   [calculate_mix_fitness()]. See Details.
#'   Accepts data frame extensions like `tibble`.
#' @param mix_scale Mixing frequency scale for x axis. `"fraction"` uses
#'   initial frequency of strain A (proportion of total) from
#'   `initial_fraction_A` variable in data. `"ratio"` uses ratio of strain A to
#'   strain B (on \eqn{\log_{10}} scale) from `initial_ratio_A_B`.
#'   Defaults to show both.
#' @param color Point colors `c(strain_A, strain_B, total_group)`
#' @param fill Point fill colors `c(strain_A, strain_B, total_group)`.
#'   Only affects shapes 21--25.
#' @param shape Point shape
#' @param size Point size in mm
#' @param drop_NA `TRUE` to silently remove missing values.
#'   `FALSE` to warn when removing missing values.
#'
#' @details
#' Expects data frame of Wrightian fitness values like those returned by
#' [calculate_mix_fitness()],
#' with columns `name_A`, `name_B`, `initial_fraction_A`,
#' `initial_ratio_A_B`, `fitness_A`, `fitness_B`, `fitness_total`, and
#' `fitness_ratio_A_B`.
#' Wide format: each row must contain data for two microbes in the same
#' population.
#'
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
	mix_scale = c("fraction", "ratio"),
	color = c(NULL, NULL, NULL),
	fill = c(NULL, NULL, NULL),
	shape = NULL,
	size = NULL,
	drop_NA = TRUE
) {
	# Check inputs here because we use them to set y-limits
	mix_scale <- rlang::arg_match(
		mix_scale, c("fraction", "ratio"), multiple = TRUE
	)
	data <- check_fitness_data(
		data,
		vars = c("fitness_A", "fitness_B", "fitness_total", "fitness_ratio_A_B"),
		mix_scale = mix_scale,
		caller = "plot_mix_fitness"
	)

	# Set y-limits so effect sizes are visually comparable
	ylim <- get_ylim_mix_fitness(data)

	# Point options
	color_strain_total <- if (is.null(color)) waiver() else color
	fill_strain_total <- if (is.null(fill)) waiver() else fill
	color_ratio <- if (is.null(color)) waiver() else color[[3]]
	fill_ratio <- if (is.null(fill)) waiver() else fill[[3]]
	if (is.null(shape)) {shape <- waiver()}
	if (is.null(size)) {size <- waiver()}

	# Make subplots
	if ("fraction" %in% mix_scale) {
		figA <- plot_fitness_strain_total(
			data,
			mix_scale = "fraction",
			ylim = ylim$fitness,
			color = color_strain_total,
			fill = fill_strain_total,
			shape = shape,
			size = size,
			drop_NA = drop_NA
		)
		figB <- plot_fitness_ratio(
			data,
			mix_scale = "fraction",
			ylim = ylim$fitness_ratio,
			color = color_ratio,
			fill = fill_ratio,
			shape = shape,
			size = size,
			drop_NA = drop_NA
		)
	}
	if ("ratio" %in% mix_scale) {
		figC <- plot_fitness_strain_total(
			data,
			mix_scale = "ratio",
			ylim = ylim$fitness,
			color = color_strain_total,
			fill = fill_strain_total,
			shape = shape,
			size = size,
			drop_NA = drop_NA
		)
		figD <- plot_fitness_ratio(
			data,
			mix_scale = "ratio",
			ylim = ylim$fitness_ratio,
			color = color_ratio,
			fill = fill_ratio,
			shape = shape,
			size = size,
			drop_NA = drop_NA
		)
	}

	# Combine subplots
	fig_output <-
		if (("fraction" %in% mix_scale) && ("ratio" %in% mix_scale)) {
			figA + figB + figC + figD
		} else if ("ratio" %in% mix_scale) {
			figC + figD
		} else {
			figA + figB
		}

	# Size plots for page-width figure
	fig_output <- fig_output + plot_layout(
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
#' @param data Data frame of fitness values and mix frequencies. See Details.
#'   Accepts data frame extensions like `tibble`.
#' @param mix_scale Mixing scale for x axis. Default `"fraction"` uses initial
#'   frequency of strain A (proportion of total) from `initial_fraction_A`
#'   variable of data. `"ratio"` uses ratio of strain A to strain B (on
#'   \eqn{\log_{10}} scale) from `initial_ratio_A_B`.
#' @param facet_strains `TRUE` to show data for each strain on separate subplots
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
#' Expects data frame of Wrightian fitness values like those returned by
#' [calculate_mix_fitness()],
#' with columns `name_A`, `name_B`, `initial_fraction_A`,
#' `initial_ratio_A_B`, `fitness_A`, and `fitness_B`.
#' Wide format: each row must contain data for two microbes in the same
#' population.
#'
#' Does not try to plot single-strain data if `mix_scale = "ratio"`.
#'
#' @returns
#' A ggplot object that can be further modified using the ggplot2 package
#'
#' @seealso [plot_total_fitness()], [plot_fitness_ratio()]
#'
#' @examples
#' fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
#' plot_strain_fitness(fitness_myxo)
#'
#' # Some plot options
#' plot_strain_fitness(
#'   fitness_myxo,
#'   facet_strains = TRUE,
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
	mix_scale = "fraction",
	facet_strains = FALSE,
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
	mix_scale <- rlang::arg_match(mix_scale, c("fraction", "ratio"))
	data <- check_fitness_data(
		data,
		vars = c("fitness_A", "fitness_B"),
		mix_scale = mix_scale,
		caller = "plot_strain_fitness"
	)
	strain_labels <- get_strain_labels(data)

	# Make long-format data frame for plot
	data_to_plot <- stats::reshape(
		as.data.frame(data),  # reshape() chokes on tibbles
		direction = "long",
		varying = c("fitness_A", "fitness_B"),
		v.names = "fitness",
		timevar = "strain",
		times = c(strain_labels$A, strain_labels$B)
	)
	# data_to_plot <- lengthen_strain_fitness(data)
	# TODO: Fix facet issue here: strain vs strain_label

	# List strain A first
	data_to_plot$strain <- factor(
		data_to_plot$strain, levels = c(strain_labels$A, strain_labels$B)
	)

	# Drop single-strain data if using ratio mixing scale
	if (mix_scale == "ratio") {
		data_to_plot <- drop_unmixed(data_to_plot, mix_scale)
	}

	# Axis options
	if (!is.expression(xlab) && !is.null(xlab) && is.na(xlab)) {xlab <- waiver()}
	if (!is.expression(ylab) && !is.null(ylab) && is.na(ylab)) {ylab <- waiver()}
	if (any(is.na(xlim))) {xlim <- NULL}
	if (any(is.na(ylim))) {ylim <- NULL}

	# Point options
	if (is.null(color) || is_waiver(color)) {
		color <- c(color_strain_A(), color_strain_B())
	}
	if (is.null(fill) || is_waiver(fill)) {
		fill <- c(fill_strain_A(), fill_strain_B())
	}
	point_args <- get_point_args(shape = shape, size = size, drop_NA = drop_NA)

	# Make base plot
	fig_output <-
		ggplot2::ggplot(data_to_plot) +
		ggplot2::aes(y = .data$fitness, color = .data$strain, fill = .data$strain) +
		theme_strain_fitness(facet_strains = facet_strains) +
		scale_y_fitness(name = ylab, limits = ylim) +
		do.call(geom_point_overlap, point_args) +
		ggplot2::scale_color_manual(values = color, name = "") +
		ggplot2::scale_fill_manual(values = fill, name = "")

	# Add x-axis
	fig_output <- fig_output |>
		add_mix_axis(
			mix_scale = mix_scale,
			strain_labels = strain_labels,
			xlab = xlab,
			xlim = xlim
		)

	# Show strains on separate subplots
	if (is.logical(facet_strains) && facet_strains == TRUE) {
		fig_output <- fig_output + ggplot2::facet_wrap(~ strain, nrow = 1)
	}

	fig_output
}

#' Plot fitness of total group or subpopulation
#'
#' `plot_total_fitness()` draws a plot of total-group fitness as a
#' function of initial strain frequency
#'
#' @inheritParams plot_strain_fitness
#' @param data Data frame of fitness values and mix frequencies. See details.
#'   Accepts data frame extensions like `tibble`.
#' @param color Point color
#' @param fill Point fill color. Only affects shapes 21-25.
#'
#' @details
#' Expects data frame of Wrightian fitness values like those returned by
#' [calculate_mix_fitness()], with columns `name_A`, `name_B`,
#' `initial_fraction_A`, `initial_ratio_A_B`, and `fitness_total`.
#' Does not try to plot single-strain data if `mix_scale = "ratio"`.
#'
#' @returns
#' A ggplot object that can be further modified using the ggplot2 package
#'
#' @seealso [plot_fitness_ratio()], [plot_strain_fitness()]
#'
#' @examples
#' fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
#' plot_total_fitness(fitness_myxo)
#'
#' # Using ratio scale for mix frequencies
#' plot_total_fitness(fitness_myxo, mix_scale = "ratio")
#'
#' # Other plot options
#' plot_total_fitness(
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
plot_total_fitness <- function(
	data,
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
	mix_scale <- rlang::arg_match(mix_scale, c("fraction", "ratio"))
	data <- check_fitness_data(
		data,
		vars = "fitness_total",
		mix_scale = mix_scale,
		caller = "plot_total_fitness"
	)
	strain_labels <- get_strain_labels(data)

	# Drop single-strain data if using ratio mixing scale
	if (mix_scale == "ratio") {data <- drop_unmixed(data, mix_scale)}

	# Axis options
	if (!is.expression(xlab) && !is.null(xlab) && is.na(xlab)) {xlab <- waiver()}
	if (!is.expression(ylab) && !is.null(ylab) && is.na(ylab)) {
		ylab <- "Total fitness\n(final no. / initial no.)"
	}
	if (any(is.na(xlim))) {xlim <- NULL}
	if (any(is.na(ylim))) {ylim <- NULL}

	# Point options
	point_args <- get_point_args(
		color = color, fill = fill, shape = shape, size = size, drop_NA = drop_NA
	)

	# Make plot
	fig_output <-
		ggplot2::ggplot(data) +
		ggplot2::aes(y = .data$fitness_total) +
		theme_total_fitness() +
		scale_y_fitness(name = ylab, limits = ylim) +
		do.call(geom_point_overlap, point_args)
	fig_output <- fig_output |>
		add_mix_axis(
			mix_scale = mix_scale,
			strain_labels = strain_labels,
			xlab = xlab,
			xlim = xlim
		)

	fig_output
}

#' Plot within-group ratio of strain fitnesses
#'
#' `plot_fitness_ratio()` draws a plot of the relative within-group
#' fitness of strains A and B as a function of their initial frequency
#'
#' @inheritParams plot_total_fitness
#'
#' @details
#' Expects data frame of Wrightian fitness values like those returned by
#' [calculate_mix_fitness()], with columns `name_A`, `name_B`,
#' `initial_fraction_A`, `initial_ratio_A_B`, and `fitness_ratio_A_B`.
#' Relative within-group fitness is measured as
#' the ratio of strain A fitness to strain B fitness.
#' Does not try to plot single-strain data.
#'
#' @returns
#' A ggplot object that can be further modified using the ggplot2 package
#'
#' @seealso [plot_total_fitness()], [plot_strain_fitness()]
#'
#' @examples
#' fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
#' plot_fitness_ratio(fitness_myxo)
#'
#' # Using ratio scale for mix frequencies
#' plot_fitness_ratio(fitness_myxo, mix_scale = "ratio")
#'
#' # More plot options
#' plot_fitness_ratio(
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
plot_fitness_ratio <- function(
	data,
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
	mix_scale <- rlang::arg_match(mix_scale, c("fraction", "ratio"))
	data <- check_fitness_data(
		data,
		vars = "fitness_ratio_A_B",
		mix_scale = mix_scale,
		caller = "plot_fitness_ratio"
	)
	strain_labels <- get_strain_labels(data)

	# Drop single-strain data
	data <- drop_unmixed(data, mix_scale)

	# Axis options
	if (!is.expression(xlab) && !is.null(xlab) && is.na(xlab)) {xlab <- waiver()}
	if (!is.expression(ylab) && !is.null(ylab) && is.na(ylab)) {
		ylab <- paste("Fitness ratio\n", strain_labels$A, "/", strain_labels$B)
	}
	if (any(is.na(xlim))) {xlim <- NULL}
	if (any(is.na(ylim))) {ylim <- NULL}

	# Point options
	point_args <- get_point_args(
		color = color, fill = fill, shape = shape, size = size, drop_NA = drop_NA
	)

	# Make plot
	fig_output <-
		ggplot2::ggplot(data) +
		ggplot2::aes(y = .data$fitness_ratio_A_B) +
		theme_fitness_ratio() +
		scale_y_fitness_ratio(name = ylab, limits = ylim) +
		do.call(geom_point_overlap, point_args)
	fig_output <- fig_output |>
		add_mix_axis(
			mix_scale = mix_scale,
			strain_labels = strain_labels,
			xlab = xlab,
			xlim = xlim
		)

	fig_output
}

# Plot strain and total-group fitness
#   Unexported. Called by plot_mix_fitness()
plot_fitness_strain_total <- function(
	data,
	mix_scale = "fraction",
	ylim = NULL,
	color = waiver(),
	fill = waiver(),
	shape = waiver(),
	size = waiver(),
	drop_NA = TRUE
) {
	mix_scale <- rlang::arg_match(mix_scale, c("fraction", "ratio"))
	# Data already checked by plot_mix_fitness()
	strain_labels <- get_strain_labels(data)
	name_total <- "total"

	# Point options
	if (is_waiver(color) || is.null(color)) {
		color <- c(color_strain_A(), color_strain_B(), color_group())
	}
	if (is_waiver(fill) || is.null(fill)) {
		fill <- c(fill_strain_A(), fill_strain_B(), fill_group())
	}
	point_args <- get_point_args(shape = shape, size = size, drop_NA = drop_NA)

	# Make long-format data
	data_for_plot <- stats::reshape(
		as.data.frame(data),
		direction = "long",
		varying = c("fitness_A", "fitness_B", "fitness_total"),
		v.names = "fitness",
		timevar = "strain",
		times = c(strain_labels$A, strain_labels$B, name_total)
	)
	data_for_plot$strain <- factor(
		data_for_plot$strain,
		levels = c(strain_labels$A, strain_labels$B, name_total)
	)
	data_for_plot$my_facet <- data_for_plot$strain == name_total

	# Drop single-strain data if using ratio mixing scale
	if (mix_scale == "ratio") {
		data_for_plot <- drop_unmixed(data_for_plot, mix_scale)
	}

	# Make plot
	fig_output <-
		ggplot2::ggplot(data_for_plot) +
		ggplot2::aes(y = .data$fitness, color = .data$strain, fill = .data$strain) +
		theme_strain_fitness(facet_strains = TRUE) +
		scale_y_fitness(limits = ylim) +
		do.call(geom_point_overlap, point_args) +
		ggplot2::scale_color_manual(values = color, na.value = NA, name = "") +
		ggplot2::scale_fill_manual(values = fill, na.value = NA, name = "") +
		ggplot2::facet_wrap(~ my_facet, nrow = 1)
	fig_output <- fig_output |>
		add_mix_axis(mix_scale = mix_scale, strain_labels = strain_labels)

	fig_output
}


# Helper functions =============================================================

# Get shared y-axis limits for fitness & fitness_ratio
#   So log10(fitness) and log10(fitness_ratio) are visually comparable
#   Used by plot_mix_fitness()
get_ylim_mix_fitness <- function(data) {
	# Range: strain & total-group fitness
	fitness <- c(data$fitness_A, data$fitness_B, data$fitness_total, 1)
	fitness <- fitness[is.finite(fitness) & fitness > 0]
	span_fitness <- log10(range(fitness)[2] / range(fitness)[1])

	# Range: Within-group fitness ratio
	fitness_ratio <- c(data$fitness_ratio_A_B, 1)
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

# Collect arguments for geom_point_overlap()
#   Don't include if not given so we can use ggplot scale instead
get_point_args <- function(
	color = waiver(),
	fill = waiver(),
	shape = waiver(),
	size = waiver(),
	drop_NA = waiver()
) {
	args <- mget(ls())  # List of arguments to this function
	point_args <- list()
	for (arg_name in c("color", "fill", "shape", "size")) {
		arg_value <- args[[arg_name]]
		if (!is_waiver(arg_value) && !is.null(arg_value)) {
			point_args[[arg_name]] <- arg_value
		}
	}
	if (!is_waiver(drop_NA) && !is.null(drop_NA)) {point_args$na.rm <- drop_NA}
	point_args
}

# Get strain labels from data
#   Use "strain A" and/or "strain B" if there's >1 strain combo
get_strain_labels <- function(data) {
	is_multistrain <- FALSE
	label_A <- unique(data$name_A)
	label_B <- unique(data$name_B)
	if (length(label_A) > 1) {
		is_multistrain <- TRUE
		label_A <- "strain A"
	}
	if (length(label_B) > 1) {
		is_multistrain <- TRUE
		label_B <- "strain B"
	}
	if (is_multistrain) message("Note: >1 strain combination in data")
	list(A = label_A, B = label_B)
}

#' Convert strain fitness data from wide to long format
#'
#' `lengthen_strain_fitness()` converts wide-format fitness data (where each row
#' has values for both strains in an experiment)
#' to its equivalent long format (where each strain has its own row).
#' Useful when fitting models to strain fitness data.
#' For more details see the strain fitness vignette:
#' \code{vignette("strain-fitness", package = "microbimixr")}.
#'
#' @param data Data frame with columns `name_A`, `name_B`, `fitness_A`, and
#'   `fitness_B`.
#'
#' @return
#' Returns a data frame with
#' a new `strain` column containing values from `name_A` or `name_B`
#' and a new `fitness` column replacing `fitness_A` and `fitness_B`.
#' `name_A` and `name_B` kept to identify strain pairs.
#' Other columns kept as-is.
#'
#' @examples
#' # Make example data
#' strain_fitness <- data.frame(
#'   initial_fraction_A = c(0, 0.5, 1),
#'   fitness_A = c(NA, 150, 100),
#'   fitness_B = c(100, 50, NA)
#' )
#' strain_fitness$name_A <- "Evolved"
#' strain_fitness$name_B <- "Ancestral"
#' strain_fitness$exptl_block <- "A"
#'
#' # Show wide and long formats
#' strain_fitness
#' lengthen_strain_fitness(strain_fitness)
#'
#' @export
#'
lengthen_strain_fitness <- function(data) {
	data <- stats::reshape(
		as.data.frame(data),  # reshape() chokes on tibbles
		direction = "long",
		varying = c("fitness_A", "fitness_B"),
		v.names = "fitness",
		timevar = "strain",
		times = c("fitness_A", "fitness_B"),
		idvar = "probably_unique_column"
	)

	# Drop cruft added by reshape()
	data <- data[names(data) != "probably_unique_column"]
	row.names(data) <- NULL

	# Set strain to name_A or name_B as appropriate
	is_A <- data$strain == "fitness_A"
	is_B <- data$strain == "fitness_B"
	data$strain[is_A] <- data$name_A[is_A]
	data$strain[is_B] <- data$name_B[is_B]

	data
}

# Drop single-strain data
drop_unmixed <- function(data, mix_scale) {
	if (mix_scale == "fraction") {
		keep <- data$initial_fraction_A > 0 & data$initial_fraction_A < 1
	} else if (mix_scale == "ratio") {
		keep <- data$initial_ratio_A_B > 0 & is.finite(data$initial_ratio_A_B)
	}
	data[keep, ]
}

# Add x-axis mixing scale to ggplot object
add_mix_axis <- function(
	fig_input,
	mix_scale,
	strain_labels,
	xlab = waiver(),
	xlim = NULL
) {
	# Set default axis name using strain lables
	if (is_waiver(xlab)) {
		if (mix_scale == "fraction") {
			xlab <- paste("Initial fraction", strain_labels$A)
		} else if (mix_scale == "ratio") {
			xlab <- paste("Initial ratio", strain_labels$A, "/", strain_labels$B)
		}
	}

	fig_input + switch(
		mix_scale,
		fraction = list(
			ggplot2::aes(x = .data$initial_fraction_A),
			scale_x_initial_fraction(name = xlab, limits = xlim)
		),
		ratio = list(
			ggplot2::aes(x = .data$initial_ratio_A_B),
			scale_x_initial_ratio(name = xlab, limits = xlim)
		)
	)
}
