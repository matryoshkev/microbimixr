# plot functions list variables missing in var_names

    Code
      plot_mix_fitness(fitness, var_names = c(strains, initial_ratio_A_B = "initial_ratio_A_B",
        fitness_A = "fitness_A", fitness_B = "fitness_B", fitness_total = "fitness_total",
        fitness_ratio_A_B = "fitness_ratio_A_B"))
    Error <rlang_error>
      initial_fraction_A missing in var_names

---

    Code
      plot_mix_fitness(fitness, var_names = c(strains, initial_fraction_A = "initial_fraction_A",
        fitness_A = "fitness_A", fitness_B = "fitness_B", fitness_total = "fitness_total",
        fitness_ratio_A_B = "fitness_ratio_A_B"))
    Error <rlang_error>
      initial_ratio_A_B missing in var_names

---

    Code
      plot_mix_fitness(fitness, var_names = c(strains, initial_fraction_A = "initial_fraction_A",
        initial_ratio_A_B = "initial_ratio_A_B", fitness_B = "fitness_B",
        fitness_total = "fitness_total", fitness_ratio_A_B = "fitness_ratio_A_B"))
    Error <rlang_error>
      fitness_A missing in var_names

---

    Code
      plot_mix_fitness(fitness, var_names = c(strains, initial_fraction_A = "initial_fraction_A",
        initial_ratio_A_B = "initial_ratio_A_B", fitness_A = "fitness_A",
        fitness_total = "fitness_total", fitness_ratio_A_B = "fitness_ratio_A_B"))
    Error <rlang_error>
      fitness_B missing in var_names

---

    Code
      plot_mix_fitness(fitness, var_names = c(strains, initial_fraction_A = "initial_fraction_A",
        initial_ratio_A_B = "initial_ratio_A_B", fitness_A = "fitness_A", fitness_B = "fitness_B",
        fitness_ratio_A_B = "fitness_ratio_A_B"))
    Error <rlang_error>
      fitness_total missing in var_names

---

    Code
      plot_mix_fitness(fitness, var_names = c(strains, initial_fraction_A = "initial_fraction_A",
        initial_ratio_A_B = "initial_ratio_A_B", fitness_A = "fitness_A", fitness_B = "fitness_B",
        fitness_total = "fitness_total"))
    Error <rlang_error>
      fitness_ratio_A_B missing in var_names

---

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

# plot functions report missing data columns

    Code
      plot_mix_fitness(data.frame(initial_ratio_A_B = 1, fitness_A = 5, fitness_B = 10,
        fitness_total = 10, fitness_ratio_A_B = 10), var_names = fitness_vars_default())
    Error <rlang_error>
      Column `initial_fraction_A` not found in data
    Code
      plot_mix_fitness(data.frame(initial_fraction_A = 0.5, fitness_A = 5, fitness_B = 10,
        fitness_total = 10, fitness_ratio_A_B = 10), var_names = fitness_vars_default())
    Error <rlang_error>
      Column `initial_ratio_A_B` not found in data
    Code
      plot_mix_fitness(data.frame(initial_fraction_A = 0.5, initial_ratio_A_B = 1,
        fitness_B = 10, fitness_total = 10, fitness_ratio_A_B = 10), var_names = fitness_vars_default())
    Error <rlang_error>
      Column `fitness_A` not found in data
    Code
      plot_mix_fitness(data.frame(initial_fraction_A = 0.5, initial_ratio_A_B = 1,
        fitness_A = 5, fitness_total = 10, fitness_ratio_A_B = 10), var_names = fitness_vars_default())
    Error <rlang_error>
      Column `fitness_B` not found in data
    Code
      plot_mix_fitness(data.frame(initial_fraction_A = 0.5, initial_ratio_A_B = 1,
        fitness_A = 5, fitness_B = 10, fitness_ratio_A_B = 10), var_names = fitness_vars_default())
    Error <rlang_error>
      Column `fitness_total` not found in data
    Code
      plot_mix_fitness(data.frame(initial_fraction_A = 0.5, initial_ratio_A_B = 1,
        fitness_A = 5, fitness_B = 10, fitness_total = 10), var_names = fitness_vars_default())
    Error <rlang_error>
      Column `fitness_ratio_A_B` not found in data

---

    Code
      plot_strain_fitness(data.frame(fitness_A = 5, fitness_B = 10), var_names = fitness_vars_default())
    Error <rlang_error>
      Column `initial_fraction_A` not found in data
    Code
      plot_strain_fitness(data.frame(fitness_A = 5, fitness_B = 10), var_names = fitness_vars_default(),
      mix_scale = "ratio")
    Error <rlang_error>
      Column `initial_ratio_A_B` not found in data
    Code
      plot_strain_fitness(data.frame(fitness_B = 10, initial_fraction_A = 0.5),
      var_names = fitness_vars_default())
    Error <rlang_error>
      Column `fitness_A` not found in data
    Code
      plot_strain_fitness(data.frame(fitness_A = 5, initial_fraction_A = 0.5),
      var_names = fitness_vars_default())
    Error <rlang_error>
      Column `fitness_B` not found in data
    Code
      plot_strain_fitness(data.frame(), var_names = fitness_vars_default())
    Error <rlang_error>
      Column `fitness_A` not found in data
      * Column `fitness_B` not found in data
      * Column `initial_fraction_A` not found in data

---

    Code
      plot_total_group_fitness(data.frame(fitness_total = 10), var_names = fitness_vars_default())
    Error <rlang_error>
      Column `initial_fraction_A` not found in data
    Code
      plot_total_group_fitness(data.frame(fitness_total = 10), var_names = fitness_vars_default(),
      mix_scale = "ratio")
    Error <rlang_error>
      Column `initial_ratio_A_B` not found in data
    Code
      plot_total_group_fitness(data.frame(initial_fraction_A = 0.5), var_names = fitness_vars_default())
    Error <rlang_error>
      Column `fitness_total` not found in data
    Code
      plot_total_group_fitness(data.frame(), var_names = fitness_vars_default())
    Error <rlang_error>
      Column `fitness_total` not found in data
      * Column `initial_fraction_A` not found in data

---

    Code
      plot_within_group_fitness(data.frame(fitness_ratio_A_B = 5), var_names = fitness_vars_default())
    Error <rlang_error>
      Column `initial_fraction_A` not found in data
    Code
      plot_within_group_fitness(data.frame(fitness_ratio_A_B = 0.5), var_names = fitness_vars_default(),
      mix_scale = "ratio")
    Error <rlang_error>
      Column `initial_ratio_A_B` not found in data
    Code
      plot_within_group_fitness(data.frame(initial_fraction_A = 0.5), var_names = fitness_vars_default())
    Error <rlang_error>
      Column `fitness_ratio_A_B` not found in data
    Code
      plot_within_group_fitness(data.frame(), var_names = fitness_vars_default())
    Error <rlang_error>
      Column `fitness_ratio_A_B` not found in data
      * Column `initial_fraction_A` not found in data

