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
#' @param session The `session` object passed to function given to
#'   `shinyServer`. Default is [shiny::getDefaultReactiveDomain()]
#' @param name Name of the cookie to set/fetch
#' @param value The value to set for the cookie
#' @param options A list of options returned from `cookie_options()`. The same
#'   options that were passed to `add_cookie()` must be passed to
#'   `remove_cookie()`.
#' @param debug If `TRUE`, a message is displayed in the browser console after
#'   adding a cookie.
#' @param expires Define when the cookie will be removed. Value must be a
#'   numeric, which will be interpreted as days from time of creation or
#'   a date. If `NULL`, the cookie becomes a session cookie.
#' @param path A string indicating the path where the cookie is visible.
#' @param domain A string indicating a valid domain where the cookie should be
#'   visible. The cookie will also be visible to all subdomains.
#' @param secure Boolean indicating whether the cookie transmission requires a
#'   secure protocol (https).
#' @param sameSite A string allowing to control whether the browser is sending
#'   a cookie along with cross-site requests.
#'
#' @export
#' @rdname cookies

fetch_cookies <- function(session = shiny::getDefaultReactiveDomain()){
  session$sendCustomMessage("fetchcookies", TRUE)
  return(session$input[["gloutoncookies"]])
}

#' @export
#' @rdname cookies
fetch_cookie <- function(name, session = shiny::getDefaultReactiveDomain()){
  session$sendCustomMessage("fetchcookie", TRUE)
  return(session$input[["gloutoncookies"]])
}

#' @export
#' @rdname cookies
add_cookie <- function(name,
                       value,
                       options = cookie_options(),
                       debug = FALSE,
                       session = shiny::getDefaultReactiveDomain())
{
  session$sendCustomMessage("addcookie", list(
    name = name, value = value, options = options, debug = debug
  ))
}

#' @export
#' @rdname cookies
remove_cookie <- function(name,
                          options = cookie_options(),
                          session = shiny::getDefaultReactiveDomain()){
  session$sendCustomMessage("rmcookie", list(
    name = name, options = options
  ))
}

#' @export
#' @rdname cookies
cookie_options <- function(expires = NULL,
                           path = "/",
                           domain = NULL,
                           secure = FALSE,
                           sameSite = "strict"
) {
  options <- list(
    expires = expires,
    path = path,
    domain = domain,
    secure = secure,
    sameSite = sameSite
  )

  # Drop NULLs
  options[lengths(options) != 0]
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
    initialize = function(name, session = shiny::getDefaultReactiveDomain()){
      if(missing(name))
        stop("Missing `name`", call. = FALSE)

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
