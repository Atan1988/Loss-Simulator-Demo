sev_main_UI_func <- function() {

  wellPanel(
     lapply(sim_pars_list, para_wellP_func)
  )
  
}

para_wellP_func <- function(variables) {
  wellPanel(
    fluidRow(
      column(5, helpText(paste0("Please select distribution for ", variables)))
    ),
    fluidRow(
      column(2, selectInput(paste0(variables, '_distr'), 'distribution', 
                            choices = unique(loaded_distrs$distr), selected = ""))
      , column(1, uiOutput(paste0(variables, '_help_ui')) )
    ), 
    fluidRow(
      column(10, uiOutput(paste0(variables, '_pars_ui')))
    )
  )
}

para_selInput_func <- function(pars, parvars, vars) {
      if (grepl("_dt|accdt|rptdt|paydt", pars)) return(dateInput(inputId = paste0(vars, '_', pars), 
                                               label = pars, value =  parvars))
  
      numericInput(inputId = paste0(vars, '_', pars), 
                   label = pars, 
                   value = parvars)  
}

set_all_pars_func <- function(vars_f, output, revals, input) {
    output[[paste0(vars_f, '_pars_ui')]] <- renderUI(local({
      print(vars_f)
      wellPanel(mapply(para_selInput_func, pars = revals[[paste0(vars_f, '_Parnames')]],
                       parvars = revals[[paste0(vars_f, '_Parvars')]],
                       MoreArgs = list(vars = vars_f), SIMPLIFY = F))
    }))

    output[[paste0(vars_f, '_help_ui')]] <- renderUI(local({
      if (is.null(revals$sev_Package)) return(NULL)

      print(revals$Package)

      on_click <- paste0("window.open('", get_help_url(revals[[paste0(vars_f, '_Package')]],
                                                       input[[paste0(vars_f, '_distr')]]), "','_blank')")
      print(on_click)

      actionButton(paste0(vars_f, '_help'), 'Help?',
                   onclick = on_click)
    }))
}


