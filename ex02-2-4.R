library(shiny)

grouped_list <- list(
  `Group A` = c("Item A1", "Item A2"),
  `Group B` = c("Item B1", "Item B2", "Item B3"),
  `Group C` = c("Item C1", "Item C2")
)

ui <- fluidPage(
  selectInput("long", "Choose:", choices = grouped_list)
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)