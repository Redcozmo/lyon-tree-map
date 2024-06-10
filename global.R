################################################################################
# Application shiny de visualisation des arbres d'alignement de la Métropole de
# Lyon
#
# Données accessibles sur : data.grandlyon.com
# https://data.grandlyon.com/portail/fr/jeux-de-donnees/arbres-alignement-metropole-lyon/info
#

# AMELIORATIONS :
#
# - A l'affichage des arbre d'une commune, ajouter l'emprise de la commune
# - Permettre de choisir quelle variable afficher sur la carte : genre ou hauteur ou date, etc...
# - Ajouter des messages d'erreur cohérent pour l'utilisateur : https://shiny.posit.co/r/articles/improve/validation/
#  Récupérer avec les données lidar HD les hauteurs des arbres MAJ
#  Ajout d'une couche de visualisation de hauteur de canopée calculée avec LidarHD de l'IGN
#  Ajouter délai de chargement avec animation ou autre
#  Outils d'affichage en ne sélectionnant que les arbres dont la hauteur est supérieure à une valeur
#  Ajout fonctionnalité : export de la selection
#  Ajout fonctionnalité : affichage arbre via decoupe par une emprise
################################################################################

# Clear existing objects from workspace and free memory
rm(list=ls(all=TRUE));gc()

# Set working directory
# setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# getwd()

# Load libraries
library(shiny)
library(shinydashboard)
library(leaflet)
library(leaflet.extras) # For Open Street Map geocoding API
library(sf)
library(dplyr) # for pipe %>%
library(DT) # for data table
library(markdown) # for shiny::includeMarkdown
library(knitr) # for knitr::knit
library(rmarkdown)

# Source files
source("modules/functions.R")
source("modules/modules.R")
source("www/css_custom.R")
source("www/custom.css")

#  For debugging
options(shiny.error = browser)

# Set project CRS
crs_project <- 4326

# Data read
trees_sf <- sf::st_read(
  dsn = "data/trees.gpkg"
)

boundaries <- sf::st_read(
  dsn = "data/boundaries.gpkg"
)

# Le fichier contours est plus récent et comporte donc des différences avec le fichiers des arbres
setdiff(boundaries$town, trees_sf$town)
setdiff(trees_sf$town, boundaries$town)

# Tableau de correspondance entre anciennes villes et mise à jour 2024
town_update <- trees_sf %>%
  st_drop_geometry() %>%
  select(town) %>%
  unique() %>%
  filter(!is.na(town)) %>%
  arrange(town) %>%
  rename("old_town_name" = "town") %>%
  mutate(new_town_name = case_when(old_town_name %in% c("OULLINS", "PIERRE-BENITE") ~ "OULLINS-PIERRE-BENITE",
                                   grepl("LYON(.*?)E", old_town_name) ~ "LYON",
                                   .default = old_town_name))

# Check diffrences
setdiff(town_update$old_town_name, town_update$new_town_name)
setdiff(town_update$new_town_name, town_update$old_town_name)

print(head(trees_sf))

# Delete non define taxons
trees_sf_unfiltered <- trees_sf
undefine_genus <- c("Souche", "Non défini", "Emplacement libre")
undefine_common_name <- c("Souche", "Non défini", "Emplacement libre")
trees_sf <- trees_sf %>%
  filter(!is.na(species)) %>%
  filter(!common_name %in% undefine_common_name) %>%
  filter(!genus %in% undefine_genus)

# Add diameter
trees_sf <- trees_sf %>%
  mutate(diameter_m = round(perimeter_cm / (100 * 3.14159), digits = 2))

# Extract df without geometry
trees_df <- trees_sf %>%
  st_drop_geometry()

# Factoring
trees_sf$genus <- as.factor(trees_sf$genus)
trees_sf$town <- as.factor(trees_sf$town)

# Définition des paramètres globaux : global.R
which_town_choices <- c(sort(unique(trees_df$town)))
which_town_default <- which_town_choices
which_genus_choices <-
  trees_df %>%
  filter(town %in% which_town_default) %>%
  select(genus) %>%
  unique() %>%
  arrange(genus) %>%
  # droplevels() %>% # For delete unused levels
  pull()
# levels()

print(which_genus_choices)

which_genus_default <- c("Quercus")

which_species_choices <-
  trees_df %>%
  filter(town %in% which_town_default) %>%
  filter(genus %in% which_genus_default) %>%
  select(species) %>%
  unique() %>%
  arrange(species) %>%
  # droplevels() %>% # For delete unused levels
  pull()
# levels()

which_species_default <- which_species_choices

#------------------------------------------------------------------------------#
# Statistic data
#------------------------------------------------------------------------------#
print("Statistic")
trees_NA_by_col <- trees_df %>%
  summarise(across(everything(), ~ sum(is.na(.))))

undefine_trees_nb <- trees_sf_unfiltered %>%
  st_drop_geometry() %>%
  filter(is.na(species) |
           common_name %in% undefine_common_name |
           genus %in% undefine_genus) %>%
  count() %>%
  as.numeric()

# Number of trees by genus
trees_by_genus <- trees_df %>%
  group_by(genus) %>%
  summarise(n_trees_by_genus = n()) %>%
  arrange(desc(n_trees_by_genus)) %>%
  head(n = 5)

# Number of trees by species
trees_by_species <- trees_df %>%
  group_by(species) %>%
  summarise(n_trees_by_species = n()) %>%
  arrange(desc(n_trees_by_species)) %>%
  head(n = 5)

# Number of trees by common name
trees_by_common_name <- trees_df %>%
  group_by(common_name) %>%
  summarise(n_trees_by_common_name = n()) %>%
  arrange(desc(n_trees_by_common_name)) %>%
  head(n = 5)

# Number of trees by taxon : ie variety
trees_by_variety <- trees_df %>%
  group_by(variety) %>%
  summarise(n_trees_by_variety = n()) %>%
  arrange(desc(n_trees_by_variety)) %>%
  head(n = 5)

# Number of trees without taxon by town
trees_without_taxon <- trees_df %>%
  summarise(total = n(), .by = town) %>%
  arrange(desc(total))

# Number of trees without taxon
total_trees_without_taxon <- trees_df %>%
  count() %>%
  as.numeric()

# resume
trees_summary <- data.frame(
  trees_total = length(trees_df[,1]),
  town_nb = length(unique(trees_df$town)),
  genus_nb = length(unique(trees_df$genus)),
  species_nb = length(unique(trees_df$species)),
  common_name_nb = length(unique(trees_df$common_name))
)

summary(trees_df)

#------------------------------------------------------------------------------#
# Color palette functions
#------------------------------------------------------------------------------#

fpal <- colorFactor(
  palette = "Greens",
  domain = trees_sf %>% st_drop_geometry() %>% filter(town == "VILLEURBANNE") %>% select(town) %>% pull()
)

npal <- colorNumeric(
  palette = "Greens",
  domain = trees_sf %>% st_drop_geometry() %>% filter(town == "VILLEURBANNE") %>% select(height_m) %>% pull()
)

#------------------------------------------------------------------------------#
# Rendering Rmd document in html
#------------------------------------------------------------------------------#
# rmarkdown::render("pages/analysis_report.Rmd")
rmarkdown::render("pages/explanation.Rmd")
