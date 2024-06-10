################################################################################
# Server : server.R
################################################################################
server <- function(input, output) {
  
  # Source server partials
  source("partials/server_valueboxes.R", local = TRUE)
  source("partials/server_map.R", local = TRUE)
  source("partials/server_searchmap.R", local = TRUE)
  source("partials/server_selected_tree.R", local = TRUE)
  source("partials/server_filters_update.R", local = TRUE)
  source("partials/server_trees_reactive.R", local = TRUE)
  source("partials/server_datatable.R", local = TRUE)

  # Reactive values initializing
  values <- reactiveValues(
    trees_nb = NULL,
    genus_sel_nb = NULL,
    tallest_tree = NULL,
    largest_tree = NULL,
    loc_found = NULL,
    loc_click = NULL,
    radius = NULL,
    color_palette = NULL,
  )

  # Render html : solution 2 with tag does not work
  #------------------------------------------------------------------------------#
  # output$rmd_analysis_report <- renderUI({
  #   tags$iframe(src = paste(getwd(), "analysis_report.html", sep = '/'), height = 600, width = 600)
  # })
}

