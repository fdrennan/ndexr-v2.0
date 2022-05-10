# eventReactive(input$email, {
#   send.mail(
#     from = "drennanfreddy@gmail.com",
#     to = "drennanfreddy@gmail.com",
#     subject = "Hello from R",
#     body = "This message was \nsent from R",
#     smtp = list(
#       host.name = "smtp.gmail.com", port = 465,
#       user.name = "drennanfreddy@gmail.com",
#       passwd = "AeliaEmerson32",
#       ssl = TRUE
#     ),
#     authenticate = TRUE,
#     send = TRUE,
#     attach.files = c("C:/Users/Redbock/Documents/gmailr/gmailsend.R", "C:/Users/Redbock/Documents/gmailr/hello.txt")
#   )
# })

# library(gmailr)
#
# gm_auth_configure(path = 'gmail.json')
# gm_auth()

library(blastula)
# AeliaEmerson32
# create_smtp_creds_file(
#   host = 'smtp.gmail.com', port = 465, file = 'gmail_creds',  user = 'drennanfreddy@gmail.com', provider = 'gmail'
# )

date_time <- add_readable_time()

# img_string <- add_image(file = img_file_path)


email <-
  compose_email(
    body = md(glue::glue(
      "Here's your file!"
    )),
    footer = md(glue::glue("Email sent on {date_time}."))
  )

email <- add_attachment(email, "Dockerfile")

email

# Sending email by SMTP using a credentials file
email %>%
  smtp_send(
    to = "drennanfreddy@gmail.com",
    from = "drennanfreddy@gmail.com",
    subject = "Testing the `smtp_send()` function",
    credentials = creds_file("gmail_creds")
  )
