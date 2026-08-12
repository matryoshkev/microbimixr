# Axes for ggplot2 =============================================================

#' X-axis for initial strain frequency
#'
#' `scale_x_initial_fraction()` is an x-axis position scale for initial strain
#' frequency (fraction or proportion of total) measured on a linear scale. It
#' calls `ggplot2::scale_x_continuous()` with default settings suited to
#' microbial mix experiments.
#'
#' @param name Character vector (or expression) for axis title.
#'   Or `NA` to automatically name axis using `strain_A_name`.
#'   Or `NULL` for no title.
#' @param strain_names Character vector or list used to automatically name axis
#'   if `name = NA`.
#' @param limits Numeric vector of length two giving axis limits.
#'   The default `c(0, 1)` shows the full range of possible mix frequencies.
#' @param breaks Numeric vector of positions for axis breaks.
#'   Or `NULL` for no breaks.
#' @param minor_breaks Numeric vector of positions for axis minor breaks.
#'   Or `NULL` for no minor breaks.
#' @param ... Other arguments passed to [ggplot2::scale_x_continuous()]
#'
#' @returns
#' X-axis position scale for use with the ggplot2 package
#'
#' @seealso [scale_x_initial_ratio()]
#'
#' @export
#'
scale_x_initial_fraction <- function(
	name = NA,
	strain_names = c(name_A = "strain A", name_B = "strain B"),
	limits = c(0, 1),
	breaks = seq(0, 1, by = 0.2),
	minor_breaks = NULL,
	...
) {
	if (is.na(name)) {
		strain_names <- as.list(strain_names)
		name <- paste("Initial fraction", strain_names$name_A)
	}
	ggplot2::scale_x_continuous(
		name = name,
		limits = limits,
		breaks = breaks,
		minor_breaks = minor_breaks,
		...
	)
}

#' X-axis for initial strain ratio
#'
#' `scale_x_initial_ratio()` is an x-axis scale for the initial ratio of strain
#' frequencies. It calls `ggplot2::scale_x_log10()` with default settings suited
#' to microbial mix experiments.
#'
#' @param name Character vector (or expression) for axis title.
#'   Or `NA` to automatically name axis using `strain_names`.
#'   Or `NULL` for no title.
#' @param strain_names Character vector or list used to automatically name axis
#'   if `name = NA`
#' @param limits Numeric vector of length two giving axis limits. Or `NULL` for
#'   automatic limits that include 1 for reference (equal 50:50 mix of strains)
#'   and span a minimum 10-fold range.
#' @param breaks Numeric vector of positions for axis breaks. Or `NA` for
#'   automatic breaks. Or `NULL` for no breaks.
#' @param labels One of:
#'   * Character vector giving labels for breaks (must be same length as
#'     `breaks`)
#'   * `NA` for automatic labels that use a simple number format when all breaks
#'     are between 0.01 and 100. For wider limits they use \eqn{10^x} format
#'     except for \eqn{1}.
#'   * Expression vector (must be the same length as `breaks`). See ?plotmath
#'     for details.
#'   * `NULL` for no labels
#' @param minor_breaks Numeric vector of positions for axis minor breaks. Or
#'   `NULL` for no minor breaks.
#' @param ... Other arguments passed to [ggplot2::scale_x_log10()]
#'
#' @returns
#' X-axis position scale for use with the ggplot2 package
#'
#' @seealso [scale_x_initial_fraction()]
#'
#' @export
#'
scale_x_initial_ratio <- function(
	name = NA,
	strain_names = c(name_A = "strain A", name_B = "strain B"),
	limits = NULL,
	breaks = NA,
	labels = NA,
	minor_breaks = NULL,
	...
) {
	if (is.na(name)) {
		strain_names <- as.list(strain_names)
		name <-
			paste("Initial ratio", strain_names$name_A, "/", strain_names$name_B)
	}
	if (is.null(limits)) {limits <- expand_limits_log10}
	if (is.na(breaks)) {breaks <- breaks_log10}
	if (is.na(labels)) {labels <- labels_log10}
	ggplot2::scale_x_log10(
		name = name,
		limits = limits,
		breaks = breaks,
		labels = labels,
		minor_breaks = minor_breaks,
		...
	)
}

