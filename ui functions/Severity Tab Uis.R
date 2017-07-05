sev_main_UI_func <- function() {

  wellPanel(
      fluidRow(
        column(2, selectInput('distr', 'distribution', 
                              choices = unique(loaded_distrs$distr), selected = ""))
        , column(1, uiOutput('help_ui'))
      ), 
      fluidRow(
        column(10, uiOutput('sev_pars_ui'))
      )
  )
}

para_selInput_func <- function(pars, parvars) {
      numericInput(inputId = paste0('sev_', pars), 
                   label = pars, 
                   value = parvars)  
}