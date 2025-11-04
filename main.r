library(yaml)
library(httr2)
library(tools)
library(crayon)
library(sf)
library(dplyr)

invisible(lapply(list.files("R", pattern = "\\.r$", full.names = TRUE), source))


fetch()

combine_years()
