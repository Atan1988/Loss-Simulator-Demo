library(dplyr)

get_distr <- function(library_name) {
  all_functions <- ls(paste0("package:", library_name))
  
  d_funcs <- all_functions[substr(all_functions, 1, 1) == "d"]
  p_funcs <- all_functions[substr(all_functions, 1, 1) == "p"]
  q_funcs <- all_functions[substr(all_functions, 1, 1) == "q"]
  r_funcs <- all_functions[substr(all_functions, 1, 1) == "r"]
  
  d_funcs <- substr(d_funcs, 2, nchar(d_funcs))
  p_funcs <- substr(p_funcs, 2, nchar(p_funcs))
  q_funcs <- substr(q_funcs, 2, nchar(q_funcs))
  r_funcs <- substr(r_funcs, 2, nchar(r_funcs))
  
  distr <- intersect(intersect(intersect(d_funcs, p_funcs), q_funcs), r_funcs)
  
  if (length(distr) == 0) return(NULL) else return(  data.frame(Package = library_name,  distr = distr))

}

get_all_dist_in_session <- function(all_packages = .packages()) {
  bind_rows(lapply(all_packages, get_distr))
}

get_args <- function(func) {
  args <- unlist(as.list(args(func)))
  
  get_par_val <- function(x) {
    ifelse(args[[x]]=="" | class(args[[x]]) == "call", NA, args[[x]])
  }
  
  args_df <- data.frame(Parnames = names(args), 
                        Parvars = unlist(sapply(1:length(args), get_par_val)))
  
  return(args_df)
}

get_parameters <- function(pckg, distr, type = "q") {
  d <- get(paste0(type, distr))
  args <- unlist(as.list(args(d)))
  
  get_par_val <- function(x) {
    ifelse(args[[x]]=="" | class(args[[x]]) == "call", NA, args[[x]])
  }
  
  args_df <- data.frame(package = pckg, 
                        distr = distr,
                        Parnames = names(args), 
                        Parvars = unlist(sapply(1:length(args), get_par_val)))
  args_df %>% filter(!Parnames %in% c('x', 'p', 'q', 'n'))
  
}