# plot functions list variables missing in var_names

    Code
      plot_strain_fitness(fitness, var_names = c(strains, fitness_A = "fitness_A",
        fitness_B = "fitness_B"))
    Error <rlang_error>
      initial_fraction_A missing in var_names

---

    Code
      plot_strain_fitness(fitness, mix_scale = "ratio", var_names = c(strains,
        fitness_A = "fitness_A", fitness_B = "fitness_B"))
    Error <rlang_error>
      initial_ratio_A_B missing in var_names

---

    Code
      plot_strain_fitness(fitness, var_names = c(strains, initial_fraction_A = "initial_fraction_A",
        fitness_B = "fitness_B"))
    Error <rlang_error>
      fitness_A missing in var_names

---

    Code
      plot_strain_fitness(fitness, var_names = c(strains, initial_fraction_A = "initial_fraction_A",
        fitness_A = "fitness_A"))
    Error <rlang_error>
      fitness_B missing in var_names

---

    Code
      plot_total_group_fitness(fitness, var_names = c(strains, fitness_total = "fitness_total"))
    Error <rlang_error>
      initial_fraction_A missing in var_names

---

    Code
      plot_total_group_fitness(fitness, mix_scale = "ratio", var_names = c(strains,
        fitness_total = "fitness_total"))
    Error <rlang_error>
      initial_ratio_A_B missing in var_names

---

    Code
      plot_total_group_fitness(fitness, var_names = c(strains, initial_fraction_A = "initial_fraction_A"))
    Error <rlang_error>
      fitness_total missing in var_names

---

    Code
      plot_within_group_fitness(fitness, var_names = c(strains, fitness_ratio_A_B = "fitness_ratio_A_B"))
    Error <rlang_error>
      initial_fraction_A missing in var_names

---

    Code
      plot_within_group_fitness(fitness, mix_scale = "ratio", var_names = c(strains,
        fitness_ratio_A_B = "fitness_ratio_A_B"))
    Error <rlang_error>
      initial_ratio_A_B missing in var_names

---

    Code
      plot_within_group_fitness(fitness, var_names = c(strains, initial_fraction_A = "initial_fraction_A"))
    Error <rlang_error>
      fitness_ratio_A_B missing in var_names

