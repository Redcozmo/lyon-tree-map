################################################################################
# Server : server.R
################################################################################
server <- function(input, output) {

  # Reactive values initializing
  values <- reactiveValues(
    trees_nb = NULL,
    genus_sel_nb = NULL,
    map_parameters = NULL, # unused for the moment
    loc_found = NULL,
    loc_click = NULL,
    radius = NULL,
    color_palette = NULL,
  )

  # Update active tabsetpanel when submit selection
  observeEvent(input$selection_submit, {
    print("In input$selection_submit")
    updateTabsetPanel(inputId = "tabpanels",
                      selected = "map")
  })

  # Observe selected tree
  selected_tree <- reactive({
    print("In reactive selected_tree")
    print(input$map_marker_click$id)
    if (!is.null(input$map_marker_click)) {
      res <- trees() %>%
        dplyr::filter(tree_id == input$map_marker_click$id)

      ## Selection de l'arbre ----------------------------------------------------
      if (nrow(res) == 0) {
        return(NULL)
      } else {
        return(res)
      }
    } else {
      return(NULL)
    }
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

  # Update of species number "values$trees_nb" for town selection
  observe({
    print("In obseve values$trees_nb")
    values$trees_nb <- trees_sf %>%
      st_drop_geometry() %>%
      filter(town %in% input$which_town) %>%
      count() %>%
      as.numeric()
  })

  # Update of genus number "values$genus_sel_nb" for town selection
  observe({
    print("In obseve values$genus_sel_nb")
    values$genus_sel_nb <- trees_sf %>%
      st_drop_geometry() %>%
      filter(town %in% input$which_town) %>%
      select(genus) %>%
      unique() %>%
      count() %>%
      as.numeric()
  })

  # Paramétrisation de la carte en fonction de la variable demandée
  eventReactive(input$selection_submit, {
    print("In obseve values$map_parameters")
    values$map_parameters <- list(

    )
  }, ignoreNULL = FALSE)

  # Adaptation de la palette en fonction de la sélection de la variable et de la couleur
  # observeEvent(input$selection_submit, {
  #
  #   color_palette <- input$which_color
  #   var_values <- trees_sf %>% st_drop_geometry() %>% dplyr::select(!!input$which_var)
  #   test_var_type <- var_values %>% pull()
  #
  #   # Palette de couleurs pour type factor
  #   if(is.factor(test_var_type)) {
  #     pal <- colorFactor(
  #       palette = color_palette,
  #       domain = var_values
  #     )
  #   }
  #
  #   # Palette de couleurs pour type numeric
  #   if(is.numeric(test_var_type)) {
  #     pal <- colorNumeric(
  #       palette = color_palette,
  #       domain = var_values
  #     )
  #   }
  #
  #   values$color_palette <- pal
  # })

  # Reactive object for sf trees with submit button event
  trees <- eventReactive(input$selection_submit, {
    print("In trees eventReactive")
    if(input$which_loc_sel == "Par géolocalisation") {
      print("In trees eventReactive --> Par géolocalisation")
      # Dans le cas d'une sélection par Par géolocalisation
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

    } else if(input$which_loc_sel == "Par communes") {
      print("In trees eventReactive --> ville")
      # Dans le cas d'une sélection par villes
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

  #------------------------------------------------------------------------------#
  # Filters update
  #------------------------------------------------------------------------------#

  # Mettre a jour le filtre des genres en fonction de la sélection des villes
  observe({
    print("In update filter")
    selection <- trees_sf %>%
      st_drop_geometry() %>%
      filter(town %in% input$which_town) %>%
      select(genus) %>%
      unique() %>%
      arrange(genus) %>%
      # droplevels() %>% # For delete unused levels
      pull()
    # levels()
    updateSelectInput(inputId = "which_genus", choices = selection, selected = selection)
  })

  # Mettre a jour le filtre des espèces en fonction de la selection des villes
  observe({
    print("In update filter")
    selection <- trees_sf %>%
      st_drop_geometry() %>%
      filter(town %in% input$which_town) %>%
      filter(genus %in% input$which_genus) %>%
      select(species) %>%
      unique() %>%
      arrange(species) %>%
      # droplevels() %>% # For delete unused levels
      pull()
    # levels()
    updateSelectInput(inputId = "which_species", choices = selection, selected = selection)
  })

  #------------------------------------------------------------------------------#
  # Outputs
  #------------------------------------------------------------------------------#

  # Text rendering
  #------------------------------------------------------------------------------#
  output$trees_nb <- renderText({ paste("Nombre d'arbres pour cette sélection de villes", values$trees_nb, sep = " : ") })
  output$genus_nb <- renderText({ paste("Nombre de genres pour cette sélection de villes", values$genus_sel_nb, sep = " : ") })

  # Map of trees
  #------------------------------------------------------------------------------#
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
      # %>%
      # Legend
      # addLegend("bottomright",
      #           pal = values$color_palette,
      #           values = ~eval(as.symbol(input$which_var)),
      #           title = "Titre",
      # )

    # Add buffer if Par géolocalisation selection
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

  # Selection info panel
  #------------------------------------------------------------------------------#
  output$infos <- renderUI({
    print("In renderUI --> infos")
    tree <- selected_tree()
    # If no tree selection
    if (is.null(tree)) {
      return(p("Cliquez sur un arbre pour avoir ses informations"))
    }
    infos <- div(HTML(
      tree_infos(tree)
    ))
  })

  # Mini searchmap
  #------------------------------------------------------------------------------#
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

  # Print result of gps location found
  #------------------------------------------------------------------------------#
  output$locfound <- renderText({ paste("Loc found",
                                        if(!is.null(values$loc_found)) {
                                          values$loc_found
                                        } else { "values$loc_found n'existe pas" }, sep = " : ")
  })

  # Print result of click location found
  #------------------------------------------------------------------------------#
  output$locclick <- renderText({ paste(paste("Loc click",
                                              paste(
                                                paste("lng", values$loc_click$lng, sep = "="),
                                                paste("lat", values$loc_click$lat, sep = "="),
                                                sep = ";"
                                              ),
                                              sep = " : "))
  })

  # Histogram panel
  #------------------------------------------------------------------------------#
  # histogramServer(id = "hist1", x = trees, var = "height")
  # histogramServer(id = "hist2", x = trees, var = "height")
  # histogramServer(id = "hist3", x = trees, var = "height")

  # # Rendu des histogrammes : old version
  # output$graph_1 <- renderPlot({
  #   x <- trees() %>%
  #     sf::st_drop_geometry() %>%
  #     dplyr::select(!!input$which_var) %>%
  #     pull()
  #   bins <- seq(min(x), max(x), length.out = input$bins_1 + 1)
  #
  #   hist(x, breaks = bins, col = "#007bc2", border = "white",
  #        xlab = "Hauteur (en m)",
  #        ylab = "Fréquence",
  #        main = "Hauteur des arbres")
  # })
  #
  # output$graph_2 <- renderPlot({
  #   x <- trees() %>%
  #     sf::st_drop_geometry() %>%
  #     dplyr::select(!!input$which_var) %>%
  #     pull()
  #   bins <- seq(min(x), max(x), length.out = input$bins_2 + 1)
  #
  #   hist(x, breaks = bins, col = "#007bc2", border = "white",
  #        xlab = "Année",
  #        ylab = "Fréquence",
  #        main = "Années de plantation")
  # })
  #
  # output$graph_3 <- renderPlot({
  #   x <- trees() %>%
  #     sf::st_drop_geometry() %>%
  #     dplyr::select(!!input$which_var) %>%
  #     pull()
  #   bins <- seq(min(x), max(x), length.out = input$bins_3 + 1)
  #
  #   hist(x, breaks = bins, col = "#007bc2", border = "white",
  #        xlab = "Année",
  #        ylab = "Fréquence",
  #        main = "Années de plantation")
  # })

  # Data table panel
  #------------------------------------------------------------------------------#
  output$resume_table <- DT::renderDT({ trees_by_genus })
  output$table <- DT::renderDT({
    trees <- trees() %>% sf::st_drop_geometry()
    return(trees)
  })

  # Render html : solution 2 with tag does not work
  #------------------------------------------------------------------------------#
  # output$rmd_analysis_report <- renderUI({
  #   tags$iframe(src = paste(getwd(), "analysis_report.html", sep = '/'), height = 600, width = 600)
  # })
}

