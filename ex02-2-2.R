library(shiny)

ui <- fluidPage(
  sliderInput("date", "When should we deliver?",
              min = lubridate::as_date("2020-09-16"),
              max = lubridate::as_date("2020-09-23"),
              value = lubridate::as_date("2020-09-17")
              )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)