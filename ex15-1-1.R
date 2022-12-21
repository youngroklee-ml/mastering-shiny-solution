library(shiny)
reactiveConsole(TRUE)

l1 <- reactiveValues(a = 1, b = 2)
l2 <- list(a = reactiveVal(1), b = reactiveVal(2))

# get
l1$a
l2$a()

# set
l1$a <- 3
l2$a(3)

# get
l1$a
l2$a()


