library(shiny)

randomUI <- function(id) {
  tagList(
    textOutput(NS(id, "val")),
    actionButton(NS(id, "go"), "Go!")
  )
}
randomServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    rand <- eventReactive(input$go, sample(100, 1))
    output$val <- renderText(rand())
  })
}

randomApp <- function() {
  ids <- c("random1", "random2", "random3", "random4")
  
  ui <- fluidPage(
    purrr::map(ids, randomUI)
  )
  server <- function(input, output, session) {
    purrr::map(ids, randomServer)
  }
  shinyApp(ui, server)
}

randomApp()
