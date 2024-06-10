output$searchmap <- renderLeaflet({
  print("In renderLeaflet searchmap")
  leaflet(boundaries) %>%
    setView(lng = 4.85, lat = 45.75, zoom = 10) %>%
    addPolylines(color = "red",
                 fillOpacity = 0,
                 weight = 2) %>%
    
    # Add providers
    addProviderTiles(
      provider = providers$Stadia.StamenTerrain,
      layerId = "Stadia.StamenTerrain",
      options = providerTileOptions(noWrap = TRUE)) %>%
    
    # Map search parameters
    leaflet.extras::addSearchOSM(options = searchOptions()) %>%
    leaflet.extras::addControlGPS(options = gpsOptions(position = "topleft", activate = TRUE,
                                                       autoCenter = TRUE, maxZoom = 10,
                                                       setView = TRUE))
})

# Update radius size value
observe({
  print("In obseve")
  values$radius <- req(input$search_radius)
  print(paste("Rayon",
              if(!is.null(values$radius)) {
                values$radius
              } else { "values$radius n'existe pas" }, sep = " : "))
})

# Update radius map on searchmap
observeEvent(input$search_radius, {
  print("In obseve input$search_radius")
  req(input$search_radius)
  req(input$searchmap_click)
  print(paste("Rayon",
              if(!is.null(values$radius)) {
                values$radius
              } else { "values$radius n'existe pas" }, sep = " : "))
  leafletProxy('searchmap') %>%
    removeShape(layerId = "position_marker") %>%
    addCircles(lng = values$loc_click$lng,
               lat = values$loc_click$lat,
               radius = values$radius,
               layerId = "position_marker")
}, ignoreInit = TRUE)

# GPS location
observe({
  print("In obseve input$searchmap_locationfound")
  val <- req(input$searchmap_locationfound)
  values$loc_found <- data.frame(lng = val$lng,
                                 lat = val$lat)
  print(paste("Loc found",
              if(!is.null(values$loc_found)) {
                values$loc_found
              } else { "values$loc_found n'existe pas" }, sep = " : "))
})

# Location click by user
observe({
  print("In obseve input$searchmap_click")
  val <- req(input$searchmap_click)
  values$loc_click <- data.frame(lng = val$lng,
                                 lat = val$lat)
  print(paste("Loc click",
              paste(
                paste("lng", values$loc_click$lng, sep = "="),
                paste("lat", values$loc_click$lat, sep = "="),
                sep = ";"
              ),
              sep = " : "))
  leafletProxy('searchmap') %>%
    clearMarkers() %>%
    removeShape(layerId = "position_marker") %>%
    setView(lng = values$loc_click$lng, lat = values$loc_click$lat, zoom = 13) %>%
    addMarkers(lng = values$loc_click$lng,
               lat = values$loc_click$lat) %>%
    addCircles(lng = values$loc_click$lng,
               lat = values$loc_click$lat,
               radius = values$radius,
               layerId = "position_marker")
}) %>%
  bindEvent(input$searchmap_click)

# Print result of gps location found
output$locfound <- renderText({ paste("Loc found",
                                      if(!is.null(values$loc_found)) {
                                        values$loc_found
                                      } else { "values$loc_found n'existe pas" }, sep = " : ")
})

# Print result of click location found
output$locclick <- renderText({ paste(paste("Loc click",
                                            paste(
                                              paste("lng", values$loc_click$lng, sep = "="),
                                              paste("lat", values$loc_click$lat, sep = "="),
                                              sep = ";"
                                            ),
                                            sep = " : "))
})