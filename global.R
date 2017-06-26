rm(list = ls())

options(StringAsFactors=F)

source("Severity Simulator.R")
source('distribution getter.R')

loaded_distrs <- bind_rows(lapply(get_all_dist_in_session()$distr, get_parameters))