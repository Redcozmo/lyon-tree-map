# Update genus with town selection
observe({
  print("In update filter")
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
  print("In update filter")
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