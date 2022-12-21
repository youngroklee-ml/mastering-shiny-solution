library(shiny)
library(ggplot2)

plot <- ggplot(diamonds, aes(carat))

ui <- fluidPage(
  selectInput("geom", "geom function", choices = c(
    "geom_histogram()",
    "geom_freqpoly()",
    "geom_density()"
  )),
  tabsetPanel(
    id = "wizard",
    type = "hidden",
    tabPanel("geom_histogram()", numericInput("binwidth_histogram", "geom_histogram()'s binwidth", value = 0.1, step = 0.1)),
    tabPanel("geom_freqpoly()", numericInput("binwidth_freqpoly", "geom_freqpoly()'s binwidth", value = 0.1, step = 0.1)),
    tabPanel("geom_density()", selectInput("bw_density", "geom_density()'s bw", choices = c("nrd0", "nrd", "ucv", "bcv", "SJ"), selected = "nrd0"))
  ),
  checkboxInput("check_histogram", "Show histogram?"),
  checkboxInput("check_freqpoly", "Show frequency polygon?"),
  checkboxInput("check_density", "Show density?"),
  plotOutput("plot_histogram", width = "400px"),
  plotOutput("plot_freqpoly", width = "400px"),
  plotOutput("plot_density", width = "400px"),
)

server <- function(input, output, session) {
  observeEvent(input$geom, {
    updateTabsetPanel(inputId = "wizard", selected = input$geom)
  })
  
  output$plot_histogram <- renderPlot({
    req(input$check_histogram)
    plot + geom_histogram(binwidth = input$binwidth_histogram)
  })
  
  output$plot_freqpoly <- renderPlot({
    req(input$check_freqpoly)
    plot + geom_freqpoly(binwidth = input$binwidth_freqpoly)
  })

  output$plot_density <- renderPlot({
    req(input$check_density)
    plot + geom_density(bw = input$bw_density)
  })
  
}

shinyApp(ui, server)