# Geoms for ggplot2 ============================================================

#' Points with better overlap readability
#'
#' This is a small modification to `geom_point()` from ggplot2 that makes data
#' points easier to see when they overlap. `geom_point_overlap()` first draws
#' points as normal then draws points again with no fill. It only has a visible
#' effect on points with separate color and fill (shapes 21-25).
#'
#' @param ... Arguments passed to `geom_point()`.
#'
#' @examples
#' library(ggplot2)
#' fig <- ggplot(data = airquality, mapping = aes(x = Temp, y = Ozone))
#' fig + geom_point(shape = 21, size = 3, fill = "grey65", na.rm = TRUE)
#' fig + geom_point_overlap(size = 3, na.rm = TRUE)
#'
#' @export
#'
geom_point_overlap <- function(...) {
	front_args <- list(...)
	front_args$fill <- NULL
	list(
		geom_point_microbimixr(...),
		do.call(geom_point_microbimixr, c(front_args, list(fill = NA)))
	)
	# There's probably a better way to do this
}

# Helpers ======================================================================

# Make point geom for ggplot that defaults to filled-grey circles

GeomPointMicrobimixr <- ggplot2::ggproto(
	`_class` = "GeomPointMicrobimixr",
	`_inherit` = ggplot2::GeomPoint,
	default_aes = ggplot2::aes(
		shape = 21,
		color = "black",
		size = 1.5,
		fill = "grey65",
		alpha = 1,
		stroke = 0.5
	)
)

geom_point_microbimixr <- function(
	data = NULL,
	mapping = NULL,
	stat = "identity",
	position = "identity",
	...,
	na.rm = FALSE,
	show.legend = NA,
	inherit.aes = TRUE
) {
	ggplot2::layer(
		data = data,
		mapping = mapping,
		stat = stat,
		geom = GeomPointMicrobimixr,
		position = position,
		show.legend = show.legend,
		inherit.aes = inherit.aes,
		params = list(na.rm = na.rm, ...)
	)
}
