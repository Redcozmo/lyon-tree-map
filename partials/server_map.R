output$map <- renderLeaflet({
  print("In renderLeaflet map")
  map <- leaflet(trees()) %>%
    
    # Tiles providers
    addTiles(group = "OSM (default)") %>%
    addProviderTiles(providers$OpenTopoMap, group = "OpenTopoMap") %>%
    addProviderTiles(providers$GeoportailFrance.orthos, group = "GeoportailFrance.orthos") %>%
    addProviderTiles(providers$Thunderforest.MobileAtlas, group = "Thunderforest.MobileAtlas") %>%
    addProviderTiles(providers$Stadia.StamenWatercolor, group = "StamenWatercolor") %>%
    addProviderTiles(providers$Stadia.StamenToner, group = "StamenToner") %>%
    addProviderTiles(providers$Stadia.StamenTonerLite, group = "StamenTonerLite") %>%
    
    # Layers control
    addLayersControl(
      baseGroups = c("OSM (default)",
                     "OpenTopoMap",
                     "GeoportailFrance.orthos",
                     "Thunderforest.MobileAtlas",
                     "StamenWatercolor",
                     "StamenToner",
                     "StamenTonerLite"),
      overlayGroups = c("communes"),
      options = layersControlOptions(collapsed = TRUE)
    ) %>%
    
    # Map fullscrean
    leaflet.extras::addFullscreenControl() %>%
    
    # Trees mark
    addCircleMarkers(
      radius = 0.5,
      opacity = 1,
      color = "#007a57",
      label = ~common_name,
      layerId = ~ tree_id
    )
  
  # Add buffer if géolocalisation selection
  if(input$which_loc_sel == "Par géolocalisation") {
    print("In renderLeaflet map --> Par géolocalisation")
    print(values$loc_click)
    req(values$loc_click)
    map %>% addCircles(lng = values$loc_click$lng,
                       lat = values$loc_click$lat,
                       radius = values$radius,
                       fill = FALSE)
  }
  
  # Add town administrative boundaries if town selection
  else if(input$which_loc_sel == "Par communes") {
    print("In renderLeaflet map --> Par communes")
    new_town_name_sel <- town_update$new_town_name[which(town_update$old_town_name %in% input$which_town)]
    print(paste("new_town_name_sel", paste(new_town_name_sel, collapse = ', '), sep = ' : '))
    print(boundaries %>% dplyr::filter(town %in% new_town_name_sel))
    map %>% addPolylines(data = boundaries %>% dplyr::filter(town %in% new_town_name_sel),
                         color = "black",
                         opacity = 1,
                         fillOpacity = 0,
                         weight = 1.5,
                         group = "communes")
  }
  else {
    print("In renderLeaflet map --> Else ?")
    map
  }
})