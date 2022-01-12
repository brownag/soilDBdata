# TODO: allow a package option for standard master SQLite NASIS dsn for all tests?

test_that("create_SQLite works", {

  cat("\n")

  # need to be able to access a local NASIS instance (dsn=NULL)
  testcon <- soilDB::NASIS()
  if (!inherits(testcon, 'DBIConnection')) {
    skip("no local NASIS connection available to create SQLite snapshot")
  }
  DBI::dbDisconnect(testcon)

  # create temporary file SQLite database
  x <- create_SQLite(tables = "site")

  # path to database is stored in attribute
  sqlitepath <- attr(x, "output_path")

  # .sqlite file should exist in temp directory
  expect_true(file.exists(sqlitepath))

  # initiate SQLite connection with soilDB::NASIS(dsn=)
  con <- soilDB::NASIS(dsn = sqlitepath)

  # con should be a SQLiteConnection object
  expect_true(inherits(con, 'SQLiteConnection'))

  # perform a query (SQLite syntax) and close con
  res <- soilDB::dbQueryNASIS(con, "SELECT * FROM site LIMIT 0")

  # standard colnames should be present
  expect_true("siteiid" %in% colnames(res))

  # cleanup temp files
  unlink(sqlitepath)
})

test_that("create_fetchNASIS_pedons works", {

  cat("\n")

  # need to be able to access a local NASIS instance (dsn=NULL)
  testcon <- soilDB::NASIS()
  if (!inherits(testcon, 'DBIConnection')) {
    skip("no local NASIS connection available to create SQLite snapshot")
  }
  DBI::dbDisconnect(testcon)

  # create temporary file SQLite database
  x <- create_fetchNASIS_pedons()

  # path to database is stored in attribute
  sqlitepath <- attr(x, "output_path")

  # .sqlite file should exist in temp directory
  expect_true(file.exists(sqlitepath))

  # initiate SQLite connection with soilDB::NASIS(dsn=)
  con <- soilDB::NASIS(dsn = sqlitepath)

  # con should be a SQLiteConnection object
  expect_true(inherits(con, 'SQLiteConnection'))

  # perform a query (SQLite syntax) and close con
  res <- soilDB::dbQueryNASIS(con, "SELECT * FROM pedon LIMIT 0")
  # res <- fetchNASIS(from = "pedons")

  # standard colnames should be present
  expect_true("peiid" %in% colnames(res))

  # cleanup temp files
  unlink(sqlitepath)
})

test_that("create_fetchNASIS_components works", {

  cat("\n")

  # need to be able to access a local NASIS instance (dsn=NULL)
  testcon <- soilDB::NASIS()
  if (!inherits(testcon, 'DBIConnection')) {
    skip("no local NASIS connection available to create SQLite snapshot")
  }
  DBI::dbDisconnect(testcon)

  # create temporary file SQLite database
  x <- create_fetchNASIS_components()

  # path to database is stored in attribute
  sqlitepath <- attr(x, "output_path")

  # .sqlite file should exist in temp directory
  expect_true(file.exists(sqlitepath))

  # initiate SQLite connection with soilDB::NASIS(dsn=)
  con <- soilDB::NASIS(dsn = sqlitepath)

  # con should be a SQLiteConnection object
  expect_true(inherits(con, 'SQLiteConnection'))

  # perform a query (SQLite syntax) and close con
  res <- soilDB::dbQueryNASIS(con, "SELECT * FROM component LIMIT 0")
  # res <- fetchNASIS(from = "components")

  # standard colnames should be present
  expect_true("coiid" %in% colnames(res))

  # cleanup temp files
  unlink(sqlitepath)
})

