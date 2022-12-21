library(shiny)

find_vars <- function(data, filter) {
  stopifnot(is.data.frame(data))
  stopifnot(is.function(filter))
  names(data)[vapply(data, filter, logical(1))]
}

selectVarInput <- function(id) {
  selectInput(NS(id, "var"), "Variable", choices = NULL)
}

selectVarServer <- function(id, data, filter) {
  stopifnot(is.reactive(data))
  stopifnot(is.reactive(filter))
  
  moduleServer(id, function(input, output, session) {
    observeEvent({data(); filter()}, {
      updateSelectInput(session, "var", choices = find_vars(data(), filter()))
    })
    
    reactive(data()[[input$var]])
  })
}

datasetInput <- function(id, filter = NULL) {
  names <- ls("package:datasets")
  if (!is.null(filter)) {
    data <- lapply(names, get, "package:datasets")
    names <- names[vapply(data, filter, logical(1))]
  }
  
  selectInput(NS(id, "dataset"), "Pick a dataset", choices = names)
}

datasetServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(get(input$dataset, "package:datasets"))
  })
}

selectVarApp <- function() {
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        datasetInput("data", is.data.frame),
        selectInput("filter", "Filter", choices = c("Numeric", "Character", "Factor")),
        selectVarInput("var"),
      ),
      mainPanel(
        verbatimTextOutput("out")
      )
    )
  )
  
  server <- function(input, output, session) {
    data <- datasetServer("data")
    filter <- eventReactive(
      input$filter,
      switch(input$filter,
             Numeric = is.numeric,
             Character = is.character,
             Factor = is.factor
      )
    )
    var <- selectVarServer("var", data, filter)
    output$out <- renderPrint(var())
  }
  shinyApp(ui, server)
}


selectVarApp()
