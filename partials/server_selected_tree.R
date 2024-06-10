selected_tree <- reactive({
  print("In reactive selected_tree")
  print(input$map_marker_click$id)
  if(!is.null(input$map_marker_click)) {
    res <- trees() %>%
      dplyr::filter(tree_id == input$map_marker_click$id)
    
    if(nrow(res) == 0) {
      return(NULL)
    } else {
      return(res)
    }
  } else {
    return(NULL)
  }
})

# Selection info panel
output$infos <- renderUI({
  print("In renderUI --> infos")
  tree <- selected_tree()
  
  # If no tree selection
  if(is.null(tree)) {
    return(p("Cliquez sur un arbre pour avoir ses informations"))
  }
  infos <- div(HTML(
    tree_infos(tree)
  ))
})