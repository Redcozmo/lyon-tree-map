tab_panel_table <- 
  tabPanel(title = "Table",
         value = "table",
         
         # textOutput("resume_table"),
         # DT::DTOutput('resume_table'),
         # p(),
         
         fluidRow(
           column(12,
                  DT::DTOutput('table')
           )
         )
)