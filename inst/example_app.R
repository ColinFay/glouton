library(shiny)
ui <- function(request){
  tagList(
    use_glouton(),
    textInput("cookie_name", "cookie name"),
    textInput("cookie_content", "cookie content"),
    actionButton("setcookie", "Add cookie"),
    actionButton("getcookie", "get cookie"),
    verbatimTextOutput("cook"),
    verbatimTextOutput("one")
  )
}

server <- function(input, output, session){

  r <- reactiveValues()

  observeEvent( input$setcookie , {
    add_cookie(input$cookie_name, input$cookie_content, session)
  })
  observeEvent( input$getcookie , {
    r$cook <- fetch_cookies(session, input)
  })

  output$cook <- renderPrint({
    r$cook
  })

}

shinyApp(ui, server)
