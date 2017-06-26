header <- dashboardHeader(title = "Loss Simulator"
                          # , tags$li(a(href = 'http://10.141.24.188/',
                          #           icon("power-off"),
                          #           title = "Back to Apps Home"),
                          #         class = "dropdown"),
                          # tags$li(a(href = 'http://www.ironshore.com/',
                          #           img(src = 'Ironshore_Logo.png',
                          #               title = "Company Home", height = "50px"),
                          #           style = "padding-top:0px; padding-bottom:0px;", 
                          #           target="_blank"),
                          #         class = "dropdown")
)

#header <- dashboardHeader(title = "Nursing Home Data Dashboard")

sidebar <- dashboardSidebar(
  sidebarMenu(
    id = "maindash",
    menuItem("Account Information", tabName = "dashboard", icon = icon("list-alt"))
    #, menuItem("CMS Report", tabName = "cmsrpt", icon = icon("table"))
    , menuItem("CMS Report tabs", tabName = "cmsrpt_tabs", icon = icon("table"))
    #, menuItem("Quality Measures", icon = icon("fa fa-file-text"), tabName = "widgets")
    #, menuItem("Deficiencies", icon = icon("calendar"), tabName = "charts")
  )
)

body <- dashboardBody(
  useShinyjs(),
  inlineCSS(appCSS),
  tabItems(
    tabItem(tabName = "dashboard",
            h2("General Information"),
            tags$head(tags$script('
                                  var dimension = [0, 0];
                                  $(document).on("shiny:connected", function(e) {
                                  dimension[0] = window.innerWidth;
                                  dimension[1] = window.innerHeight;
                                  Shiny.onInputChange("dimension", dimension);
                                  });
                                  $(window).resize(function(e) {
                                  dimension[0] = window.innerWidth;
                                  dimension[1] = window.innerHeight;
                                  Shiny.onInputChange("dimension", dimension);
                                  });
                                  ')),
            plotOutput('status', width = "100%", height = "1px"),
            wellPanel(
              fluidRow(
                column(textInput("accname", "Account Name"), width = 2)
                , column(textInput("accnum", "Account Number"), width = 2)
                , column(dateInput("effdate", "Effective Date"), width = 2)
              )
              , fluidRow(
                column(selectizeInput("selprovnum", "Search Facility by Provider Number", 
                                      choices =c("",  provnum_lst), multiple = TRUE,
                                      selected = ""),
                       width = 2)
                , column(actionButton("runrpt1", "Submit"), width = 1)
              )
              # , fluidRow(
              #     column(12, div(rHandsontableOutput("geninfo", width = "100%"), 
              #                  style="Font-size:100%"), offset=0 )
              #   )
              , uiOutput("geninfo")
            )
            ),
    
    tabItem(tabName = "cmsrpt_tabs",
            uiOutput("cmsreport_tabs_ui"), 
            div(
              id = "loading-content",
              h2("Loading...")
            ),
            hidden(
              div(
                id = "app-content",
                uiOutput('cms_main_ui')
              )
            )
    ),
    
    tabItem(tabName = "widgets",
            h2("Quality Measures"),
            wellPanel(
              uiOutput("uiTab2_itm1")
              ,  uiOutput("uiTab2_itm3")
              ,  uiOutput("uiTab2_itm2")
              ,  plotOutput("plotTab2_itm4")
            )
            
    ),
    
    tabItem(tabName = "charts",
            #h2(textOuput("Deftitle")),
            uiOutput("Deftitle"),
            wellPanel(
              uiOutput("uiTab3_itm1")
              , plotOutput("plotTab3_itm2")
              , uiOutput("uiTab3_itm3")
              
            )
            
            
    )
            )
)

dashboardPage(header, sidebar, body, skin = "black")