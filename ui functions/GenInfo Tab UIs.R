geninfo_UI_func <- function() {
  wellPanel(
      fluidRow(
        column(2, numericInput("frq", "Number of Claims", value = 100, min = 1))
        , column(2, dateInput('accdt', 'Accident Date Begins', value = as.character(Sys.Date())))
      ),
      fluidRow(
        column(2, selectInput('sim_sel', "Select a Simulator", choices = simulators))
        , column(2, actionButton('run_sim', "Run"))
        , column(2, downloadButton('download_db', "Download"))
      ), 
      fluidRow(
        column(10, uiOutput("sim_pars_ui"))
      )
  )
}

set_sim_pars_func <- function(df) {
  wellPanel(mapply(para_selInput_func, pars = df$Parnames,
                   parvars = df$Parvars, MoreArgs = list(vars = 'sim'), SIMPLIFY = F))
}