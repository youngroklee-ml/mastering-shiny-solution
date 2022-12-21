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
    tabPanel("1", numericInput("binwidth", "binwidth", value = 0.1, step = 0.1)),
    tabPanel("2", selectInput("bw", "bw", choices = c("nrd0", "nrd", "ucv", "bcv", "SJ"), selected = "nrd0"))
  ),
  plotOutput("plot", width = "400px")
)

server <- function(input, output, session) {
  panel <- reactive({
    req(input$geom)
    if_else(input$geom == "geom_density()", "2", "1")
  })
  
  observeEvent(input$geom, {
    updateTabsetPanel(inputId = "wizard", selected = panel())
  })
  
  output$plot <- renderPlot({
    plot + switch (input$geom,
      "geom_histogram()" = geom_histogram(binwidth = input$binwidth),
      "geom_freqpoly()" = geom_freqpoly(binwidth = input$binwidth),
      "geom_density()" = geom_density(bw = input$bw),
      NULL
    )
  })
}

shinyApp(ui, server)