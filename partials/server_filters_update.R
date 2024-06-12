#------------------------------------------------------------------------------#
# Update genus and species filters
#------------------------------------------------------------------------------#
# Update genus with town selection
observe({
  print("In genus update filter")
  selection <- trees_sf %>%
    st_drop_geometry() %>%
    filter(town %in% input$which_town) %>%
    select(genus) %>%
    unique() %>%
    arrange(genus) %>%
    pull()
  
  updateSelectInput(inputId = "which_genus", choices = selection, selected = selection)
})

# Update species with town selection
observe({
  print("In species update filter")
  selection <- trees_sf %>%
    st_drop_geometry() %>%
    filter(town %in% input$which_town) %>%
    filter(genus %in% input$which_genus) %>%
    select(species) %>%
    unique() %>%
    arrange(species) %>%
    pull()

  updateSelectInput(inputId = "which_species", choices = selection, selected = selection)
})

#------------------------------------------------------------------------------#
# numericInputs for trees filtering with var range : 
#------------------------------------------------------------------------------#
# Reactive values
var_select_values <- reactiveValues(
  min_input_range_min_val = NULL,
  min_input_range_max_val = NULL,
  max_input_range_min_val = NULL,
  max_input_range_max_val = NULL,
  min_val = NULL,
  max_val = NULL
)

# Update range_min_val according to var selection and other filters
observeEvent({
  input$which_town
  input$which_genus
  input$which_species
  input$which_var
}, {
  print("In range_min_val update filter")
  min <- trees_sf %>%
    st_drop_geometry() %>%
    filter(town %in% input$which_town) %>%
    filter(genus %in% input$which_genus) %>%
    filter(species %in% input$which_species) %>%
    select(!!input$which_var) %>%
    min(na.rm = TRUE)
  
  # range_min_val of min and max numericInput 
  var_select_values$min_input_range_min_val <- min
  var_select_values$max_input_range_min_val <- min
  
  # update value of var_select_min with min value
  updateNumericInput(inputId = "var_select_min",
                     value = min)
})

# Update range_max_val according to var selection and other filters
observeEvent({
  input$which_town
  input$which_genus
  input$which_species
  input$which_var
}, {
  print("In range_max_val update filter")
  max <- trees_sf %>%
    st_drop_geometry() %>%
    filter(town %in% input$which_town) %>%
    filter(genus %in% input$which_genus) %>%
    filter(species %in% input$which_species) %>%
    select(!!input$which_var) %>%
    max(na.rm = TRUE)
  
  # range_max_val of min and max numericInput 
  var_select_values$min_input_range_max_val <- max
  var_select_values$max_input_range_max_val <- max
  
  # update value of var_select_max with max value
  updateNumericInput(inputId = "var_select_max",
                     value = max)
})

# Update reactiveValues with user input in min numericInput
observeEvent(input$var_select_min, {
  print("In min_val update")
  var_select_values$min_val <- input$var_select_min
  var_select_values$max_input_range_min_val <- input$var_select_min
},
ignoreInit = TRUE)

# Update reactiveValues with user input in max numericInput
observeEvent(input$var_select_max, {
  print("In max_val update")
  var_select_values$max_val <- input$var_select_max
  var_select_values$min_input_range_max_val <- input$var_select_max
},
ignoreInit = TRUE)

# Dynamic min numericInput rendering : step value change according to var
output$var_select_min <- renderUI(
  if (input$which_var == "diameter_m") {
    numericInput(inputId = "var_select_min",
                 label = "Minimum",
                 min = var_select_values$min_input_range_min_val,
                 max = var_select_values$min_input_range_max_val,
                 value = var_select_values$min_val,
                 step = 0.1
    )
  } else if (input$which_var == "plantation_date") {
    numericInput(inputId = "var_select_min",
                 label = "Minimum",
                 min = var_select_values$min_input_range_min_val,
                 max = var_select_values$min_input_range_max_val,
                 value = var_select_values$min_val,
                 step = 1
    )
  } else {
    numericInput(inputId = "var_select_min",
                 label = "Minimum",
                 min = var_select_values$min_input_range_min_val,
                 max = var_select_values$min_input_range_max_val,
                 value = var_select_values$min_val,
                 step = 1
    )
  }
)

# Dynamic max numericInput rendering : step value change according to var
output$var_select_max <- renderUI(
  if (input$which_var == "diameter_m") {
    numericInput(inputId = "var_select_max", 
                 label = "Maximum", 
                 min = var_select_values$max_input_range_min_val,
                 max = var_select_values$max_input_range_max_val,
                 value = var_select_values$max_val,
                 step = 0.1
    )
  } else if (input$which_var == "plantation_date") {
    numericInput(inputId = "var_select_max", 
                 label = "Maximum", 
                 min = var_select_values$max_input_range_min_val,
                 max = var_select_values$max_input_range_max_val,
                 value = var_select_values$max_val,
                 step = 1
    )
  } else {
    numericInput(inputId = "var_select_max", 
                 label = "Maximum", 
                 min = var_select_values$max_input_range_min_val,
                 max = var_select_values$max_input_range_max_val,
                 value = var_select_values$max_val,
                 step = 1
    )
  }
)