geninfo_UI_func <- function() {
  wellPanel(
      fluidRow(
        column(2, numericInput("frq", "Number of Claims", value = 100, min = 1))
        , column(2, dateInput('accdt', 'Accident Date Begins', value = as.character(Sys.Date())))
      ),
      fluidRow(
        column(2, selectInput('sim_sel', "Select a Simulator", choices = simulators))
      )
  )
}