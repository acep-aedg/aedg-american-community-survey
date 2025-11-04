combine_years <- function(input_dir = 'data/l0', output_dir = 'data/l1') {

  source_control <- read_yaml('source_control.yml')

  for (source in names(source_control)) {
    if (source_control[[source]] == 'run') {

      df <- NULL
      for (file in list.files(file.path(input_dir, source))) {
        tmp <- st_read(file.path(input_dir, source, file), quiet=T)
        df <- rbind(df, tmp)
      }

      dir.create(dirname(file.path(output_dir, source)), recursive = TRUE, showWarnings = FALSE)
      
      st_write(df, file.path(output_dir, paste0(source, '.geojson')), delete_dsn=T, quiet=T)

      cat(green("Combined", source, "\n"))
    } else {
      cat(red("Skipping", source, "\n"))
    }
  }
}