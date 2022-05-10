#' charge_customer
#' @export charge_customer
charge_customer <- function(number = 4242424242424242,
                            exp_month = 06,
                            exp_year = 2026,
                            cvc = 773,
                            name = "Freddy Drennan",
                            amount = 50,
                            receipt_email = "drennanfreddy@gmail.com",
                            description = "NDEXR Charge",
                            live = FALSE,
                            currency = "usd") {
  readRenviron(".env")
  options("stripeR.secret_test" = Sys.getenv("stripeR.secret_test"))
  options("stripeR.secret_live" = Sys.getenv("stripeR.secret_live"))
  stripeR_init(live = live)
  ## Create a token you keep instead of customer details
  token <- create_card_token(
    number = number,
    exp_month = exp_month,
    exp_year = exp_year,
    cvc = cvc,
    name = name
  )

  charge_details <- charge_card(
    amount = amount,
    currency = currency,
    source = token$id,
    # ensure only this API call makes a charge
    idempotency = uuid::UUIDgenerate(),
    receipt_email = receipt_email,
    description = description
  )

  charge_details <- unlist(charge_details, use.names = T)
  charge_info <- dplyr::tibble(names = names(charge_details), values = charge_details)
  charge_info$uuid <- uuid::UUIDgenerate()
  charge_info$timestamp <- as.double(Sys.time())
  charge_info$live <- live
  readRenviron(".env")
  con <- postgres_connector()
  if (!dbExistsTable(con, "transactions")) {
    dbCreateTable(con, "transactions", charge_info)
  }
  dbAppendTable(con, "transactions", charge_info)
  charge_info
}
