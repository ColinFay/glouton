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
#' @param session the `input` and `session` object from Shiny
#' @param name name of the cookie to set/fetch
#' @param value the value to set for the cookie
#'
#' @export
#' @rdname cookies

fetch_cookies <- function(session = NULL){
  if(is.null(session))
    session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("fetchcookies", TRUE)
  return(session$input[["gloutoncookies"]])
}

#' @export
#' @rdname cookies
fetch_cookie <- function(name, session = NULL){
  if(is.null(session))
    session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("fetchcookie", TRUE)
  return(session$input[["gloutoncookies"]])
}

#' @export
#' @rdname cookies
add_cookie <- function(name, value, session = NULL){
  if(is.null(session))
    session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("addcookie", list(
    name = name, value = value
  ))
}

#' @export
#' @rdname cookies
remove_cookie <- function(name, session = NULL){
  if(is.null(session))
    session <- shiny::getDefaultReactiveDomain()
  session$sendCustomMessage("rmcookie", list(
    name = name
  ))
}

#' Create a Cookie
#' 
#' Create a cookie object.
#' 
#' @export
Cookie <- R6::R6Class(
  "Cookie",
  public = list(
#' @details Create a Cookie
#' 
#' @param name The name of the cookie.
#' @param session A valid Shiny session.
    initialize = function(name, session = NULL){
      if(missing(name))
        stop("Missing `name`", call. = FALSE)

      if(is.null(session))
        session <- shiny::getDefaultReactiveDomain()

      private$.session <- session
      private$.name <- name
    },
#' @details Get the value of the cookie
    get = function(){
      private$.session$sendCustomMessage("get-cookie", list(name = private$.name))
      rez <- private$.session$input[[private$.name]]
      invisible(rez)
    },
#' @details Set the value of the cookie
#' 
#' @param value Value of the cookie
#' @param expires When the cookie is set to expire, integer indicating number of days.
#' @param path Path where cookie is visible.
    set = function(value, expires = 365L, path = "/"){
      if(missing(value))
        stop("Missing `value`", call = FALSE)

      options <- list(
        expires = expires,
        path = "/"
      )

      private$.session$sendCustomMessage("set-cookie", list(name = private$.name, value = value, options = options))
      
      invisible(self)
    },
#' @details Remove the cookie.
    rm = function(){
      private$.session$sendCustomMessage("rm-cookie", list(name = private$.name))
      invisible(self)
    }
  ),
  private = list(
    .name = NULL,
    .session = NULL
  )
)
