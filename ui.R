options(StringAsFactors=F)
jscode <-
  '$(document).on("shiny:connected", function(e) {
var jsWidth = screen.width;
Shiny.onInputChange("GetScreenWidth",jsWidth);
});
'
appCSS <- "
#loading-content {
position: absolute;
background: #000000;
opacity: 0.9;
z-index: 100;
left: 0;
right: 0;
height: 100%;
text-align: center;
color: #FFFFFF;
}
"




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
    menuItem("Main tab", tabName = "dashboard", icon = icon("list-alt"))
    , menuItem("Severity Parameters", tabName = "cmsrpt_tabs", icon = icon("table"))
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
            wellPanel(
              uiOutput("geninfo")
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
                uiOutput('sev_main_ui')
              )
            )
    )
    )
)

dashboardPage(header, sidebar, body, skin = "black")