library(shiny)

ui <- fluidPage(
  actionButton("go", "Enter password"),
  textOutput("text")
)
server <- function(input, output, session) {
  observeEvent(input$go, {
    showModal(modalDialog(
      # 매번 'password' 입력이 새로 생성되므로,
      # 이때 `value` 값을 현재 입력값으로 설정해줘야
      # 직전에 입력했던 비밀번호가 사라지지 않을 것이다.
      passwordInput("password", NULL, value = input$password), 
      title = "Please enter your password"
    ))
  })
  
  output$text <- renderText({
    if (!isTruthy(input$password)) {
      "No password"
    } else {
      "Password entered"
    }
  })
}

shinyApp(ui, server)

