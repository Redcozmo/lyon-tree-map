ui_tab_item_parameters <- 
  tabItem(tabName = "menu_item_params",
          fluidRow(
            box(
              width = 4,
              status = "success",
              title = p("1. Sélection géographique", style = 'font-weight:bold;'),
              selectInput(inputId = "which_loc_sel",
                          label = "Type de sélection :",
                          choices = c("Par communes", "Par géolocalisation"),
                          selected = "Par communes"),
              
              conditionalPanel(
                condition = "input.which_loc_sel == 'Par communes'",
                selectInput(inputId = "which_town",
                            label = "Selection par ville :",
                            choices = which_town_choices,
                            selected = which_town_default,
                            multiple = TRUE,
                            selectize = FALSE),
                textOutput(outputId = "trees_nb"),
                textOutput(outputId = "genus_nb")
              ),
              
              conditionalPanel(
                condition = "input.which_loc_sel == 'Par géolocalisation'",
                leafletOutput("searchmap"),
                textOutput(outputId = "locfound"),
                textOutput(outputId = "locclick"),
                sliderInput(
                  inputId = "search_radius",
                  label = "Rayon (en m) :",
                  min = 50,
                  max = 1000,
                  value = 100,
                  step = 50
                )
              )
            ),
            
            box(
              width = 4,
              status = "success",
              title = p("2. Sélection des taxons", style = 'font-weight:bold;'),
              selectInput(inputId = "which_genus",
                          label = "Selection des genres :",
                          choices = which_genus_choices,
                          selected = which_genus_default,
                          multiple = TRUE,
                          selectize = FALSE,
                          size = 5
              ),
              
              selectInput(inputId = "which_species",
                          label = "Selection des espèces :",
                          choices = which_species_choices,
                          selected = which_species_default,
                          multiple = TRUE,
                          selectize = FALSE,
                          size = 5),
            ),
            
            box(
              width = 4,
              title = p("3. Filtrer par variable", style = 'font-weight:bold;'),
              varSelectInput(
                inputId = "which_var",
                label = "Selection de la variable :",
                selected = "height_m",
                data = trees_sf %>%
                  st_drop_geometry() %>%
                  dplyr::select(c("crown_diameter_m",
                                  "diameter_m",
                                  "height_m",
                                  "plantation_date")
                  )
              ),
              uiOutput("var_select_min"),
              uiOutput("var_select_max")
            ),
            
            box(
              title = "Conseil",
              status = "warning",
              width = 4,
              solidHeader = TRUE,
              "L'affichage des 98 998 arbres peut être lent.",
              br(),
              "Il est donc conseillé de réduire ce nombre en sélectionnant des villes et/ou des taxons."
            ),
            
            box(
              title = p("4. Validation", style = 'font-weight:bold;'),
              width = 4,
              status = "success",
              solidHeader = TRUE,
              actionButton(
                inputId = "selection_submit",
                label = "Valider les sélections",
                width = '100%',
                class = "btn"
              )
            )
          ),
          fluidRow(
            valueBoxOutput("valueBox_trees_nb"),
            valueBoxOutput("valueBox_genus_sel_nb"),
            valueBoxOutput("valueBox_tallest"),
            valueBoxOutput("valueBox_largest")
          )
  )