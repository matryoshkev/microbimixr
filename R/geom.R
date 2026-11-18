# Geoms for ggplot2 ============================================================

#' Points with improved overlap readability
#'
#' `geom_point_overlap()` is a version of `geom_point()` from ggplot2 that is
#' easier to see when points overlap.
#' It first draws points as normal then draws points again with no fill.
#' It only has a visible effect on point shapes 21-25.
#'
#' @param ... Arguments passed to [ggplot2::geom_point()]
#'
#' @returns A geom layer for use with the ggplot2 package
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
}

# Point geom for ggplot that defaults to filled-grey circles
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


# Plot helper ==================================================================

# Add data points to plot
add_data_points <- function(
	plot,
	color = waiver(),
	fill = waiver(),
	shape = waiver(),
	size = waiver(),
	drop_NA = waiver()
) {
	# Collect arguments for geom_point_overlap()
	# Don't include if not given so we can use a ggplot scale instead
	args <- mget(ls())  # List of arguments to this function
	point_args <- list()
	for (arg_name in c("color", "fill", "shape", "size")) {
		arg_value <- args[[arg_name]]
		if (!is_waiver(arg_value) && !is.null(arg_value)) {
			point_args[[arg_name]] <- arg_value
		}
	}
	if (!is_waiver(drop_NA) && !is.null(drop_NA)) {point_args$na.rm <- drop_NA}

	# Add to plot
	plot + do.call(geom_point_overlap, point_args)
}
