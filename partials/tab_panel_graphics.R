tab_panel_graphics <- 
  tabPanel(title = "Graphiques",
         value = "graphics",
         fluidRow(
           column(width = 4,
                  wellPanel(
                    # titlePanel("Histogramme"),
                    histogramUI("hist1")
                  )
           ),
           
           column(width = 4,
                  wellPanel(
                    # titlePanel("Histogramme"),
                    histogramUI("hist2")
                  )
           ),
           
           column(width = 4,
                  wellPanel(
                    # titlePanel("Histogramme"),
                    histogramUI("hist3")
                  )
           )
         )
)