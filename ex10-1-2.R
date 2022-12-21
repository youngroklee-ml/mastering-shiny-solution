library(shiny)
library(dplyr)

library(openintro, warn.conflicts = FALSE)
states <- unique(county$state)

ui <- fluidPage(
  selectInput("state", "State", choices = states),
  selectInput("county", "County", choices = NULL)
)

server <- function(input, output, session) {
  state <- reactive({
    req(input$state)
    
    county %>% 
      filter(state == input$state)
  })
  
  observeEvent(state(), {
    counties <- unique(state()[["name"]])
    label <- switch(
      input$state,
      Louisiana = "Parish",
      Alaska = "Borough",
      "County"
    )
    
    updateSelectInput(inputId = "county", choices = counties, label = label)
  })
  
}

shinyApp(ui, server)