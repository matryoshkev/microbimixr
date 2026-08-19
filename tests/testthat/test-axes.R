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
