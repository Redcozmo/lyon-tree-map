################################################################################
# Modules : modules.R
# In order to structure the application
################################################################################

# Module selectVarServer
selectVarServer <- function(id, data, filter = is.numeric) {
  stopifnot(is.reactive(data))
  stopifnot(!is.reactive(filter))
  
  moduleServer(id, function(input, output, session) {
    observeEvent(data(), {
      updateSelectInput(session, "var", choices = find_vars(data(), filter))
    })
    
    reactive(data()[[input$var]])
  })
}

# Module histogramUI
histogramUI <- function(id) {
  print("In histogramUI function")
  tagList(
    plotOutput(outputId = NS(id, "hist")),
    sliderInput(
      inputId = NS(id, "bins"),
      label = "Nombre de classes :",
      min = 1,
      max = 50,
      value = 30
    )
  )
}

# Module histogramServer
histogramServer <- function(id, x, var, title = reactive("Histogram")) {
  # print("In histogramServer function")
  # print(paste("x", x(), sep = " : "))
  # stopifnot(is.reactive(x))
  # stopifnot(is.reactive(title))
  
  moduleServer(id, function(input, output, session) {
    output$hist <- renderPlot({
      req(is.numeric(x()))
      main <- paste0(title(), " [", input$bins, "]")
      x <- x() %>% 
        sf::st_drop_geometry() %>% 
        dplyr::select(var) %>%
        pull()
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      hist(x, breaks = bins, col = "#007bc2", border = "white",
           xlab = var,
           ylab = "Fréquence",
           main = main)
    })
  })
}

