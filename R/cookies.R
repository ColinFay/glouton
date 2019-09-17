#' Add glouton to your shiny app
#'
#' @param online TRUE fetch the online version of js-cookie through
#'     CDN. FALSE uses the file included in the pckage.
#'
#' @importFrom shiny addResourcePath tagList singleton tags
#'
#' @export
use_glouton <- function(online = TRUE){
  addResourcePath(
    "inst",
    system.file(
      package = "glouton"
    )
  )
  if (online){
    cookie <- "https://cdn.jsdelivr.net/npm/js-cookie@2/src/js.cookie.min.js"
  } else {
    cookie <- "inst/js.cookie.min.js"
  }
  tagList(
    singleton(
      tags$script(
        src= cookie
      ),
      tags$script(
        "import Cookies from 'https://cdn.jsdelivr.net/npm/js-cookie@2/src/js.cookie.min.js'"
      )
    ),
    singleton(
      tags$script(
        src="inst/glouton.js"
      )
    )
  )

}

#' Add and fetch browsers cookies
#'
#' `fetch_cookies` returns all the cookies, while `fetch_cookie` search for
#' one cookie in the browser.
#'
#' @param input,session the `input` and `session` object from Shiny
#' @param name name of the cookie to set/fetch
#' @param value the value to set for the cookie
#'
#' @export
#' @rdname cookies

fetch_cookies <- function(input, session){
  session$sendCustomMessage("fetchcookies", TRUE)
  return(input$gloutoncookies)
}

#' @export
#' @rdname cookies
fetch_cookie <- function(name, input, session){
  session$sendCustomMessage("fetchcookie", TRUE)
  return(input$gloutoncookies)
}

#' @export
#' @rdname cookies
add_cookie <- function(name, value, session){
  session$sendCustomMessage("addcookie", list(
    name = name, value = value
  ))
}

#' @export
#' @rdname cookies
remove_cookie <- function(name, session){
  session$sendCustomMessage("rmcookie", list(
    name = name
  ))
}

