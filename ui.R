################################################################################
# User Interface : ui.R
################################################################################

# Source UI files
source('partials/tab_panel_parameters.R')
# source('partials/tab_panel_graphics.R')
source('partials/tab_panel_map.R')
source('partials/tab_panel_table.R')

# Dashboard header
#------------------------------------------------------------------------------#
header <- dashboardHeader(title = "Arbres de Lyon")

# Dashboard sidebar
#------------------------------------------------------------------------------#
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Carte", tabName = "dashboard"),
    menuItem("Explication", tabName = "explanation")
    # menuItem("Analyse des données", tabName = "analysis_report")
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
    
    tabItems(
      tabItem(tabName = "dashboard",
              
              # Application title
              titlePanel(h1("")),
              
              tabsetPanel(id = "tabpanels",
                          p(),
                          tab_panel_parameters,
                          # tab_panel_graphics,
                          tab_panel_map,
                          tab_panel_table
              )
      ),
      tabItem(tabName = "explanation",
              p(),
              shiny::includeMarkdown(path = "pages/explanation.md")
      ),
      tabItem(tabName = "analysis_report",
              shiny::includeMarkdown(path = "pages/analysis_report.md")
      )
    )
  )
)

# Dashboard page
#------------------------------------------------------------------------------#
ui <- dashboardPage(header, sidebar, body, skin = "blue")
