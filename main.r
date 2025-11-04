library(yaml)
library(httr2)
library(tools)
library(crayon)
library(sf)
library(jsonlite)

invisible(lapply(list.files("R", pattern = "\\.r$", full.names = TRUE), source))

fetch()
remove_empty_geojsons(path='data/l0')
combine_years()
