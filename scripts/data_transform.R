################################################################################
# Data tansformation : trees and town administrative boundaries
# This scripts is for transform data from grand lyon : 
# - Selection of needed attributs
# - Transform casse
# - project in CRS 4326 for leaflet
# - export in geopackage format
################################################################################

# Clear existing objects from workspace and free memory
rm(list=ls(all=TRUE));gc()

# Set working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()

# Load libraries
library(sf)
library(dplyr)

# Source files
source("functions.R")

# Set project CRS
crs_project <- 4326

# Data read
trees <- st_read(
  dsn = paste(getwd(), 
              "data_source/arbres_alignement/arbres_alignement.shp",
              sep = '/'),
)

col_selection <- c("essencefra", "genre", 
                   "espece", "variete",
                   "circonfere", "hauteurtot", "diametreco",
                   "anneeplant",
                   "commune", "codeinsee")

col_newnames <- c("common_name", "genus", 
                  "species", "variety",
                  "perimeter_cm", "height_m", "crown_diameter_m",
                  "plantation_date",
                  "town", "insee_code")

trees <- trees %>%
  select(all_of(col_selection)) %>%
  rename_at(vars(col_selection), ~ col_newnames) %>%
  st_transform(crs_project) %>% # CRS used by leaflet
  mutate(across("species", tolower)) %>% # Cause to one species with first capital letter "Lutece" 
  mutate(tree_id = seq(1, length(trees[[1]]), by = 1))

# Town administrative boundaries
town_boundaries <- st_read(
  dsn = paste(getwd(), 
              "data_source/contours_communes/adr_voie_lieu_adrcomgl_2024.shp",
              sep = '/'),
  layer = "adr_voie_lieu_adrcomgl_2024"
) %>%
  st_transform(crs_project) %>%
  select("nom") %>%
  rename("town" = "nom") %>%
  mutate(across("town", toupper)) %>%
  mutate(across("town", without_accent_name)) %>%
  arrange(town)

# Export files
sf::st_write(obj = trees,
             dsn = paste(getwd(), 
                         "data/trees.gpkg",
                         sep = '/'),
             append = FALSE
)

sf::st_write(obj = town_boundaries,
             dsn = paste(getwd(), 
                         "data/boundaries.gpkg",
                         sep = '/'),
             append = FALSE
)

