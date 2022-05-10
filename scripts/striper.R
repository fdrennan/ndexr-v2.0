library(stripeR)
dotenv::load_dot_env("../.env")
stripeR_init()
options("stripeR.secret_test" = Sys.getenv("stripeR.secret_test"))
options("stripeR.secret_live" = Sys.getenv("stripeR.secret_live"))



## Create a token you keep instead of customer details
token <- create_card_token(
  number = 4242424242424242,
  exp_month = 12,
  exp_year = 2023,
  cvc = 123,
  name = "Mark E"
)

## charge a card €1
charge_details <- charge_card(
  amount = 100,
  currency = "eur",
  source = token$id,
  # ensure only this API call makes a charge
  idempotency = idempotency(),
  receipt_email = "drennanfreddy@gmail.com",
  description = "Nice stuff"
)


charge_details
