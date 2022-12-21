library(shiny)
library(tidyverse)

ui <- fluidPage(
  fileInput("file", "Uplaod CSV", accept = ".csv"),
  selectInput("var", "Variable", choices = NULL),
  plotOutput("plot", width = "400px"),
  fluidRow(
    selectInput("ext", "Download type", choices = c("png", "pdf", "svg"), selected = ".png"),
    downloadButton("download", "Download")
  )
)

server <- function(input, output, session) {
  data <- reactive({
    req(input$file)
    
    ext <- tools::file_ext(input$file$name)
    res <- switch(
      ext,
      csv = vroom::vroom(input$file$datapath, delim = ","),
      validate("Invalid file; Please upload a .csv file")
    )
    
    res %>% 
      select(where(is.numeric))
  })
  
  observeEvent(data(), {
    updateSelectInput(inputId = "var", choices = names(data()))
  })
  
  plot_output <- reactive({
    req(input$var)
    
    data() %>% 
      ggplot(aes_string(x = input$var)) +
      geom_histogram()
  })
  
  output$plot <- renderPlot({
    plot_output()
  }, res = 96)
  
  output$download <- downloadHandler(
    filename = function() {
      paste0("histogram.", input$ext)
    },
    content = function(file) {
      ggsave(file, plot_output(), device = input$ext)
    }
  )
}

shinyApp(ui, server)