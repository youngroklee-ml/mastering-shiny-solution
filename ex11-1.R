library(shiny)

ui <- function(request) {
  fluidPage(
    sliderInput("frequency", "frequency", value = 0.01, min = 0, max = 0.1),
    selectInput("fractal", "fractal", choices = c("none", "fbm", "billow", "rigid-multi"), selected = "fbm"),
    sliderInput("lacunarity", "lacunarity", value = 2, min = 0, max = 10),
    sliderInput("gain", "gain", value = 0.5, min = 0, max = 1),
    numericInput("seed", "random seed for image generation", value = 12345),
    plotOutput("plot"),
    bookmarkButton()
  )
}

server <- function(input, output, session) {
  noise <- reactive({
    req(input$frequency, input$fractal, input$lacunarity, input$gain)
    
    set.seed(input$seed)
    
    ambient::noise_simplex(
      dim = c(400, 400),
      frequency = input$frequency,
      fractal = input$fractal,
      lacunarity = input$lacunarity,
      gain = input$gain
    )
  })
  
  output$plot <- renderPlot({
    plot(as.raster(ambient::normalize(noise())))
  }, res = 96)
  
  
}

shinyApp(ui, server, enableBookmarking = "url")