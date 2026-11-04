# Strain colors ----------------------------------------------------------------

test_that("strain colors are legible and distinct", {
	skip(message = "Visual test")

	# Make dataset with strain combos
	fitness_myxo <- calculate_mix_fitness(data_smith_2010, var_names_smith_2010)
	fitness_AB <- fitness_CD <- fitness_EF <- fitness_GH <- fitness_myxo
	fitness_AB$name_A <- "A"
	fitness_AB$name_B <- "B"
	fitness_CD$name_A <- "C"
	fitness_CD$name_B <- "D"
	fitness_EF$name_A <- "E"
	fitness_EF$name_B <- "F"
	fitness_GH$name_A <- "G"
	fitness_GH$name_B <- "H"
	fitness <- rbind(fitness_AB, fitness_CD, fitness_EF, fitness_GH)
	fitness$strains <- paste(fitness$name_A, "+", fitness$name_B)

	# Plot strain fitness for each combo
	dev.new(width = 4.1, height = 3.5, units = "in")
	plot_strain_fitness(fitness) +
		ggplot2::geom_smooth(
			method = "loess", formula = y ~ x, na.rm = TRUE,
			se = FALSE, linewidth = 0.5
		) +
		ggplot2::facet_wrap(ggplot2::vars(strains), ncol = 2) +
		ggplot2::theme(legend.position = "right")
})

test_that("strain colors are distinct in CIELUV vL space", {
	skip(message = "Visual test")
	dev.new(width = 5.5, height = 2.5)

	# Make data frame of stroke/fill colors
	my_colors <- data.frame(color = strain_colors, fill = strain_fills)
	my_colors <-
		ggplot2::luv_colours |>
		dplyr::filter(col %in% strain_colors) |>
		dplyr::rename(color = col, color_L = L, color_u = u, color_v = v) |>
		dplyr::left_join(my_colors, by = "color")
	my_colors <-
		ggplot2::luv_colours |>
		dplyr::filter(col %in% strain_fills) |>
		dplyr::rename(fill = col, fill_L = L, fill_u = u, fill_v = v) |>
		dplyr::left_join(my_colors, by = "fill")

	# Plot strokes and points in CIELUV vL space
	plot_stroke <-
		my_colors |>
		dplyr::select(color, color_v, color_L) |>
		dplyr::rename(v = color_v, L = color_L) |>
		ggplot2::ggplot(ggplot2::aes(x = v/1000, y = L/1000, color = color)) +
		ggplot2::geom_point(shape = 1, size = 3, stroke = 1.2) +
		ggplot2::scale_color_identity() +
		ggplot2::labs(x = "Blue/yellow (CIELUV v)", y = "Lightness (CIELUV L)")
	plot_fill <-
		my_colors |>
		dplyr::select(color, fill, fill_v, fill_L) |>
		dplyr::rename(v = fill_v, L = fill_L) |>
		ggplot2::ggplot(
			ggplot2::aes(x = v/1000, y = L/1000, color = color, fill = fill)
		) +
		ggplot2::geom_point(shape = 21, size = 3) +
		ggplot2::geom_point(shape = 21, size = 3, fill = NA) +
		ggplot2::scale_color_identity() +
		ggplot2::scale_fill_identity() +
		ggplot2::labs(x = "Blue/yellow (CIELUV v)", y = "Lightness (CIELUV L)")
	plot_stroke + plot_fill + plot_layout(axes = "collect")

})


# TODO: Test that strain A always shown as same color
# regardless of alphabetical ordering of A/B strain names
