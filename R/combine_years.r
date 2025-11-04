combine_years <- function(input_dir = 'data/l0', output_dir = 'data/l1') {

  source_control <- read_yaml('source_control.yml')

  for (source in names(source_control)) {
    if (source_control[[source]] == 'run') {

      config <- read_yaml(file.path("config", "sources", paste0(source, ".yml")))

      if (config$format == 'geojson') {

        df <- NULL
        for (file in list.files(file.path(input_dir, source))) {
          tmp <- st_read(file.path(input_dir, source, file), quiet=T)
          df <- rbind(df, tmp)
        }

        dir.create(dirname(file.path(output_dir, source)), recursive = TRUE, showWarnings = FALSE)
        st_write(df, file.path(output_dir, paste0(source, '.geojson')), delete_dsn=T, quiet=T)

      } else if (config$format == 'json') {

        df <- list()

        files <- list.files(file.path(input_dir, source), full.names = TRUE)
        for (file in files) {
          tmp <- fromJSON(file)
          
          # If Census-style, first row is headers, rest are data
          if (is.matrix(tmp) || is.data.frame(tmp)) {
            headers <- tmp[1, ]
            values  <- tmp[-1, , drop = FALSE]
            tmp_list <- lapply(seq_len(nrow(values)), function(i) {
              as.list(setNames(values[i, ], headers))
            })
          } else {
            tmp_list <- tmp
          }
          
          df <- c(df, tmp_list)
        }

        dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
        write_json(df, file.path(output_dir, paste0(source, ".json")), pretty = TRUE, auto_unbox = TRUE)

      } else {
        stop("Unknown source type: ", config$source)
      }

      cat(green("Combined"), bold(source), "\n")
    } else {
      cat(yellow("Skipping source:"), bold(source), "\n")
    }
  }
}