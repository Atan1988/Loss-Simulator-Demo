shinyServer(function(input, output, session) {
  revals <- reactiveValues()
  revals$status_value <- 0
  
  shinyjs::hide(id = "loading-content", anim = TRUE, animType = "fade") 
  shinyjs::show("app-content")
  
  output$geninfo <- renderUI(geninfo_UI_func())
  
  output$sim_pars_ui <- renderUI({
                if (is.null(revals$sim_pars_df)) return(NULL)
                set_sim_pars_func(revals$sim_pars_df)
    })
  
  output$sev_main_ui <- renderUI(sev_main_UI_func())
  
  lapply(sim_pars_list, set_all_pars_func, output = output,  revals = revals, input = input)
  
  observe({
     if (is.null(input$sev_distr)) return(NULL)
    
     for (vars in sim_pars_list) {
       revals[[paste0(vars, '_Package')]] <- loaded_distrs$package[loaded_distrs$distr == 
                                                  input[[paste0(vars, '_distr')]]] %>% as.character %>% unique
       
       revals[[paste0(vars, '_Parnames')]] <- loaded_distrs$Parnames[loaded_distrs$distr == 
                                                                       input[[paste0(vars, '_distr')]]]
       revals[[paste0(vars, '_Parvars')]] <- loaded_distrs$Parvars[loaded_distrs$distr == 
                                                                     input[[paste0(vars, '_distr')]]]
       
     }
      get_pars_revals <- function(variables) {
            
            pars_revals <- unlist(lapply(revals[[paste0(variables, '_Parnames')]], 
                              function(x) {input[[paste0(variables, '_', x)]]})) 
            
            if (!is.vector(pars_revals) | 
                (length(revals[[paste0(variables, '_Parnames')]]) != length(pars_revals))) return(NULL)
            
            nas <- which(!is.na(pars_revals))
            
            pars_revals <- pars_revals[nas] %>%
                              as.matrix %>% t %>% as.data.frame
            colnames(pars_revals) <- revals[[paste0(variables, '_Parnames')]][nas]
            return(pars_revals)
      }
      
      
     print(revals$sev_Parnames)
     
     par_list <- lapply(sim_pars_list, function(x) { get_pars_revals(x)})
     names(par_list) <- paste0('parvars_', sim_pars_list)
     par_list <- par_list
     
     distr_list <- lapply(sim_pars_list, function(x) input[[paste0(x, '_', 'distr')]])
     names(distr_list) <- paste0('distr_', sim_pars_list)
     distr_list <- distr_list
     #revals$sev_pars <- get_pars_revals('sev')
     revals$par_list <- append(distr_list, par_list)
     
     ##print the distributions
     print(revals$par_list)
  
  })
  
  observe({
    if (is.null(input$sim_sel)) return(NULL)
    revals$sim_pars_df <- get_simulator_args(input$sim_sel)
  })
  
  observe({
    if (is.null(revals$sim_pars_df)) return(NULL)
    sim_pars <- revals$sim_pars_df$Parnames
    
    revals$sim_vars <- lapply(sim_pars, function(x) {input[[paste0('sim_', x)]]})
    #print( revals$sim_vars)
    
  })
  
  observeEvent(input$run_sim, {
    quantile_results <- quantile_simulator_main(input$sim_sel, revals$sim_vars)
    pars_to_sim <- append(quantile_results, revals$par_list)
   
    print(pars_to_sim)
    
    revals$simulated_data <- do.call(severity_simulator, args = pars_to_sim)
    
    revals$downdable <- file.path(tempdir(),"simulated losses.csv")
    #write.csv(revals$simulated_data, revals$downdable, row.names = F)
    
    print(revals$simulated_data)
  })
  
  output$download_db <- 
    downloadHandler(
      # For PDF output, change this to "report.pdf"
      #filename = paste(revals$provname, ".html", sep = ""),
      filename = paste0("simulated losses", ".csv"), 
      content = function(file) {
        print(revals$simulated_data)
        write.csv(revals$simulated_data, file, row.names = F)
      },  
      contentType = 'text/plain'
    )
  
})