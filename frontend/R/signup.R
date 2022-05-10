#' signup
#' @export
signup <- function() {
  column(
    6,
    offset = 3,
    div(
      wellPanel(
        h2(class = "text-center", "ndexr sign up"),
        textInput("username", "Username"),
        textInput("password", "Password"),
        textInput("email", "Email Address"),
        div(
          style = "text-align: center;",
          actionButton("signUp", "Sign Up", class = "btn-primary", style = "color: white;")
        )
      )
    )
  )
}
