library(shiny)

ui <- fluidPage(
  checkboxInput("advanced", "Advanced"),
  tabsetPanel(
    id = "wizard",
    type = "hidden",
    tabPanel("Empty"),
    tabPanel("Advanced",
             numericInput("number", "Additional control", value = 1, min = 0, max = 10))
  )
)

server <- function(input, output, session) {
  observeEvent(input$advanced, {
    updateTabsetPanel(inputId = "wizard", selected = if_else(input$advanced, "Advanced", "Empty"))
  })
}

shinyApp(ui, server)