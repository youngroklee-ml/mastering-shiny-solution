library(shiny)

ui_upload <- sidebarLayout(
  sidebarPanel(
    fileInput("file", "Data", buttonLabel = "Upload..."),
    textInput("delim", "Delimiter (leave blank to guess)", ""),
    numericInput("skip", "Rows to skip", 0, min = 0),
    numericInput("rows", "Rows to preview", 10, min = 1)
  ),
  mainPanel(
    h3("Raw data"),
    tableOutput("preview1")
  )
)

ui_clean <- sidebarLayout(
  sidebarPanel(
    checkboxInput("snake", "Rename columns to snake case?"),
    checkboxInput("constant", "Remove constant columns?"),
    checkboxInput("empty", "Remove empty cols?")
  ),
  mainPanel(
    h3("Cleaner data"),
    tableOutput("preview2")
  )
)

ui_download <- fluidRow(
  column(width = 12, downloadButton("download", class = "btn-block"))
)

ui <- fluidPage(
  ui_upload,
  ui_clean,
  ui_download
)

server <- function(input, output, session) {
  # 업로드 ---------------------------------------------------------
  raw <- reactive({
    req(input$file)
    delim <- if (input$delim == "") NULL else input$delim
    vroom::vroom(input$file$datapath, delim = delim, skip = input$skip)
  })
  output$preview1 <- renderTable(head(raw(), input$rows))
  
  # 정제 ----------------------------------------------------------
  tidied_snake <- reactive({
    out <- raw()
    if (input$snake) {
      names(out) <- janitor::make_clean_names(names(out))
    }
    out
  })

  tidied_empty <- reactive({
    out <- tidied_snake()
    if (input$snake) {
      names(out) <- janitor::make_clean_names(names(out))
    }
    out
  })
  
  tidied_constant <- reactive({
    out <- tidied_empty()
    if (input$snake) {
      names(out) <- janitor::make_clean_names(names(out))
    }
    out
  })
  
  output$preview2 <- renderTable(head(tidied_constant(), input$rows))
  
  # 다운로드 -------------------------------------------------------
  output$download <- downloadHandler(
    filename = function() {
      paste0(tools::file_path_sans_ext(input$file$name), ".tsv")
    },
    content = function(file) {
      vroom::vroom_write(tidied_constant(), file)
    }
  )
}

shinyApp(ui, server)
