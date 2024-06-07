################################################################################
# Functions definition
################################################################################
# Function : without_accent_name
without_accent_name <- function(string) {
  string %>%
    stringi::stri_trans_general(id = "Latin-ASCII")
}

# Function to construct reproductible wikipedia url from taxon (genus - species)
# in order to give link in tree popup
wikipedia_url <- function(url = "https://fr.wikipedia.org/wiki", genus, species) {
  paste("<a href=",
        paste(url, 
              paste(genus, species, sep = "_"), 
              sep = "/"),
        " target=",
        "_blank",
        ">",
        "Fiche wikipedia",
        "</a>", sep = "")
}

# Function to construct tree info box --> unused
tree_infos <- function(tree) {
  paste(sep = "<br/>",
        paste("<u><b>", tree$common_name, "</b></u>", sep = ''),
        paste("Genre", tree$genus, sep = ' : '),
        paste("Espèce", tree$species, sep = ' : '),
        paste("Variété", tree$variety, sep = ' : '),
        paste("Circonférence du tronc (cm)", tree$perimeter_cm, sep = ' : '),
        paste("Hauteur totale (m)", tree$height_m, sep = ' : '),
        paste("Diamètre du houppier (m)", tree$crown_diameter_m, sep = ' : '),
        paste("Planté en", tree$plantation_date, sep = ' : '),
        paste("Commune", tree$town, sep = ' : '),
        wikipedia_url(genus = tree$genus, species = tree$species)
  )
}

# Function under construction
find_vars <- function(data, filter) {
  stopifnot(is.data.frame(data))
  stopifnot(is.function(filter))
  names(data)[vapply(data, filter, logical(1))]
}