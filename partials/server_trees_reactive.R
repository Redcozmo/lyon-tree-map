# Update active menuItem when submit selection
observeEvent(input$selection_submit, {
  print("In input$selection_submit")
  shinydashboard::updateTabItems(inputId = "sidebarmenu",
                                 selected = "menu_item_map")
})

# Reactive object for sf trees with submit selection
trees <- eventReactive(input$selection_submit, {
  print("In trees eventReactive")
  
  # In case of geolocalisation selection
  if(input$which_loc_sel == "Par géolocalisation") {
    print("In trees eventReactive --> Par géolocalisation")
    loc_point <- st_as_sf(values$loc_click,
                          coords = c("lng", "lat"),
                          crs = 4326) %>%
      st_transform(crs_project)
    trees <- trees_sf %>%
      dplyr::filter(genus %in% input$which_genus) %>%
      dplyr::filter(species %in% input$which_species) %>%
      sf::st_intersection(st_buffer(loc_point, dist = values$radius))
    print(paste("Nombre d'arbres sélectionnés", length(trees$common_name), sep = " : "))
    
    validate(
      need(expr = length(trees$common_name) != 0,
           message = "La zone de recherche ne contient aucun arbre correspndant aux taxons sélectionnés. \nVeuillez choisir une autre localisation dans la Métropole ou augmenter la rayon de recherche ou changer les taxons.")
    )
    
    return(trees)
    
    # In case of town selection
  } else if(input$which_loc_sel == "Par communes") {
    print("In trees eventReactive --> ville")
    print(input$which_town)
    print(input$which_genus)
    print(input$which_species)
    trees <- trees_sf %>%
      dplyr::filter(town %in% input$which_town) %>%
      dplyr::filter(genus %in% input$which_genus) %>%
      dplyr::filter(species %in% input$which_species)
    return(trees)
  } else {
    print("autre condition ?")
  }
},
ignoreNULL = FALSE,
ignoreInit = FALSE,
)