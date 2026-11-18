# Color & fill =================================================================

# Dark and light derivatives of the Okabe-Ito color palette
# (accessible for people with color vision deficiency)
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

# Scales for ggplot2
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

# Palettes for ggplot2
pal_strain_color <- function() {
	scales::pal_manual(okabe_ito_dark, type = "colour")
}
pal_strain_fill <- function() {
	scales::pal_manual(okabe_ito_light, type = "colour")
}


# Plot helpers =================================================================

# Add strain color & fill scales to plot
add_color_strain <- function(plot, color = waiver(), fill = waiver()) {
	# Set default or user-specified values
	color_scale <-
		if (is.null(color) || is_waiver(color)) {
			scale_color_strain()
		} else {
			ggplot2::scale_color_manual(name = NULL, values = color)
		}
	fill_scale <-
		if (is.null(fill) || is_waiver(fill)) {
			scale_fill_strain()
		} else {
			ggplot2::scale_fill_manual(name = NULL, values = fill)
		}

	# Add to plot
	plot +
		ggplot2::aes(color = .data$strain, fill = .data$strain) +
		color_scale +
		fill_scale
}

# Add color & fill scales to plot: strain A, strain B, total fitness
add_color_strain_total <- function(plot, 	color = waiver(), fill = waiver()) {
	# Set default values
	if (is_waiver(color) || is.null(color)) {
		color <- c(okabe_ito_dark[1], okabe_ito_dark[2], "black")
	}
	if (is_waiver(fill) || is.null(fill)) {
		fill <- c(okabe_ito_light[1], okabe_ito_light[2], "gray65")
	}

	# Add to plot
	plot +
		ggplot2::aes(color = .data$strain, fill = .data$strain) +
		ggplot2::scale_color_manual(name = NULL, values = color, na.value = NA) +
		ggplot2::scale_fill_manual(name = NULL, values = fill, na.value = NA)
}
