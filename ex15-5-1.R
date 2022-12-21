library(shiny)

ui <- fluidPage(
  
)

server <- function(input, output, session) {
  x <- reactive({
    invalidateLater(500)
    rnorm(10)
  })
}

shinyApp(ui, server)

# 반응형 `x`를 소비하는 반응형 소비자가 존재하지 않으므로, `x`는 실행되지 않는다.