# Geoms for ggplot2 ============================================================

#' Points with better overlap readability
#'
#' This is a small modification to `geom_point()` from ggplot2 that makes data
#' points easier to see when they overlap. `geom_point_overlap()` first draws
#' points as normal then draws points again with no fill. It only has a visible
#' effect effect on points with separate color and fill (shapes 21-25).
#'
#' @param ... Arguments passed to `geom_point()`.
#'
#' @examples
#' library(ggplot2)
#' fig <- ggplot(data = airquality) + aes(x = Temp, y = Ozone)
#' fig + geom_point(shape = 21, size = 2, fill = "grey", na.rm = TRUE)
#' fig + geom_point_overlap(shape = 21, size = 2, fill = "grey", na.rm = TRUE)
#'
#' @export
#'
geom_point_overlap <- function(...) {
	args <- list(...)
	args$fill <- NULL
	list(
		ggplot2::geom_point(...),
		do.call(ggplot2::geom_point, c(args, list(fill = NA)))
	)
}
