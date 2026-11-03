# Color & fill for ggplot2 =====================================================

scale_color_strain <- function(..., aesthetics = "color") {
	ggplot2::discrete_scale(
		...,
		aesthetics = aesthetics,
		scale_name = "strain_color",
		palette = scales::pal_brewer(palette = "Dark2")
	)
}

scale_fill_strain <- function(..., aesthetics = "fill") {
	ggplot2::discrete_scale(
		...,
		aesthetics = aesthetics,
		scale_name = "strain_fill",
		palette = scales::pal_brewer(palette = "Set2")
	)
}

# Default colors
# color_strain_A <- function() {"#8C2F00"}  # Dark red
color_strain_A <- function() {"#AB6C02"}  # Dark tan
color_strain_B <- function() {"#00259E"}  # Dark blue
color_group    <- function() {"black"}

# Default fill colors
# fill_strain_A  <- function() {"#F08A7D"}  # Pale red
fill_strain_A  <- function() {"#FDE725"}  # Warm yellow
fill_strain_B  <- function() {"#77A1D1"}  # Medium blue (desaturated)
fill_group     <- function() {"gray65"}
