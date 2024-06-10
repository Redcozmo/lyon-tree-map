output$table <- DT::renderDT({
  trees <- trees() %>% sf::st_drop_geometry()
  return(trees)
})