library(shiny)

ui <- fluidPage(
  sliderInput("ani", NULL, value = 0L, min = 0L, max = 100L, step = 5L,
              animate = TRUE)
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)