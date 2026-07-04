# Color & fill for ggplot2 =====================================================

# Default colors
color_strain_A <- function() { "tan4" }
color_strain_B <- function() { "lightsteelblue4" }
color_group    <- function() { "black" }
fill_strain_A  <- function() { "tan" }
fill_strain_B  <- function() { "lightsteelblue" }
fill_group     <- function() { "gray65" }

# Color points by strain/total-group
scale_color_strain <- function(
	values = c(color_strain_A(), color_strain_B(), color_group()), ...
) {
	ggplot2::scale_color_manual(values = values, ...)
}

# Fill points by strain/total-group
scale_fill_strain <- function(
	values = c(fill_strain_A(), fill_strain_B(), fill_group()), ...
) {
	ggplot2::scale_fill_manual(values = values, ...)
}
