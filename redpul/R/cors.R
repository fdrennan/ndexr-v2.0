#' cors
#' @export cors
cors <- function(req, res) {
  print(as.list(req$args))
  res$setHeader("Access-Control-Allow-Origin", "*")

  if (req$REQUEST_METHOD == "OPTIONS") {
    res$setHeader("Access-Control-Allow-Methods", "*")
    res$setHeader("Access-Control-Allow-Headers", req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS)
    res$status <- 200
    return(list())
  } else {
    plumber::forward()
  }
}

#' capture_environment
#' @export capture_environment
capture_environment <- function(expr, response = list()) {
  env <- env(caller_env())
  response <- tryCatch(
    {
      # Run the algorithm
      tic()
      response$data <- eval(enexpr(expr), env)
      timer <- toc(quiet = T)
      response$console$runtime <- as.numeric(timer$toc - timer$tic)

      return(response)
    },
    error = function(err) {
      response$statusCode <- 400
      response$message <- paste(err)
      return(response)
    }
  )

  response
}
