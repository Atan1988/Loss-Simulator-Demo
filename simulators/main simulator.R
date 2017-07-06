quantile_simulator_main <- function(sim_func_str, parm_list) {
  sim_func <- get(paste0("quantile_simulator_", sim_func_str))
  do.call(sim_func, parm_list)
}

get_simulator_args <- function(sim_func_str) {
  sim_func <- get(paste0("quantile_simulator_", sim_func_str))
  get_args(quantile_simulator_vanila)
}

