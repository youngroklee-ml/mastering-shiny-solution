library(shiny)

# UI의 컴포넌트 이름을 `NS()`로 감싸지 않으면, 
# 서버 모듈에서 `input`이나 `output`에서 자동으로 네임스페이스가 지정되어 참조하고자
# 하는 이름과 컴포넌트 이름이 달라지므로, 서버 모듈에서 접근할 수 없다.
# 이 경우, 모듈 서버가 아닌 전역 서버 함수에서 접근할 수 있지만,
# 이렇게 되면 더 이상 모듈이라 부를 수 없다.
histogramUI <- function(id) {
  tagList(
    selectInput("var", "Variable", choices = names(mtcars)),
    numericInput("bins", "bins", value = 10, min = 1),
    plotOutput("hist")
  )
}

# histogramServer <- function(id) {
#   moduleServer(id, function(input, output, session) {
#     data <- reactive(mtcars[[input$var]])
#     output$hist <- renderPlot({
#       hist(data(), breaks = input$bins, main = input$var)
#     }, res = 96)
#   })
# }

histogramApp <- function() {
  ui <- fluidPage(
    histogramUI("hist1")
  )
  server <- function(input, output, session) {
    # histogramServer("hist1")
    data <- reactive(mtcars[[input$var]])
    output$hist <- renderPlot({
      hist(data(), breaks = input$bins, main = input$var)
    }, res = 96)
  }
  shinyApp(ui, server)
}


histogramApp()
