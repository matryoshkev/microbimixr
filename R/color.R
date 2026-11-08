# Color & fill for ggplot2 =====================================================

okabe_ito_light <- c(
	"#EFA722",  # orange
	"#6CC4FA",  # light blue
	"#5ACCA0",  # green
	"#F6EA4C",  # yellow
	"#579BDB",  # dark blue
	"#F17639",  # red
	"#EC99C6",  # pink
	"#A3A3A3"   # grey
)

okabe_ito_dark <- c(
	"#A97404",  # orange
	"#4997C3",  # light blue
	"#058561",  # green
	"#8A8200",  # yellow
	"#0072B2",  # dark blue
	"#A94A08",  # red
	"#A85B86",  # pink
	"#696969"   # grey
)

scale_color_strain <- function(name = NULL, ...) {
	ggplot2::discrete_scale(
		name = name,
		...,
		palette = pal_strain_color(),
		aesthetics = "color"
	)
}

scale_fill_strain <- function(name = NULL, ...) {
	ggplot2::discrete_scale(
		name = name,
		...,
		palette = pal_strain_fill(),
		aesthetics = "fill"
	)
}

# Color palette for scales and ggplot2
pal_strain_color <- function() {
	scales::pal_manual(okabe_ito_dark, type = "colour")
}

# Fill palette for scales and ggplot2
pal_strain_fill <- function() {
	scales::pal_manual(okabe_ito_light, type = "colour")
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
