#' send_email
#' @export send_email
send_email <- function(email_address, input, filename = "ndexr_export.csv",
                       subject = "Your ndexr data export is here") {
  date_time <- add_readable_time()
  email <-
    compose_email(
      body = md(glue::glue(
        "Here's your file!"
      )),
      footer = md(glue::glue("Email sent on {date_time}."))
    )

  tmpfile <- tempfile()
  readr::write_csv(input, tmpfile)
  email <- add_attachment(email, tmpfile, filename = filename)
  # browser()
  email %>%
    smtp_send(
      to = email_address,
      from = "drennanfreddy@gmail.com",
      subject = subject,
      credentials = creds_file("gmail_creds")
    )
}
