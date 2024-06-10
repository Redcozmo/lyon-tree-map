ui_tab_item_map <- 
  tabItem(tabName = "menu_item_map",
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