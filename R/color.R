# Color & fill for ggplot2 =====================================================

strain_colors <- c(
	"brown3",         # red
	"lightseagreen",  # light blue
	"darkorchid3",    # purple
	"goldenrod3",     # yellow
	"blue1",          # dark blue
	"orchid3",        # pink
	"darkorange3",    # orange
	# "seagreen3",
	"grey45"          # greyscale
)

strain_fills <- c(
	"indianred1",      # red
	"darkslategray1",  # light blue
	"orchid2",         # purple
	"yellow1",         # yellow
	"dodgerblue1",     # dark blue
	"plum1",           # pink
	"darkgoldenrod1",  # orange
	# "seagreen1",
	"grey70"           # greyscale
)

scale_color_strain <- function(..., aesthetics = "color") {
	ggplot2::discrete_scale(
		...,
		aesthetics = aesthetics,
		scale_name = "strain_color",
		palette = pal_strain_color()
	)
}

scale_fill_strain <- function(..., aesthetics = "fill") {
	ggplot2::discrete_scale(
		...,
		aesthetics = aesthetics,
		scale_name = "strain_fill",
		palette = pal_strain_fill()
	)
}

# Color palette for scales and ggplot2
pal_strain_color <- function() {
	scales::pal_manual(strain_colors, type = "colour")
}

# Fill palette for scales and ggplot2
pal_strain_fill <- function() {
	scales::pal_manual(strain_fills, type = "colour")
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
