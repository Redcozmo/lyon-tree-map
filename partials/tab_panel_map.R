tab_panel_map <- 
  tabPanel(title = "Carte",
           value = "map",
           p(),
           box(width = 8,
               leafletOutput(outputId = "map")
           ),
           
           box(title = "Arbre sélectionné",
               status = "success",
               solidHeader = FALSE,
               width = 4,
               uiOutput("infos")
           )
  )