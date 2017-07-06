rm(list = ls())
library(shiny)
library(shinydashboard)
library(shinyjs)
library(dplyr)
#library(RDocumentation)

options(StringAsFactors=F)

source("Severity Simulator.R")
source('distribution getter.R')

###load ui functions
lapply(file.path('ui functions/', list.files('ui functions/')), source)

###load simulators
lapply(file.path('simulators/', list.files('simulators/')), source)


##list simulators available
simulators <- c('vanila')

R_version <- paste0(R.version$major, ".", R.version$minor)

loaded_distrs <- bind_rows(mapply(get_parameters, pckg= get_all_dist_in_session()$Package, 
                                  distr = get_all_dist_in_session()$distr,  SIMPLIFY = F))

sim_pars_list <- c('sev', 'rpt_dt', 'pay_dt', 'pay_adequecy', 'recovery_dt')

R_doc_url <- "https://www.rdocumentation.org/packages/"

get_help_url <- function(pkg, func) {
  
  if (tolower(func) %in% c('gamma')) func <- paste0(func, "Dist")
  if (tolower(func) %in% c('lnorm')) func <- 'Lognormal'
    
  paste0(R_doc_url, pkg, "/versions/", packageVersion(pkg), '/topics/', func)
}
