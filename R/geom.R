# Geoms for ggplot2 ============================================================

# Points that are more readable when they overlap
geom_point_overlap <- function(shape = 21, ..., na.rm = TRUE) {
	if (shape %in% 21:25) {
		args <- list(...)
		args$fill <- NULL
		list(
			ggplot2::geom_point(shape = shape, ..., na.rm = na.rm),
			do.call(
				ggplot2::geom_point,
				c(list(shape = shape, fill = NA, na.rm = na.rm), args)
			)
		)
	} else {
		ggplot2::geom_point(shape = shape, ..., na.rm = na.rm)
	}
}
