library(shiny)

df <- tibble::tibble(
  a = c(1, 2),
  b = c(3, 4)
)

ui <- fluidPage(
  selectInput("var", "Variable", choices = names(df)),
  textOutput("res")
)

server <- function(input, output, session) {
  var <- reactive(df[[input$var]])
  range <- reactive(base::range(var(), na.rm = TRUE))
  output$res <- renderText(range())
}

shinyApp(ui, server)
