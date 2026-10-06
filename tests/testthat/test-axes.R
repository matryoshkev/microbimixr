# Scales =======================================================================

test_that("axis functions run with defaults", {
	expect_no_error(scale_x_initial_fraction())
	expect_no_error(scale_x_initial_ratio())
	expect_no_error(scale_y_fitness())
	expect_no_error(scale_y_fitness_total())
	expect_no_error(scale_y_fitness_ratio())
})

test_that("axes accept expression() names", {
	expect_no_error(scale_x_initial_fraction(name = expression(x)))
	expect_no_error(scale_x_initial_ratio(name = expression(x)))
	expect_no_error(scale_y_fitness(name = expression(x)))
	expect_no_error(scale_y_fitness_total(name = expression(x)))
	expect_no_error(scale_y_fitness_ratio(name = expression(x)))
})

test_that("axes accept specified breaks", {
	expect_no_error(scale_x_initial_fraction(breaks = c(0, 0.5, 1)))
	log_breaks <- c(0.1, 1, 10, 30)
	expect_no_error(scale_x_initial_ratio(breaks = log_breaks))
	expect_no_error(scale_y_fitness(breaks = log_breaks))
	expect_no_error(scale_y_fitness_total(breaks = log_breaks))
	expect_no_error(scale_y_fitness_ratio(breaks = log_breaks))
})

test_that("axes accept specified break labels", {
	expect_no_error(scale_x_initial_fraction(
		breaks = c(0, 0.5, 1), labels = c("Only A", "A+B", "Only B")
	))
	log_breaks <- c(0.1, 1, 10)
	log_labels <- c("low", "medium", "high")
	expect_no_error(
		scale_x_initial_ratio(breaks = log_breaks, labels = log_labels)
	)
	expect_no_error(
		scale_y_fitness(breaks = log_breaks, labels = log_labels)
	)
	expect_no_error(
		scale_y_fitness_total(breaks = log_breaks, labels = log_labels)
	)
	expect_no_error(
		scale_y_fitness_ratio(breaks = log_breaks, labels = log_labels)
	)
})

test_that("axes accept specified minor_breaks", {
	expect_no_error(
		scale_x_initial_fraction(minor_breaks = seq(0, 1, by = 0.1))
	)
	log_minor_breaks <- 3 * 10^{-2:2}
	expect_no_error(scale_x_initial_ratio(minor_breaks = log_minor_breaks))
	expect_no_error(scale_y_fitness(minor_breaks = log_minor_breaks))
	expect_no_error(scale_y_fitness_total(minor_breaks = log_minor_breaks))
	expect_no_error(scale_y_fitness_ratio(minor_breaks = log_minor_breaks))
	expect_no_error(scale_y_fitness(minor_breaks = NULL))
	expect_no_error(scale_y_fitness_total(minor_breaks = NULL))
	expect_no_error(scale_y_fitness_ratio(minor_breaks = NULL))
})

test_that("initial ratio axes look right", {
	skip(message = "Visual test")
	dev.new(width = 3, height = 7, units = "in")
	plot_axis <- function(values) {
		ggplot2::ggplot(data = data.frame(x = values)) +
		ggplot2::aes(x = x, y = 1) +
		ggplot2::geom_blank() +
		scale_x_initial_ratio(name = NULL) +
		ggplot2::scale_y_continuous(NULL, breaks = NULL) +
		ggplot2::theme(aspect.ratio = 1/10 ) +
		theme_microbimixr()
	}
	# Trial data
	list(
		c(2/8, 8/2),  # Fraction c(0.2, 0.8), 4-fold range
		c(1, 10),
		c(0.1, 10),
		c(0.1, 100),
		c(1.1e-3, 4.6e2),  # Ross-Gillespie 2007 A
		c(1e-4, 1e4),
		c(1e-4, 1e5),
		c(1e-5, 1e5),
		c(1e-5, 1e6),
		c(1e-7, 1e7),
		c(1e-9, 1e9)  # Large but possible
	) |>
	lapply(plot_axis) |>
	patchwork::wrap_plots(ncol = 1, axis_titles = "collect")
})

