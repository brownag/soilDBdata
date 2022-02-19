
# create fetchNASIS('pedons') data source
#' @rdname  create_SQLite
#' @export
create_fetchNASIS_pedons <- function(output_path = tempfile(fileext = ".sqlite"),
                                     tables = c("area", "site", "pedon", "transect", "metadata", "lookup"),
                                     SS = NULL) {
 create_SQLite(output_path = output_path, tables = tables, SS = SS)
}

# create fetchNASIS('components') data source
#' @rdname  create_SQLite
#' @export
create_fetchNASIS_components <- function(output_path = tempfile(fileext = ".sqlite"),
                                         tables = c("datamapunit", "component", "metadata", "lookup"),
                                         SS = NULL) {
  create_SQLite(output_path = output_path, tables = tables, SS = SS)
}
