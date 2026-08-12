# Create var_names_smith_2010
library(usethis)
var_names_smith_2010 <-	c(
	initial_number_A = "initial_cells_evolved",
	initial_number_B = "initial_cells_ancestral",
	final_number_A = "final_spores_evolved",
	final_number_B = "final_spores_ancestral",
	name_A = "GVB206.3",
	name_B = "GJV10"
)
usethis::use_data(var_names_smith_2010, overwrite = TRUE)
