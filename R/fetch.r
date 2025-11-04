fetch <- function() {
  
  years <- read_yaml("config/years.yml")
  source_control <- read_yaml("source_control.yml")

  for (source in names(source_control)) {

    if (source_control[[source]] == "run") {
      config <- read_yaml(file.path("config", "sources", paste0(source, ".yml")))
      cat(blue("Running source:"), bold(source), "\n")

      for (year in seq(years$start, years$end)) {
        outfile <- file.path("data", "l0", source, paste0(year, ".", config$format))
        dir.create(dirname(outfile), recursive = TRUE, showWarnings = FALSE)

        tryCatch({

          if (config$source == "census") {
            base_url <- config$base_url
            dataset  <- config$dataset
            api_key  <- config$api_key

            req <- request(base_url) |>
              req_url_path_append(year, dataset) |>
              req_url_query(
                get  = "NAME,group(S1901)",
                `for` = "place:*",
                `in`  = "state:02",
                key   = Sys.getenv("CENSUS_API_KEY")
              )

          } else if (config$source == "dcra") {
            req <- request(config$base_url) |>
              req_url_path_append("query") |>
              req_url_query(
                outFields = "*",
                where = paste0("End_Year=", year),
                f = config$format
              )
          } else {
            stop("Unknown source type: ", config$source)
          }

          resp <- req_perform(req)
          status <- resp_status(resp)

          if (status >= 200 && status < 300) {
            writeBin(resp_body_raw(resp), outfile)
            cat(green("\t", "Downloaded", source, "for", year, "\n"))
          } else {
            warning(yellow(paste("Request failed for", source, "year", year, "status", status)))
          }

        }, error = function(e) {
          cat(red("Error fetching", source, "year", year, ":", conditionMessage(e)), "\n")
        })
      }

    } else {
      cat(yellow("Skipping source:"), bold(source), "\n")
    }
  }
}