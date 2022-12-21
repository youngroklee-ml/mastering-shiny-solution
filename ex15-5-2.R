library(shiny)
library(RSQLite)

con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")

df_tbl <- tibble::tibble(
  timestamp = Sys.time()
)

DBI::dbWriteTable(con, "tbl", df_tbl, overwrite = TRUE)

ui <- fluidPage(
  actionButton("add", "Add row"),
  tableOutput("table")
)

server <- function(input, output, session) {
  observeEvent(input$add, {
    DBI::dbSendQuery(con, glue::glue("INSERT INTO tbl VALUES ({as.numeric(Sys.time())})"))
  })

  data <- reactivePoll(
    1000, session,
    function() DBI::dbGetQuery(con, "SELECT MAX(timestamp) FROM tbl"),
    function() DBI::dbGetQuery(con, "SELECT * FROM tbl")
  )
  
  output$table <- renderTable(data())
}

shinyApp(ui, server)
