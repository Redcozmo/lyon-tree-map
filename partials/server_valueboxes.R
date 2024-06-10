# Update of species number "values$trees_nb" for town selection
observe({
  print("In observe values$trees_nb")
  values$trees_nb <- trees_sf %>%
    st_drop_geometry() %>%
    filter(town %in% input$which_town) %>%
    count() %>%
    as.numeric()
})

# Update of genus number "values$genus_sel_nb" for town selection
observe({
  print("In observe values$genus_sel_nb")
  values$genus_sel_nb <- trees_sf %>%
    st_drop_geometry() %>%
    filter(town %in% input$which_town) %>%
    select(genus) %>%
    unique() %>%
    count() %>%
    as.numeric()
})

# Update of genus number "values$valueBox_tallest" for town selection
observe({
  print("In observe values$valueBox_tallest")
  values$tallest_tree <- trees_sf %>%
    st_drop_geometry() %>%
    filter(town %in% input$which_town) %>%
    select(height_m) %>%
    max()
})

# Update of genus number "values$valueBox_largest" for town selection
observe({
  print("In observe values$valueBox_largest")
  values$largest_tree <- trees_sf %>%
    st_drop_geometry() %>%
    filter(town %in% input$which_town) %>%
    select(diameter_m) %>%
    max()
})

# ValueBoxes ouptuts
output$valueBox_trees_nb <- renderValueBox({
  valueBox(
    value = values$trees_nb,
    subtitle = "Nombre d'arbres",
    color = "purple"
  )
})
output$valueBox_genus_sel_nb <- renderValueBox({
  valueBox(
    value = values$genus_sel_nb,
    subtitle = "Nombre de genres",
    color = "orange"
  )
})
output$valueBox_tallest <- renderValueBox({
  valueBox(
    value = values$tallest_tree,
    subtitle = "Le plus haut",
    color = "blue"
  )
})
output$valueBox_largest <- renderValueBox({
  valueBox(
    value = values$largest_tree,
    subtitle = "Le plus large (tronc)",
    color = "maroon"
  )
})