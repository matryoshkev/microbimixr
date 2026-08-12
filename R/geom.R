# Geoms for ggplot2 ============================================================

#' Points with improved overlap readability
#'
#' `geom_point_overlap()` is a version of `geom_point()` from ggplot2 that is
#' easier to see when points overlap.
#' It first draws points as normal then draws points again with no fill.
#' It only has a visible effect on point shapes 21-25.
#'
#' @param ... Arguments passed to [ggplot2::geom_point()].
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

# Helpers ======================================================================

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

# Failed attempt at simpler implementation
#
# geom_point_overlap <- function(
# 	data = NULL,
# 	mapping = NULL,
# 	stat = "identity",
# 	position = "identity",
# 	...,
# 	na.rm = FALSE,
# 	show.legend = NA,
# 	inherit.aes = TRUE
# ) {
# 	ggplot2::layer(
# 		data = data,
# 		mapping = mapping,
# 		stat = stat,
# 		geom = GeomPointOverlap,
# 		position = position,
# 		show.legend = show.legend,
# 		inherit.aes = inherit.aes,
# 		params = list(na.rm = na.rm, ...)
# 	)
# }
#
# GeomPointOverlap <- ggplot2::ggproto(
# 	`_class` = "GeomPointOverlap",
# 	`_inherit` = ggplot2::GeomPoint,
# 	required_aes = c("x", "y"),
#
# 	default_aes = ggplot2::aes(
# 		shape = 21,
# 		colour = "black",
# 		fill = "grey65",
# 		size = 2,
# 		alpha = NA,
# 		stroke = 0.5
# 	),
#
# 	draw_panel = function(data, panel_params, coord) {
# 		# na.rm = FALSE, flipped_aes = FALSE) {
# 		coords <- coord$transform(data, panel_params)
# 		filled <- grid::pointsGrob(
# 			x = coords$x,
# 			y = coords$y,
# 			pch = coords$shape,
# 			size = grid::unit(coords$size, "mm"),
# 			gp = grid::gpar(
# 				col = alpha(coords$colour, 0),
# 				fill = alpha(coords$fill, coords$alpha),
# 				lwd = coords$stroke * .pt / 2
# 				# fontsize = coords$size * .pt + coords$stroke * .stroke / 2
# 			)
# 		)
# 		open <- grid::pointsGrob(
# 			x = coords$x,
# 			y = coords$y,
# 			pch = coords$shape,
# 			size = grid::unit(coords$size, "mm"),
# 			gp = grid::gpar(
# 				col = alpha(coords$colour, coords$alpha),
# 				fill = NA,
# 				lwd = coords$stroke * .pt / 2
# 				# fontsize = coords$size * .pt + coords$stroke * .stroke / 2
# 			)
# 		)
# 		grid::grobTree(filled, open)
# 	}
# )
# # TODO: This isn't drawing stroke on outside of point like geom_point does

