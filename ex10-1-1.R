library(shiny)

ui <- fluidPage(
  numericInput("year", "year", value = 2020),
  dateInput("date", "date")
)

server <- function(input, output, session) {
  observeEvent(input$year, {
    old_value <- isolate(input$date)
    
    updateDateInput(
      inputId = "date", 
      min = stringr::str_glue("{input$year}-01-01"),
      max = stringr::str_glue("{input$year}-12-31"),
      value = lubridate::`year<-`(lubridate::as_date(old_value), input$year)
    )
  })
}

shinyApp(ui, server)