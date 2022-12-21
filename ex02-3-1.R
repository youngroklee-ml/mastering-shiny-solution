library(shiny)

ui <- fluidPage(
  verbatimTextOutput("a"),
  textOutput("b"),
  verbatimTextOutput("c"),
  textOutput("d")
)

server <- function(input, output, session) {
  output$a <- renderPrint(summary(mtcars))
  output$b <- renderText("Good morning!")
  output$c <- renderPrint(t.test(1:5, 2:6))
  output$d <- renderText(str(lm(mpg ~ wt, data = mtcars))) # why not renderPrint?
}

shinyApp(ui, server)
