### version control ----
require(checkpoint)
# checkpoint("2017-03-18", R.version = "3.2.4", # original version
checkpoint("2019-06-30",
  R.version = "3.6.0",
  checkpointLocation = "E:/R"
)

### libraries ----

vt.list_of_packages <- c(
  "tidyverse",
  "RODBC",
  "lubridate",
  "stringr",
  "XML",
  "methods",
  "sp",
  "rgdal",
  "rgeos",
  "maptools",
  "mapdata",
  "maps",
  "ggplot2",
  "mapproj",
  "broom",
  "ggmap",
  "purrr",
  "RColorBrewer",
  "leaflet",
  "readxl",
  "httr",
  "jsonlite"
)
vt.new_packages <- vt.list_of_packages[!(vt.list_of_packages %in% installed.packages()[, "Package"])]
if (length(vt.new_packages)) install.packages(vt.new_packages)
require(tidyverse)
require(RODBC)
require(lubridate)
require(stringr)
require(XML)
require(methods)
require(sp)
require(rgdal)
require(rgeos)
require(maptools)
require(mapdata)
require(maps)
require(ggplot2)
require(mapproj)
require(broom)
require(ggmap)
require(purrr)
require(RColorBrewer)
require(leaflet)
library(readxl)
require(httr)
require(jsonlite)
# clean up environment
rm(list = ls())
gc()

### directories ----
dir.data <- "data"
dir.src <- "scripts"
dir.src_sql <- "scripts/SQL"
dir.archive <- "archive"
dir.sharepoint <- "sharepoint"

temp <- tempfile()
# https://www.rsm.govt.nz/assets/Uploads/documents/prism/prism.zip
download.file("https://www.rsm.govt.nz/assets/Uploads/documents/prism/prism.zip", temp)
Prism <- unzip(temp)
# # =============================================================================
# # Read Prism
# # =============================================================================
channel <- odbcConnectAccess("Prism")
associatedlicences <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM associatedlicences")), stringsAsFactors = FALSE) %>%
  tbl_df()
clientname <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM clientname")), stringsAsFactors = FALSE) %>%
  tbl_df()
emission <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM emission")), stringsAsFactors = FALSE) %>%
  tbl_df()
emissionlimit <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM emissionlimit")), stringsAsFactors = FALSE) %>%
  tbl_df()
geographicreference <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM geographicreference")), stringsAsFactors = FALSE) %>%
  tbl_df()
issuingoffice <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM issuingoffice")), stringsAsFactors = FALSE) %>%
  tbl_df()
licence <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM licence")), stringsAsFactors = FALSE) %>%
  tbl_df()
licenceconditions <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM licenceconditions")), stringsAsFactors = FALSE) %>%
  tbl_df()
licencetype <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM licencetype")), stringsAsFactors = FALSE) %>%
  tbl_df()
location <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM location")), stringsAsFactors = FALSE) %>%
  tbl_df()
managementright <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM managementright")), stringsAsFactors = FALSE) %>%
  tbl_df()
mapdistrict <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM mapdistrict")), stringsAsFactors = FALSE) %>%
  tbl_df()
radiationpattern <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM radiationpattern")), stringsAsFactors = FALSE) %>%
  tbl_df()
receiveconfiguration <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM receiveconfiguration")), stringsAsFactors = FALSE) %>%
  tbl_df()
spectrum <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM spectrum")), stringsAsFactors = FALSE) %>%
  tbl_df()
transmitconfiguration <- as.data.frame(sqlQuery(channel, paste("SELECT * FROM transmitconfiguration")), stringsAsFactors = FALSE) %>%
  tbl_df()
