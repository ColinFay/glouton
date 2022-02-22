library(shiny)
ui <- function(request){
  tagList(
    use_glouton(),
    textInput("cookie_name", "cookie name"),
    textInput("cookie_content", "cookie content"),
    numericInput("expires_in", "Expires in", min = 0, value = 365),
    selectInput("sameSite", "sameSite", c("strict", "lax", "none")),
    actionButton("setcookie", "Add cookie"),
    p(
      "Use the developer tools to see the log which is created when debug=TRUE."
    ),
    p("Cookies.get():"),
    verbatimTextOutput("cook")
  )
}

server <- function(input, output, session){

  r <- reactiveValues()

  options_r <- shiny::reactive({
    cookie_options(
      expires = input$expires_in,
      path = "/",
      secure = TRUE,
      sameSite = input$sameSite
    )
  })

  observeEvent( input$setcookie , {
    add_cookie(
      name = input$cookie_name,
      value = input$cookie_content,
      options = options_r(),
      debug = TRUE
    )
  })

  output$cook <- renderPrint({
    input$gloutoncookies
    fetch_cookies(session)
  })

}

shinyApp(ui, server)
