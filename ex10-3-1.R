library(shiny)

ui <- fluidPage(
  selectInput("type", "type", c("slider", "numeric")),
  tabsetPanel(
    id = "switch",
    type = "hidden",
    tabPanel("slider", sliderInput("n_slider", "n", value = 0, min = 0, max = 100)),
    tabPanel("numeric", numericInput("n_numeric", "n", value = 0, min = 0, max = 100))
  )
)

server <- function(input, output, session) {
  observeEvent(input$type, {
    updateTabsetPanel(inputId = "switch", selected = input$type)
  })
  
  observeEvent(input$n_slider, {
    req(input$n_slider != input$n_numeric)
    freezeReactiveValue(input, "n_numeric")
    updateNumericInput(inputId = "n_numeric", value = input$n_slider)
  })
  
  observeEvent(input$n_numeric, {
    req(input$n_slider != input$n_numeric)
    freezeReactiveValue(input, "n_slider")
    updateSliderInput(inputId = "n_slider", value = input$n_numeric)
  })
}

shinyApp(ui, server)

