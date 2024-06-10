ui_tab_item_table <- 
  tabItem(tabName = "menu_item_table",
          fluidRow(
            column(12,
                   DT::DTOutput('table')
            )
          )
  )