library(shiny)

ui <- fluidPage(
  selectInput("type", "type", c("Normal", "Uniform")),
  actionButton("go", "go"),
  plotOutput("plot")
)

server <- function(input, output, session) {
  numbers <- reactive({
    req(input$go)
    
    if (isolate(input$type) == "Normal") {
      res <- rnorm(100)
    } else if (isolate(input$type) == "Uniform") {
      res <- runif(100)
    } else {
      res <- NULL
    }
    
    res
  })

  output$plot <- renderPlot({
    req(numbers())
    
    hist(numbers())
  }, res = 96)
}

shinyApp(ui, server)


# ui <- fluidPage(
#   actionButton("rnorm", "Normal"),
#   actionButton("runif", "Uniform"),
#   plotOutput("plot")
# )
# 
# server <- function(input, output, session) {
#   numbers <- reactive({
#     req(input$rnorm | input$runif)
# 
#     # 무효화된 입력이 `input$rnorm`인지 `input$runif`인지
#     # 알 수가 없으므로, 어떤 분포로부터 무작위 수를 얻어야 할지
#     # 알 수 없다.
#
#     res
#   })
#   
#   output$plot <- renderPlot({
#     req(numbers())
#     
#     hist(numbers())
#   }, res = 96)
# }
