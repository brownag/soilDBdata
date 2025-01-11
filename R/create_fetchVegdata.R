# create fetchVegdata() data source
#' @rdname  create_SQLite
#' @export
create_fetchVegdata <- function(output_path = tempfile(fileext = ".sqlite"),
                                     tables = c("area", "site", "pedon", "transect", "vegetation", "metadata", "lookup", "nasis"),
                                     SS = NULL) {
  create_SQLite(output_path = output_path, tables = tables, SS = SS)
}