#' Y-axis for strain fitnesses
#'
#' `scale_y_fitness()` is a y-axis scale for the fitness of microbial strains
#' and groups. It calls `ggplot2::scale_y_log10()` with default settings suited
#' to Wrightian fitness data.
#'
#' @inheritParams scale_x_initial_ratio
#' @param name Character vector (or expression) for axis title. Or `NA`
#'   to automatically name axis.
#' @param limits Numeric vector of length two giving axis limits. Or `NULL` for
#'   automatic limits that include 1 for reference (no change in abundance)
#'   and span a minimum 10-fold range.
#' @param minor_breaks Numeric vector of positions for axis minor breaks. Or
#'  `NA` for automatic breaks. Or `NULL` for no breaks.
#'
#' @details
#' `scale_y_fitness()` expects data that are absolute (unscaled) Wrightian
#' fitness, like the values produced by [calculate_mix_fitness()].
#' If the initial abundance of some microbe is \eqn{n} (measured as cfu/mL
#' for example) and its final abundance is \eqn{n'}, then its Wrightian
#' fitness measured over that entire time period is \eqn{w = n' / n}.
#'
#' @returns
#' Y-axis position scale for use with the ggplot2 package
#'
#' @seealso [scale_y_fitness_total()], [scale_y_fitness_ratio()]
#'
#' @export
#'
scale_y_fitness <- function(
	name = NA,
	limits = NULL,
	breaks = NA,
	labels = NA,
	minor_breaks = NA,
	...
) {
	if (is.na(name)) {name <- "Wrightian fitness\n (final no. / initial no.)"}
	if (is.null(limits)) {limits <- expand_limits_log10}
	if (is.na(breaks)) {breaks <- breaks_log10}
	if (is.na(labels)) {labels <- labels_log10}
	if (is.na(minor_breaks)) {minor_breaks <- minor_breaks_log10}
	ggplot2::scale_y_log10(
		name = name,
		limits = limits,
		breaks = breaks,
		labels = labels,
		minor_breaks = minor_breaks,
		...
	)
}

#' Y-axis for fitness of groups or subpopulations
#'
#' `scale_y_fitness_total()` is a y-axis scale for the total fitness of
#' microbial groups or subpopulations. It calls `ggplot2::scale_y_log10()` with
#' default settings suited to Wrightian fitness data.
#'
#' @inheritParams scale_y_fitness
#'
#' @details
#' `scale_y_fitness_total()` expects data that are absolute (unscaled) Wrightian
#' fitness, like the values produced by [calculate_mix_fitness()].
#' If the initial abundance of a microbial group is \eqn{n} (measured as cfu/mL
#' for example) and its final abundance is \eqn{n'}, then the group's Wrightian
#' fitness measured over that entire time period is \eqn{w = n' / n}.
#'
#' @returns
#' Y-axis position scale for use with the ggplot2 package
#'
#' @seealso [scale_y_fitness()], [scale_y_fitness_ratio()]
#'
#' @export
#'
scale_y_fitness_total <- function(
	name = NA,
	limits = NULL,
	breaks = NA,
	labels = NA,
	minor_breaks = NA,
	...
) {
	if (is.na(name)) {name <- "Total group fitness\n(final no. / initial no.)"}
	scale_y_fitness(
		name = name,
		limits = limits,
		breaks = breaks,
		labels = labels,
		minor_breaks = minor_breaks,
		...
	)
}

