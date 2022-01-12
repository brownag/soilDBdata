#' Create a SQLite Database
#'
#' @param output_path Output SQLite file
#' @param tables Passed to `soilDB::get_NASIS_table_name_by_purpose(purpose = ...)` with and without `SS = TRUE`
#' @param SS Use Selected Set (`..._View_1`)tables?
#'
#' @return SQLite file written to `output_path`
#' @importFrom soilDB createStaticNASIS get_NASIS_table_name_by_purpose
#' @export
create_SQLite <- function(output_path = tempfile(fileext = ".sqlite"),
                          tables = NULL,
                          SS = FALSE) {

  if (is.null(tables)) {
    tbls <- NULL
  } else {
    tbls <- switch(as.character(SS),
                 `TRUE` = soilDB::get_NASIS_table_name_by_purpose(purpose = tables, SS = TRUE),
                 `FALSE`  = soilDB::get_NASIS_table_name_by_purpose(purpose = tables))
  }

  t0 <- Sys.time()

  # create an independent sqlite db suitable for fetchNASIS
  res <- soilDB::createStaticNASIS(tables = tbls, SS = SS, output_path = output_path)

  dt <- difftime(Sys.time(), t0, units = "secs")
  if (all(unlist(res))) {
    message(
      "Wrote ", length(unlist(res)), " tables to ",
      output_path,  " in ", signif(dt, log10(as.numeric(dt)) + 2), " seconds"
    )
  }
  names(res) <- tbls
  attr(res, "output_path") <- output_path
  invisible(res)
}
