library(shiny)

ui <- fluidPage(
  checkboxInput("error", "error?"),
  textOutput("result")
)
server <- function(input, output, session) {
  a <- reactive({
    if (input$error) {
      stop("Error!")
    } else {
      1
    }
  })
  b <- reactive(a() + 1)
  c <- reactive(b() + 1)
  output$result <- renderText(c())
}

shinyApp(ui, server)

# 체크박스를 선택했을 때와 선택하지 않았을 때 그래프는 동일하게 생성되며
# 반응형 `a`가 오류를 반환했을 때도 여전히 `a`를 소비하는 반응형에 전달되고
# 반응형 소비자가 유효화됨.
