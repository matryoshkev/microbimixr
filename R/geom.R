# Geoms for ggplot2 ============================================================

# Points that are more readable when they overlap
geom_point_overlap <- function(..., na.rm = TRUE) {
	args <- list(...)
	args$fill <- NULL
	list(
		ggplot2::geom_point(..., na.rm = na.rm),
		do.call(ggplot2::geom_point, c(args, list(fill = NA, na.rm = na.rm)))
	)
}
