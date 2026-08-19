test_that("axis defaults run without warning", {
	expect_no_warning(scale_x_initial_fraction())
	expect_no_warning(scale_x_initial_ratio())
	expect_no_warning(scale_y_fitness())
	expect_no_warning(scale_y_fitness_total())
	expect_no_warning(scale_y_fitness_ratio())
})

test_that("axes accept expression() names", {
	expect_no_warning(scale_x_initial_fraction(name = expression(x)))
	expect_no_warning(scale_x_initial_ratio(name = expression(x)))
	expect_no_warning(scale_y_fitness(name = expression(x)))
	expect_no_warning(scale_y_fitness_total(name = expression(x)))
	expect_no_warning(scale_y_fitness_ratio(name = expression(x)))
})

test_that("axes accept specified breaks", {
	expect_no_warning(scale_x_initial_fraction(breaks = c(0, 0.5, 1)))
	log_breaks <- c(0.1, 1, 10, 30)
	expect_no_warning(scale_x_initial_ratio(breaks = log_breaks))
	expect_no_warning(scale_y_fitness(breaks = log_breaks))
	expect_no_warning(scale_y_fitness_total(breaks = log_breaks))
	expect_no_warning(scale_y_fitness_ratio(breaks = log_breaks))
})
