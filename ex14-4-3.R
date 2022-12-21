library(shiny)
reactiveConsole(TRUE)

x <- reactiveVal(1)
y <- reactive(x() + y())
y()

# 다음과 같은 오류가 발생한다.
# Error: C stack usage  7955680 is too close to the limit