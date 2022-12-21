library(shiny)
library(tictoc)
reactiveConsole(TRUE)

x1 <- reactiveVal(1)
x2 <- reactiveVal(2)
x3 <- reactiveVal(3)

y1 <- reactive({
  Sys.sleep(1)
  x1()
})
y2 <- reactive({
  Sys.sleep(1)
  x2()
})
y3 <- reactive({
  Sys.sleep(1)
  x2() + x3() + y2() + y2()
})

observe({
  print(y1())
  print(y2())
  print(y3())
})

# `x1`이 변경될 때, 반응형 `y1`과 관찰자가 무효화된다.
# `y1` 재계산에 1초가 소요된다.
tic()
x1(runif(1))
toc()

# `x2`가 변경될 때, 반응형 `y2`, 반응형 `y3`, 관찰자가 무효화된다.
# 반응형 `y2` 재계산에 1초, 반응형 `y3` 재계산에 1초 등 총 2초가 소요된다.
tic()
x2(runif(1))
toc()

# `x3`이 변경될 때, 반응형 `y3`과 관찰자가 무효화된다.
# `y3` 재계산에 1초가 소요된다.
tic()
x3(runif(1))
toc()