test_that("fitness axes look right", {
	skip(message = "Visual test")
	dev.new(width = 7.5, height = 2.25, units = "in")
	plot_axis <- function(values) {
		ggplot2::ggplot(data = data.frame(y = values)) +
		ggplot2::aes(x = 1, y = y) +
		ggplot2::geom_blank() +
		ggplot2::scale_x_continuous(name = NULL, breaks = NULL) +
		scale_y_fitness(name = NULL) +
		ggplot2::theme(aspect.ratio = 10/1) +
		theme_microbimixr()
	}
	# Trial data
	list(
		c(2/8, 8/2),  # Fraction c(0.2, 0.8), 4-fold range
		c(1, 10),
		c(0.1, 10),
		c(0.1, 100),
		c(1.1e-3, 4.6e2),
		c(1e-4, 1e4),
		c(1e-4, 1e5),
		c(1e-5, 1e5),
		c(1e-5, 1e6),
		c(1e-7, 1e7),
		c(1e-9, 1e9)  # Large but possible
	) |>
	lapply(plot_axis) |>
	patchwork::wrap_plots(nrow = 1)
})

test_that("fitness ratio axes look right", {
	skip(message = "Visual test")
	dev.new(width = 7.5, height = 2.25, units = "in")
	plot_axis <- function(values) {
		ggplot2::ggplot(data = data.frame(y = values)) +
		ggplot2::aes(x = 1, y = y) +
		ggplot2::geom_blank() +
		ggplot2::scale_x_continuous(name = NULL, breaks = NULL) +
		scale_y_fitness_ratio(name = NULL) +
		ggplot2::theme(aspect.ratio = 10/1) +
		theme_microbimixr()
	}
	# Trial data
	list(
		c(2/8, 8/2),  # Fraction c(0.2, 0.8), 4-fold range
		c(1, 10),
		c(0.1, 10),
		c(0.1, 100),
		c(1.1e-3, 4.6e2),
		c(1e-4, 1e4),
		c(1e-4, 1e5),
		c(1e-5, 1e5),
		c(1e-5, 1e6),
		c(1e-7, 1e7),
		c(1e-9, 1e9)  # Large but possible
	) |>
	lapply(plot_axis) |>
	patchwork::wrap_plots(nrow = 1)
})


# Limits =======================================================================

test_that("limits functions return functions", {
	expect_true(is.function(limits_fraction()))
	expect_true(is.function(limits_log10()))
})

test_that("fraction limits expand to include zero and one", {
	limiter <- limits_fraction()
	expect_equal(limiter(c(0, 1)), c(0, 1))
	expect_equal(limiter(0.5), c(0, 1))
	expect_equal(limiter(-0.05), c(-0.05, 1))
	expect_equal(limiter(1.05), c(0, 1.05))
})

test_that("log10 limits expanded to include one", {
	limiter <- limits_log10()
	expect_equal(limiter(0.1), c(0.1, 1))
	expect_equal(limiter(10), c(1, 10))
	expect_equal(limiter(c(0.1, 1)), c(0.1, 1))
	expect_equal(limiter(c(1, 10)), c(1, 10))
})

test_that("log10 limits expanded to minimum 10-fold range", {
	limiter <- limits_log10()
	spans_10fold <- function(values) {max(values) / min(values) >= 9.99}
		# Slightly <10 to avoid rounding issues
	expect_true(spans_10fold(limiter(0.1)))
	expect_true(spans_10fold(limiter(0.5)))
	expect_true(spans_10fold(limiter(2)))
	expect_true(spans_10fold(limiter(10)))
})


# Breaks =======================================================================

test_that("breaks functions return functions", {
	expect_true(is.function(breaks_log10()))
})

test_that("log10 breaks include 1", {
	get_breaks <- breaks_log10()
	expect_true(any(get_breaks(c(0.2, 2)) == 1))
	expect_true(any(get_breaks(c(0.1, 10)) == 1))
	expect_true(any(get_breaks(c(2e-2, 2e2)) == 1))
	expect_true(any(get_breaks(c(2e-3, 2e4)) == 1))
})

test_that("at least four log10 breaks visible", {
	get_breaks <- breaks_log10()
	trial_values <- list(c(0.2, 2), c(0.1, 10), c(2e-2, 2e2), c(2e-3, 3e4))
	for (values in trial_values) {
		breaks <- get_breaks(values)
		breaks <- breaks[breaks >= min(values) & breaks <= max(values)]
		expect_true(length(breaks) >= 4)
	}
})

# TODO: Test n_min, n_max args


# Labels =======================================================================

test_that("label functions return functions", {
	expect_true(is.function(label_fraction()))
	expect_true(is.function(label_log10()))
})

