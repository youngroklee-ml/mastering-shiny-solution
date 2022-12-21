library(shiny)

ui <- fluidPage(
  textInput("label", "label"),
  selectInput("type", "type", c("slider", "numeric")),
  uiOutput("numeric")
)
server <- function(input, output, session) {
  output$numeric <- renderUI({
    # isolate()를 없앨 경우, 이 render 함수가 쓸데없이 많이 수행되어 낭비가 발생한다. 
    # 예를 들어, 컨트롤에서 'dynamic' 입력값을 변경하였을 때는 이 render 함수를 다시 
    # 실행할 필요가 없는데도 다시 실행되며, 'type'을 변경하였을 때는 두 번 실행된다.
    cat("테스트\n")
    value <- input$dynamic
    if (input$type == "slider") {
      sliderInput("dynamic",
        input$label,
        value = ifelse(is.null(value), 0, value),
        min = 0,
        max = 10
      )
    } else {
      numericInput("dynamic",
        input$label,
        value = ifelse(is.null(value), 0, value),
        min = 0,
        max = 10
      )
    }
  })
}

shinyApp(ui, server)