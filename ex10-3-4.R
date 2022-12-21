library(shiny)
library(purrr)
library(lubridate)
library(dplyr)

dfs <- keep(ls("package:datasets"), ~ is.data.frame(get(.x, "package:datasets")))

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", label = "Dataset", choices = dfs),
      uiOutput("filter")
    ),
    mainPanel(
      dataTableOutput("data")
    )
  )
)

make_ui <- function(x, var) {
  if (is.numeric(x)) {
    rng <- range(x, na.rm = TRUE)
    sliderInput(var, var, min = rng[1], max = rng[2], value = rng)
  } else if (is.factor(x)) {
    levs <- levels(x)
    selectInput(var, var, choices = levs, selected = levs, multiple = TRUE, selectize = FALSE)
  } else if (is.Date(x) || is.timepoint(x)) {
    min_date <- as_date(min(x))
    max_date <- as_date(max(x)) + 1L
    dateRangeInput(var, var, start = min_date, end = max_date, min = min_date, max = max_date)
  } else {
    # 지원되지 않음
    NULL
  }
}

filter_var <- function(x, val) {
  if (is.numeric(x)) {
    !is.na(x) & x >= val[1] & x <= val[2]
  } else if (is.factor(x)) {
    x %in% val
  } else if (is.Date(x) || is.timepoint(x)) {
    !is.na(x) & x >= val[1] & x <= val[2]
  } else {
    # 컨트롤이 존재하지 않으므로 필터링하지 않음
    TRUE
  }
}

server <- function(input, output, session) {
  data <- reactive({
    get(input$dataset, "package:datasets") %>% 
      mutate(
        date_col = sample(seq.Date(as_date("2020-01-01"), as_date("2020-12-31"), by = "day"), n(), replace = TRUE),
        datetime_col = sample(seq.POSIXt(as_datetime("2020-01-01 00:00:00"), as_datetime("2020-12-31 23:59:59"), by = "30 min"), n(), replace = TRUE)
      )
  })
  vars <- reactive(names(data()))
  
  output$filter <- renderUI(
    map(vars(), ~ make_ui(data()[[.x]], .x))
  )
  
  selected <- reactive({
    each_var <- map(vars(), ~ filter_var(data()[[.x]], input[[.x]]))
    reduce(each_var, `&`)
  })
  
  output$data <- renderDataTable(head(data()[selected(), ], 12))
}

shinyApp(ui, server)
