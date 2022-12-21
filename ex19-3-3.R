library(shiny)

ymdDateUI <- function(id, label) {
  label <- paste0(label, " (yyyy-mm-dd)")
  
  fluidRow(
    textInput(NS(id, "date"), label),
    textOutput(NS(id, "error"))
  )
}

ymdDateServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    date <- eventReactive(
      input$date,
      as.Date(strptime(input$date, "%Y-%m-%d"))
    )

    output$error <- renderText({
      ifelse(
        is.na(date()),
        "Input is invalid. Please enter in yyyy-mm-dd format.",
        ""
      )
    })

    date
  })
}

ymdDateApp <- function() {
  ui <- fluidPage(
    ymdDateUI("date", "Please enter date:")
  )
  
  server <- function(input, output, session) {
    date <- ymdDateServer("date")
  }
  
  shinyApp(ui, server)
}

ymdDateApp()
