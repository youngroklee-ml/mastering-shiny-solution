library(shiny)

ui <- fluidPage(
  selectInput("type", "type", c("Normal", "Uniform")),
  actionButton("go", "go"),
  plotOutput("plot")
)

server <- function(input, output, session) {
  r <- reactiveValues(numbers = NULL)
  
  observeEvent(input$go, {
    if (input$type == "Normal") {
      r$numbers <- rnorm(100)
    } else if (input$type == "Uniform") {
      r$numbers <- runif(100)
    } else {
      r$numbers <- NULL
    }
  })

  output$plot <- renderPlot({
    req(r$numbers)
    
    hist(r$numbers)
  }, res = 96)
}

shinyApp(ui, server)