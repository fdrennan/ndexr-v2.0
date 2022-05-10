#
#* Get and Store geonames data
#* @serializer unboxedJSON
#* @param q
#* @param country
#* @get /geonames
function(q = "Brazoria", country = "") {
  response <- list(
    statusCode = 200,
    redpul_version = redpul_version,
    message = "Success!",
    console = list(
      runtime = 0,
      q = q,
      country = country
    )
  )
  response <- tryCatch(
    {
      # Run the algorithm
      tic()
      data <- get_geonames(q, country)
      con <- postgres_connector()
      dbxUpsert(con, "geo", data, where_cols = "id")
      response$data <- data

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
  return(response)
}
