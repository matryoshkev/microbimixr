# Themes for ggplot2 ===========================================================

# Default package theme (suited to figures in papers)
theme_microbimixr <- function() {
	ggplot2::theme_grey() +
	ggplot2::theme(
		text = ggplot2::element_text(size = 9)
	)
}

# Additional options for plot_mix_fitness() (less clutter)
theme_plot_mix_fitness <- function() {
	ggplot2::theme(
		legend.title         = ggplot2::element_blank(),
		legend.background    = ggplot2::element_blank(),
		legend.direction     = "horizontal",
		legend.justification = c(0.5, 0.15),
		legend.position      = c(0.5, 1),
		strip.text           = ggplot2::element_blank(),
		strip.background     = ggplot2::element_blank()
	)
}

