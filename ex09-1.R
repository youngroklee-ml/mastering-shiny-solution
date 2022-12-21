library(shiny)
library(ambient)
library(magrittr)

ui <- fluidPage(
  actionButton("click", "Generate worley noise!"),
  plotOutput("plot", width = "400px"),
  downloadButton("download", "Download PNG")
)

server <- function(input, output, session) {
  noise <- eventReactive(input$click, {
    noise_worley(c(1000, 1000), frequency = .001)
  })
  
  output$plot <- renderPlot({
    res <- noise() %>% 
      normalise() %>% 
      as.raster() %>% 
      plot()
    res
  })
  
  output$download <- downloadHandler(
    filename = function() {
      "worley_noise.png"
    },
    content = function(file) {
      png(file)
      noise() %>% 
        normalise() %>% 
        as.raster() %>% 
        plot()
      dev.off()
    }
  )
}

shinyApp(ui, server)