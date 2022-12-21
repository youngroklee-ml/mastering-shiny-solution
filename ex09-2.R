library(shiny)
library(tidyverse)

ui <- fluidPage(
  fileInput("file", "Uplaod CSV", accept = ".csv"),
  selectInput("var", "Variable", choices = NULL),
  verbatimTextOutput("ttest")
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
  
  output$ttest <- renderPrint({
    req(input$var)
    
    t.test(x = data()[[input$var]])
  })
}

shinyApp(ui, server)