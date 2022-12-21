# server <- function(input, output, session) {
#   sum <- reactive(input$x + input$y + input$z)
#   prod <- reactive(input$x * input$y * input$z)
#   division <- reactive(prod() / sum())
# }

# 위 서버 함수는 반응형을 참조하는 출력(output)이나 관찰자(observer)를 
# 생성하지 않으므로, 반응형이 실행되지 않는다.