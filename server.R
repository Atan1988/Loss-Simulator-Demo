shinyServer(function(input, output, session) {
  revals <- reactiveValues()
  revals$status_value <- 0
  
  shinyjs::hide(id = "loading-content", anim = TRUE, animType = "fade") 
  shinyjs::show("app-content")
  
  output$geninfo <- renderUI(geninfo_UI_func())
  
  output$sev_main_ui <- renderUI(sev_main_UI_func())
  
  output$help_ui <- renderUI({
    if (is.null(revals$Package)) return(NULL)
    
    print(revals$Package)
    
    on_click <- paste0("window.open('", get_help_url(revals$Package, input$distr), "','_blank')")
    print(on_click)
    
    actionButton('sev_help', 'Help?', 
                 onclick = on_click)
  })
  
  output$sev_pars_ui <- renderUI({
     wellPanel(mapply(para_selInput_func, pars = revals$Parnames, parvars = revals$Parvars, SIMPLIFY = F))
  })
  
  
  observe({
     if (is.null(input$distr)) return(NULL)
    
     revals$Package <- unique(as.character(loaded_distrs$package[loaded_distrs$distr == input$distr]))
       
     Parnames <- loaded_distrs$Parnames[loaded_distrs$distr == input$distr]
     Parvars <- loaded_distrs$Parvars[loaded_distrs$distr == input$distr]
     
     Parnames <- Parnames[!is.na(Parnames)]
     Parvars <- Parvars[1:length(Parnames[!is.na(Parnames)])]
     
     revals$Parnames <- Parnames
     revals$Parvars <- Parvars
     
     print(revals$Parnames)
     print(revals$Parvars)
  })
  
  
})