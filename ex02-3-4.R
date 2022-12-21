library(shiny)
library(reactable)

ui <- fluidPage(reactableOutput("table"))
server <- function(input, output, session) {
  output$table <- renderReactable(reactable(
    mtcars,
    sortable = FALSE,
    defaultPageSize = 5L
  ))
}


shinyApp(ui, server)