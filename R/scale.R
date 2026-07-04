# Axes for ggplot2 =============================================================

# X-axis: initial fraction strain A
scale_x_initial_fraction <- function(
	strain_A_name = "strain A",
	name = NA,
	limits = NULL,
	breaks = ggplot2::waiver(),
	minor_breaks = ggplot2::waiver(),
	...
) {
	if (is.na(name)) {
		name <- paste("Initial fraction", strain_A_name)
	}
	if (is.null(limits)) {
		limits <- c(0, 1)
		breaks <- seq(0, 1, by = 0.2)
		minor_breaks <- NULL
	}
	ggplot2::scale_x_continuous(
		name = name,
		limits = limits,
		breaks = breaks,
		minor_breaks = minor_breaks,
		...
	)
}

# X-axis: initial ratio A/B (log10)
scale_x_initial_ratio <- function(
	strain_names = c(A = "strain A", B = "strain B"),
	name = NA,
	limits = NULL,
	...
) {
	if (is.na(name)) {
		strain_names <- as.list(strain_names)
		name <- paste("Initial ratio", strain_names$A, "/", strain_names$B)
	}
	if (is.null(limits)) {
		breaks <- 10^c(-12:12)
		minor_breaks <- NULL
	}
	ggplot2::scale_x_log10(
		name = name,
		limits = limits,
		breaks = breaks_log10,
		labels = labels_log10,
		minor_breaks = minor_breaks_log10,
		...
	)
}

# Y-axis: fitness (strain A, strain B, total group)
scale_y_fitness <- function(
	name = NA,
	limits = NULL,
	...
) {
	if (is.na(name)) { name <- "Wrightian fitness\n (final no. / initial no.)" }
	ggplot2::scale_y_log10(
		name = name,
		limits = limits,
		breaks = breaks_log10,
		labels = labels_log10,
		minor_breaks = minor_breaks_log10,
		...
	)
}

# Y-axis: total-group fitness
scale_y_fitness_total <- function(
	name = NA,
	limits = NULL,
	...
) {
	if (is.na(name)) {
		name <- "Total group fitness\n(final no. / initial no.)"
	}
	ggplot2::scale_y_log10(
		name = name,
		limits = limits,
		breaks = breaks_log10,
		labels = labels_log10,
		minor_breaks = minor_breaks_log10,
		...
	)
}

# Y-axis: within-group fitness ratio A/B
scale_y_fitness_ratio <- function(
	strain_names = c(A = "strain A", B = "strain B"),
	name = NA,
	limits = NULL,
	...
) {
	if (is.na(name)) {
		strain_names <- as.list(strain_names)
		name <- paste("Fitness ratio\n", strain_names$A, "/", strain_names$B)
	}
	ggplot2::scale_y_log10(
		name = name,
		limits = limits,
		breaks = breaks_log10,
		labels = labels_log10,
		minor_breaks = minor_breaks_log10,
		...
	)
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
		# 10^n notation
		text <- paste0(10, "^", log10(breaks))
		text[text == "10^0"] <- "1"
		labels <- vector("expression", length(text))
    for (i in seq_along(text)) {
        labels[[i]] <- parse(text = text[[i]])
    }
	} else {
		# Clean integer/decimal
		labels <- scales::number(breaks, drop0trailing = TRUE)
	}
	labels
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
limits_log10 <- function(values) {
  values <- values[is.finite(values) & values > 0]
  values <- c(values, 1)  # Always include 1
	log10_range <- log10(range(values))
 	midpoint <- mean(log10_range)
	span <- log10_range[2] - log10_range[1]
	span <- max(span, 1)  # Minimum 10-fold range
	span <- span * 1.1  # 5% expansion to either side
	min <- 10^(midpoint - span/2)
	max <- 10^(midpoint + span/2)
	c(min, max)
}
