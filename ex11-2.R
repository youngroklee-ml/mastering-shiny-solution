library(shiny)

ui <- function(request) {
  fluidPage(
    fileInput("file", "CSV file upload", accept = ".csv"),
    tableOutput("table"),
    bookmarkButton()
  )
}

server <- function(input, output, session) {
  data <- reactive({
    req(input$file)
    
    ext <- tools::file_ext(input$file$name)
    if (ext != "csv") {
      validate("Invalid file; Please upload a .csv file")
    }
    
    res <- vroom::vroom(input$file$datapath, delim = ",")
    res
  })
  
  output$table <- renderTable({
    head(data())
  })
}

shinyApp(ui, server, enableBookmarking = "server")
