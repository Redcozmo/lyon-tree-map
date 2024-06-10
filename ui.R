################################################################################
# User Interface : ui.R
################################################################################

# Source UI partials
source('partials/ui_tab_item_parameters.R')
source('partials/ui_tab_item_graphics.R')
source('partials/ui_tab_item_map.R')
source('partials/ui_tab_item_table.R')

# Dashboard header
#------------------------------------------------------------------------------#
header <- dashboardHeader(title = "Arbres de Lyon")

# Dashboard sidebar
#------------------------------------------------------------------------------#
sidebar <- dashboardSidebar(
  sidebarMenu(id = "sidebarmenu",
    menuItem("Paramètres", tabName = "menu_item_params"),
    menuItem("Carte", tabName = "menu_item_map"),
    menuItem("Table", tabName = "menu_item_table"),
    menuItem("Graphiques", tabName = "menu_item_graphics"),
    menuItem("Explication", tabName = "menu_item_explanation")
    # menuItem("Analyse des données", tabName = "menu_item_analysis_report")
  )
)

# Dashboard body
#------------------------------------------------------------------------------#
body <- dashboardBody(
  use_theme(mytheme),
  fluidPage(
    # For error messages CSS
    tags$head(
      tags$style(HTML("
      .shiny-output-error-validation {
        color: red;
        font-size: 1.8rem;
      }
    "))
    ),
    # For valueboxes
    tags$style(".small-box{border-radius: 5px}"),
    
    tabItems(
      ui_tab_item_parameters,
      ui_tab_item_map,
      ui_tab_item_table,
      ui_tab_item_graphics,
      tabItem(tabName = "menu_item_explanation",
              shiny::includeMarkdown(path = "pages/explanation.md")
      ),
      tabItem(tabName = "menu_item_analysis_report",
              shiny::includeMarkdown(path = "pages/analysis_report.md")
      )
    )
  )
)

# Dashboard page
#------------------------------------------------------------------------------#
ui <- dashboardPage(header, sidebar, body, skin = "blue")
