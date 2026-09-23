# Themes for ggplot2 ===========================================================

# Want default plots to look good AND be robust to modification
# So we want a light touch here

theme_microbimixr <- function() {
	# Text for medium-sized figures in papers
	ggplot2::theme(text = ggplot2::element_text(size = 9))
}

theme_strain_fitness <- function(facet_strains = FALSE) {
	output <- theme_microbimixr() +	ggplot2::theme(
		# Simple legend on top
		legend.position = "top",
		legend.box.spacing = grid::unit(0, "points"),
		legend.key.size = grid::unit(14, "points"),
	)
	if (is.logical(facet_strains) && facet_strains == TRUE) {
		# No facet strips, more space between facets
		output <- output + ggplot2::theme(
			strip.text.x = ggplot2::element_blank(),
			strip.background.x = ggplot2::element_blank(),
			panel.spacing.x = grid::unit(8, "points"),
		)
	}
	output
}

theme_total_fitness <- function() theme_microbimixr()

theme_fitness_ratio <- function() theme_microbimixr()
