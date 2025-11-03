

years <- yaml::read_yaml('config/years.yml')
start_year <- years$start
end_year <- years$end

for (file in list.files('config/sources/', pattern = '\\.ya?ml$', full.names=T)) {
  config <- yaml::read_yaml(file)
  name <- file_path_sans_ext(basename(file))
  outfile <- file.path("data", "l0", paste0(name, ".", config$format))

  request(config$base_url) |>
    req_url_query(format = config$format, year = years$end) |>
    req_perform(path = outfile)

}
