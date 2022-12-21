library(shiny)
library(dplyr)

library(gapminder)
continents <- c("(All)", as.character(unique(gapminder$continent)))

ui <- fluidPage(
  selectInput("continent", "Continent", choices = continents),
  selectInput("country", "Country", choices = NULL),
  tableOutput("data")
)

server <- function(input, output, session) {
  data_continent <- reactive({
    req(input$continent)
    
    res <- gapminder
    
    if (input$continent != "(All)") {
      res <- res %>% 
        filter(continent == input$continent)
    }
    
    res
  })
  
  countries <- reactive({
    req(data_continent())
    unique(data_continent()[["country"]])
  })
  
  observeEvent(countries(), {
    freezeReactiveValue(input, "country")
    updateSelectInput(inputId = "country", choices = countries())
  })
  
  output$data <- renderTable({
    req(input$country)
    
    data_continent() %>% 
      filter(country == input$country)
  })
}

shinyApp(ui, server)