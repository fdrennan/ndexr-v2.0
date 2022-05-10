
### directories ----
dir.data <- "data"
dir.src <- "scripts"
dir.src_sql <- "scripts/SQL"
dir.archive <- "archive"
dir.sharepoint <- "sharepoint"
library(state)
library(redpul)
dotenv::load_dot_env()
library(ImportExport)

require(RODBC)
require(lubridate)
require(stringr)
require(methods)
require(purrr)
require(httr)
require(jsonlite)

temp <- tempfile()
# https://www.rsm.govt.nz/assets/Uploads/documents/prism/prism.zip
# download.file("https://www.rsm.govt.nz/assets/Uploads/documents/prism/prism.zip", temp)
# Prism <- unzip(temp)

channel <- odbcDriverConnect(
  "/home/freddy/Projects/current/redpul/scripts/prism.mdb"
)


associatedlicences <- as.data.frame(sqlQuery(
  channel, paste("SELECT * FROM associatedlicences")
), stringsAsFactors = FALSE)
#
# clientname <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM clientname")), stringsAsFactors = FALSE) %>%
#   tbl_df()
# emission <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM emission")), stringsAsFactors = FALSE) %>%
#   tbl_df()
# emissionlimit <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM emissionlimit")), stringsAsFactors = FALSE) %>%
#   tbl_df()
# geographicreference <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM geographicreference")), stringsAsFactors = FALSE) %>%
#   tbl_df()
# issuingoffice <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM issuingoffice")), stringsAsFactors = FALSE) %>%
#   tbl_df()
# licence <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM licence")), stringsAsFactors = FALSE) %>%
#   tbl_df()
# licenceconditions <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM licenceconditions")), stringsAsFactors = FALSE) %>%
#   tbl_df()
# licencetype <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM licencetype")), stringsAsFactors = FALSE) %>%
#   tbl_df()
# location <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM location")), stringsAsFactors = FALSE) %>%
#   tbl_df()
# managementright <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM managementright")), stringsAsFactors = FALSE) %>%
#   tbl_df()
# mapdistrict <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM mapdistrict")), stringsAsFactors = FALSE) %>%
#   tbl_df()
# radiationpattern <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM radiationpattern")), stringsAsFactors = FALSE) %>%
#   tbl_df()
# receiveconfiguration <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM receiveconfiguration")), stringsAsFactors = FALSE) %>%
#   tbl_df()
# spectrum <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM spectrum")), stringsAsFactors = FALSE) %>%
#   tbl_df()
# transmitconfiguration <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM transmitconfiguration")), stringsAsFactors = FALSE) %>%
#   tbl_df()
