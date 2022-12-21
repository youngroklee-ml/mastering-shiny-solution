library(shiny)

ui <- fluidPage(
  actionButton("rnorm", "Normal"),
  actionButton("runif", "Uniform"),
  plotOutput("plot")
)

server <- function(input, output, session) {
  r <- reactiveValues(numbers = NULL)
  observeEvent(input$rnorm, {
    r$numbers <- rnorm(100)
  })
  observeEvent(input$runif, {
    r$numbers <- runif(100)
  })
  
  output$plot <- renderPlot({
    req(r$numbers)
    
    hist(r$numbers)
  }, res = 96)
}

shinyApp(ui, server)