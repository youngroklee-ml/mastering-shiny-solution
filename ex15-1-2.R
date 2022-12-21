library(shiny)
reactiveConsole(TRUE)

b1 <- b2 <- reactiveVal(10)

# get
b1()
b2()

# set
b2(20)

# get
b1()
