remove_empty_geojsons <- function(path) {
  files <- list.files(path, "\\.geojson$", recursive = TRUE, full.names = TRUE)
  for (f in files) {
    txt <- paste(readLines(f, warn = FALSE), collapse = "")
    if (grepl('"features"\\s*:\\s*\\[\\s*\\]', txt)) {
      file.remove(f)
      cat(crayon::yellow("Deleted empty GeoJSON:", f, "\n"))
    }
  }
}