#' Y-axis for within-group ratio of strain fitnesses
#'
#' `scale_y_fitness_ratio()` is a y-axis scale for the relative fitness of
#' microbes within a group or subpopulation, measured as a ratio of Wrightian
#' fitnesses. It calls `ggplot2::scale_y_log10()` with default settings suited
#' to fitness-ratio data.
#'
#' @inheritParams scale_y_fitness
#' @param name Character vector (or expression) for axis title.
#'   Or `NA` to automatically name axis using `strain_names`.
#'   Or `NULL` for no title.
#' @param strain_names Character vector or list used to automatically name axis
#'   if `name = NA`
#' @param limits Numeric vector of length two giving axis limits. Or `NULL` for
#'   automatic limits that include 1 for reference (no change in relative
#'   abundance) and span a minimum 10-fold range.
#'
#' @details
#' `scale_y_fitness_ratio()` expects data that are the ratio of Wrightian
#' fitnesses for two microbes in the same group or subpopulation, like the
#' values produced by [calculate_mix_fitness()].
#' If the initial abundances of microbes A and B are \eqn{n_A} and \eqn{n_B}
#' (measured as cfu/mL for example) and their final abundances are \eqn{n'_A}
#' and \eqn{n'_B}, then their absolute (unscaled) Wrightian fitnesses measured
#' over that entire time period are
#' \deqn{w_A = n'_A/n_A \\ w_B = n'_B/n_B}
#' The within-group fitness ratio of A to B is \eqn{w_A / w_B}.
#'
#' Because the abundances of microbes A and B are measured in the same group,
#' the within-group fitness ratio can be equivalently measured from their
#' relative frequencies.
#' If the initial frequencies of A and B are \eqn{q_A} and \eqn{q_B}
#' (measured as a proportion or fraction of the total group) and their final
#' frequencies are \eqn{q'_A} and \eqn{q'_B},
#' then the within-group fitness ratio of A to B is
#' \deqn{w_A / w_B = \frac{q'_A / q'_B}{q_A / q_B}}
#'
#' @returns
#' Y-axis position scale for use with the ggplot2 package
#'
#' @seealso [scale_y_fitness()], [scale_y_fitness_total()]
#'
#' @export
#'
scale_y_fitness_ratio <- function(
	name = NA,
	strain_names = c(name_A = "strain A", name_B = "strain B"),
	limits = NULL,
	breaks = NA,
	labels = NA,
	minor_breaks = NA,
	...
) {
	if (is.na(name)) {
		strain_names <- as.list(strain_names)
		name <-
			paste("Initial ratio", strain_names$name_A, "/", strain_names$name_B)
	}
	if (is.null(limits)) {limits <- expand_limits_log10}
	if (is.na(breaks)) {breaks <- breaks_log10}
	if (is.na(labels)) {labels <- labels_log10}
	if (is.na(minor_breaks)) {minor_breaks <- minor_breaks_log10}
	ggplot2::scale_y_log10(
		name = name,
		limits = limits,
		breaks = breaks,
		labels = labels,
		minor_breaks = minor_breaks,
		...
	)
}


# Axis helpers =================================================================

# Expand ggplot's automatic limits for logarithmic scales
expand_limits_log10 <- function(limits) {
	# Include 1
	limits <- c(limits, 1)

	# Minimum 10-fold range
	log10_range <- range(log10(limits))
	if (max(log10_range) - min(log10_range) < 1) {
		midpoint <- mean(log10_range)
		limits <- 10^c(midpoint - 0.5, midpoint + 0.5)
	}

	range(limits)
}

# Breaks for log10 axes
breaks_log10 <- function(limits) {
	limits_range <- suppressWarnings(log10(range(limits, na.rm = TRUE)))
	span <- limits_range[2] - limits_range[1]
	# Limits assumed to include 1, minimum 10-fold range
	if (span < 1.47) {
		breaks <- c(0.02, 0.05, 0.1, 0.2, 0.5, 1, 2, 5, 10, 20, 50)
	} else if (span < 3) {
		breaks <- c(0.003, 0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30, 100, 300)
	} else if (span < 6) {
		breaks <- 10^seq(-6, 6, by = 1)
	} else if (span < 9) {
		breaks <- 10^seq(-10, 10, by = 2)
	} else if (span < 12) {
		breaks <- 10^seq(-12, 12, by = 3)
	} else {
		breaks <- 10^seq(-20, 20, by = 4)
	}
	breaks
}

# Labels for log10 axes
labels_log10 <- function(breaks) {
	if (max(abs(log10(breaks)), na.rm = TRUE) >= 3) {
		# 10^n notation except for 1
		sapply(breaks, function(x) {
			ifelse(x == 1, "1", paste0("10^", log10(x)))
		}) |>
		parse(text = _)
	} else {
		# Clean integer/decimal if all breaks between 0.01 and 100
		scales::number(breaks, drop0trailing = TRUE)
	}
}

# Minor breaks for log10 axes
minor_breaks_log10 <- function(limits) {
	limits_range <- suppressWarnings(log10(range(limits, na.rm = TRUE)))
	span <- limits_range[2] - limits_range[1]
	if (span < 3) {
		breaks <- rep(1:9, 6) * 10^sort(rep(-3:2, 9))
	} else if (span < 6) {
		breaks <- 3 * 10^c(-6:6)
	} else if (span < 12) {
		breaks <- 10^c(-12:12)
	} else {
		breaks <- 10^seq(-20, 20, by = 2)
	}
	breaks
}

# Calculate limits for log10 axes from data
# limits_log10 <- function(values) {
#   values <- values[is.finite(values) & values > 0]
#   values <- c(values, 1)  # Always include 1
# 	log10_range <- log10(range(values))
#  	midpoint <- mean(log10_range)
# 	span <- log10_range[2] - log10_range[1]
# 	span <- max(span, 1)  # Minimum 10-fold range
# 	span <- span * 1.1  # 5% expansion to either side
# 	min <- 10^(midpoint - span/2)
# 	max <- 10^(midpoint + span/2)
# 	c(min, max)
# }
