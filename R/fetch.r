fetch <- function() {

  years <- read_yaml('config/years.yml')
  source_control <- read_yaml('source_control.yml')

  for (source in names(source_control)) {

    if (source_control[[source]] == 'run') {
      config <- read_yaml(file.path("config", "sources", paste0(source, ".yml")))

      for (year in seq(years$start, years$end)) {
        outfile <- file.path("data", "l0", source, paste0(year, ".", config$format))
        dir.create(dirname(outfile), recursive = TRUE, showWarnings = FALSE)

        request(config$base_url) |>
          req_url_path_append("query") |>
          req_url_query(
            outFields = "*",
            where = paste0("End_Year=", year),
            f = config$format
          ) |>
          req_perform(path = outfile)
        } 
      cat(green("Downloaded", source, "\n"))
    } else {
      cat(red("Skipping", source, "\n"))
    }
  }
}
