ui_tab_item_graphics <- 
  tabItem(tabName = "menu_item_graphics",
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