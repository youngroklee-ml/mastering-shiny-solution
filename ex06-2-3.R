library(shiny)
library(tidyverse)

ui <- fluidPage(
  titlePanel("Central limit theorem"),
  fluidRow(
    column(6, plotOutput("hist")),
    column(6, plotOutput("freqpoly"))
  ),
  fluidRow(
    column(12, numericInput("m", "Number of samples:", 2, min = 1, max = 100, width = '100%'))
  )
)
server <- function(input, output, session) {
  means <- reactive({replicate(1e4, mean(runif(input$m)))})
  
  output$hist <- renderPlot({
    hist(means(), breaks = 20)
  }, res = 96)
  
  output$freqpoly <- renderPlot({
    tibble(x = means()) %>% 
      ggplot(aes(x = x)) +
      geom_freqpoly()
  }, res = 96)
}

shinyApp(ui, server)
