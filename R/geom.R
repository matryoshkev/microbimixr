# Geoms ========================================================================

# Points that are more readable when they overlap
geom_point_overlap <- function(shape = 21, ..., na.rm = TRUE) {
	if (shape %in% 21:25) {
		list(
			ggplot2::geom_point(shape = shape, ..., na.rm = na.rm),
			ggplot2::geom_point(shape = shape, fill = NA, ..., na.rm = na.rm)
		)
	} else {
		ggplot2::geom_point(shape = shape, ..., na.rm = na.rm)
	}
}
