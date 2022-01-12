
<!-- README.md is generated from README.Rmd. Please edit that file -->

# soilDBdata

<!-- badges: start -->
<!-- badges: end -->

The goal of soilDBdata is to provide a standard way of building test
data sets for the soilDB R package.

Test data sets for the soilDB package fall into several categories:

#### 1. NASIS SQLite ‘snapshots’

Access to the NASIS transactional database requires eAuth and a NASIS
user account. NASIS data are intended for internal use by NRCS staff and
authorized cooperators. NASIS-related functions in {soilDB} provide a
standard read-only connection to a local NASIS instance for users that
have such access, or alternately can be supplied with the optional `dsn`
argument. The `dsn` argument can be a *DBIConnection* to an MSSQL,
SQLite or PostgreSQL database with the NASIS schema (for instance), or a
path to a SQLite database file.

A few pedon datasets are used for the trainings provided by the Soil and
Plant Science Division. These datasets are regularly updated as SQLite
snapshots in this package to support unit testing of NASIS functionality
in the soilDB package.

#### …

## Installation

You can install the released version of {soilDBdata} from GitHub with:

``` r
remotes::install_github("brownag/soilDBdata")
```

## Example 1 `soilDB::fetchNASIS('pedons')`

This is an example that shows you how to create a snapshot of the tables
in your local database for running `fetchNASIS()` without a local NASIS
local database.

<!-- The following groups of tables are used by `fetchNASIS()` and related Site/Pedon-level queries in {soilDB}: -->
<!-- ```{r echo=FALSE} -->
<!-- # NASIS Table -->
<!-- knitr::kable(data.frame(soilDB::get_NASIS_table_name_by_purpose( -->
<!--   purpose = c("site", "pedon", "transect", "metadata", "lookup") -->
<!-- )), col.names = "Table") -->
<!-- ``` -->

Create a “static” snapshot for `soilDB::fetchNASIS('pedons')` from your
local NASIS database.

``` r
library(soilDBdata)

con <- soilDB::NASIS()
#> Loading required namespace: odbc

if (inherits(con, 'DBIConnection')) 
  res <- create_fetchNASIS_pedons(output_path = "inst/extdata/fetchNASIS_pedons.sqlite")
#> Loading required namespace: RSQLite
#> Wrote 76 tables to inst/extdata/fetchNASIS_pedons.sqlite in 7.78 seconds
DBI::dbDisconnect(con)

if (!is.null(res)){
  f <- try(soilDB::fetchNASIS(dsn = attr(res, 'output_path'), 
                              SS = FALSE))
  f2 <- try(soilDB::fetchNASIS(dsn = attr(res, 'output_path'),
                               SS = FALSE, 
                               rmHzErrors = FALSE))
}
#> NOTE: some records are missing surface fragment cover
#> mixing dry colors ... [1 of 98 horizons]
#> mixing moist colors ... [1 of 454 horizons]
#> NOTE: some records are missing rock fragment volume
#> -> QC: some fragsize_h values == 76mm, may be mis-classified as cobbles [93 / 907 records]
#> NOTE: all records are missing artifact volume
#> NOTE: some records are missing surface fragment cover
#> mixing dry colors ... [1 of 98 horizons]
#> mixing moist colors ... [1 of 454 horizons]
#> NOTE: some records are missing rock fragment volume
#> -> QC: some fragsize_h values == 76mm, may be mis-classified as cobbles [93 / 907 records]
#> NOTE: all records are missing artifact volume

if (!is.null(f))
  show(f)
#> SoilProfileCollection with 115 profiles and 561 horizons
#> profile ID: peiid  |  horizon ID: phiid 
#> Depth range: 30 - 150 cm
#> 
#> ----- Horizons (6 / 561 rows  |  10 / 73 columns) -----
#>  hzname   peiid   phiid hzdept hzdepb genhz bounddistinct boundtopo clay silt
#>      Oi 1092608 4718124      0      5  <NA>          <NA>      <NA>   NA   NA
#>       E 1092608 4718125      5     13  <NA>         clear      wavy   16   41
#>      Bw 1092608 4718126     13     31  <NA>         clear      wavy   17   42
#>     2Bw 1092608 4718127     31     64  <NA>         clear      wavy   15   30
#>      2C 1092608 4718128     64    110  <NA>          <NA>      <NA>   10   19
#>      Oi 1092609 4718129      0      2  <NA>          <NA>      <NA>   NA   NA
#> [... more horizons ...]
#> 
#> ----- Sites (6 / 115 rows  |  10 / 121 columns) -----
#>  siteiid   peiid      pedon_id       site_id   obs_date utmzone utmeasting
#>  1100702 1092608 2015MT6630502 2015MT6630502 2015-06-19      12   269662.2
#>  1100703 1092609 2015MT6630503 2015MT6630503 2015-06-19      12   271991.7
#>  1100704 1092610 2015MT6630505 2015MT6630505 2015-08-09      12   332411.8
#>  1100705 1092611 2015MT6630506 2015MT6630506 2015-07-17      12   291297.7
#>  1100706 1092612 2015MT6630507 2015MT6630507 2015-07-18      12   294229.4
#>  1100707 1092613 2015MT6630508 2015MT6630508 2015-07-18      12   294287.4
#>  utmnorthing         x        y
#>      5387224 -114.1242 48.59568
#>      5386371 -114.0921 48.58888
#>      5363082 -113.2642 48.39861
#>      5417307 -113.8463 48.87357
#>      5419511 -113.8075 48.89435
#>      5419237 -113.8066 48.89191
#> [... more sites ...]
#> 
#> Spatial Data:
#> [EMPTY]

if (!is.null(f2))
  show(f2)
#> SoilProfileCollection with 115 profiles and 561 horizons
#> profile ID: peiid  |  horizon ID: phiid 
#> Depth range: 30 - 150 cm
#> 
#> ----- Horizons (6 / 561 rows  |  10 / 73 columns) -----
#>  hzname   peiid   phiid hzdept hzdepb genhz bounddistinct boundtopo clay silt
#>      Oi 1092608 4718124      0      5  <NA>          <NA>      <NA>   NA   NA
#>       E 1092608 4718125      5     13  <NA>         clear      wavy   16   41
#>      Bw 1092608 4718126     13     31  <NA>         clear      wavy   17   42
#>     2Bw 1092608 4718127     31     64  <NA>         clear      wavy   15   30
#>      2C 1092608 4718128     64    110  <NA>          <NA>      <NA>   10   19
#>      Oi 1092609 4718129      0      2  <NA>          <NA>      <NA>   NA   NA
#> [... more horizons ...]
#> 
#> ----- Sites (6 / 115 rows  |  10 / 121 columns) -----
#>  siteiid   peiid      pedon_id       site_id   obs_date utmzone utmeasting
#>  1100702 1092608 2015MT6630502 2015MT6630502 2015-06-19      12   269662.2
#>  1100703 1092609 2015MT6630503 2015MT6630503 2015-06-19      12   271991.7
#>  1100704 1092610 2015MT6630505 2015MT6630505 2015-08-09      12   332411.8
#>  1100705 1092611 2015MT6630506 2015MT6630506 2015-07-17      12   291297.7
#>  1100706 1092612 2015MT6630507 2015MT6630507 2015-07-18      12   294229.4
#>  1100707 1092613 2015MT6630508 2015MT6630508 2015-07-18      12   294287.4
#>  utmnorthing         x        y
#>      5387224 -114.1242 48.59568
#>      5386371 -114.0921 48.58888
#>      5363082 -113.2642 48.39861
#>      5417307 -113.8463 48.87357
#>      5419511 -113.8075 48.89435
#>      5419237 -113.8066 48.89191
#> [... more sites ...]
#> 
#> Spatial Data:
#> [EMPTY]
```

## Example 2 `soilDB::fetchNASIS('components')`

Create a “static” snapshot for `soilDB::fetchNASIS('components')` from
your local NASIS database.

``` r
library(soilDBdata)

con <- soilDB::NASIS()

if (inherits(con, 'DBIConnection')) 
  res <- create_fetchNASIS_components(output_path = "inst/extdata/fetchNASIS_components.sqlite")
#> Wrote 48 tables to inst/extdata/fetchNASIS_components.sqlite in 6.26 seconds
DBI::dbDisconnect(con)

if (!is.null(res)){
  f <- try(soilDB::fetchNASIS(from = "components",
                              dsn = attr(res, 'output_path'),
                              SS = FALSE))
  
  f2 <-  try(soilDB::fetchNASIS(from = "components",
                                dsn = attr(res, 'output_path'),
                                SS = FALSE,
                                rmHzErrors = FALSE))
}
#> NOTE: some records are missing rock fragment volume
#> NOTE: all records are missing artifact volume
#> -> QC: multiple othervegclasses / component.
#>  Use `get('multiple.otherveg.per.coiid', envir=soilDB.env)` for component record IDs (coiid)
#> converting profile IDs from integer to character
#> converting horizon IDs in column `chiid` to character
#> NOTE: some records are missing rock fragment volume
#> NOTE: all records are missing artifact volume
#> -> QC: multiple othervegclasses / component.
#>  Use `get('multiple.otherveg.per.coiid', envir=soilDB.env)` for component record IDs (coiid)
#> converting profile IDs from integer to character
#> converting horizon IDs in column `chiid` to character

if (!is.null(f))
  show(f)
#> SoilProfileCollection with 392 profiles and 1824 horizons
#> profile ID: coiid  |  horizon ID: chiid 
#> Depth range: 150 - 200 cm
#> 
#> ----- Horizons (6 / 1824 rows  |  10 / 112 columns) -----
#>  hzname   coiid   chiid hzdept_r hzdepb_r texture fragvoltot_l fragvoltot_r
#>      Oi 2314302 9465593        0        2     SPM            0            0
#>       E 2314302 9708039        2       10  PCNV-L           35           45
#>       C 2314302 9465589       10       38  PCNX-L           60           70
#>      Cr 2314302 9465590       38       48      BR           NA           NA
#>       R 2314302 9465592       48      150      BR           NA           NA
#>      Oe 2314304 9465398        0        4     MPT            0            0
#>  fragvoltot_h sandtotal_l
#>             0          NA
#>            55          34
#>            80          37
#>            NA          NA
#>            NA          NA
#>             0          NA
#> [... more horizons ...]
#> 
#> ----- Sites (6 / 392 rows  |  10 / 87 columns) -----
#>    coiid  dmudesc   compname comppct_r compkind majcompflag localphase
#>  2314302 6326319E Mariaspass        20   family           1      stony
#>  2314304 6326319E   Jefflake        25   family           1       <NA>
#>  2314305 6326319E   Potlatch        10   family           0       <NA>
#>  2314306 6326319E     Cowood         8   family           0 very stony
#>  2314308 6326319G Mariaspass        25   family           1      stony
#>  2314310 6326319G   Jefflake        15   family           1       <NA>
#>  drainagecl hydricrating elev_l
#>        well           no   1625
#>      poorly           no   1625
#>      poorly          yes   1625
#>        well           no   1625
#>        well           no   1775
#>      poorly           no   1775
#> [... more sites ...]
#> 
#> Spatial Data:
#> [EMPTY]

if (!is.null(f2))
  show(f2)
#> SoilProfileCollection with 392 profiles and 1824 horizons
#> profile ID: coiid  |  horizon ID: chiid 
#> Depth range: 150 - 200 cm
#> 
#> ----- Horizons (6 / 1824 rows  |  10 / 112 columns) -----
#>  hzname   coiid   chiid hzdept_r hzdepb_r texture fragvoltot_l fragvoltot_r
#>      Oi 2314302 9465593        0        2     SPM            0            0
#>       E 2314302 9708039        2       10  PCNV-L           35           45
#>       C 2314302 9465589       10       38  PCNX-L           60           70
#>      Cr 2314302 9465590       38       48      BR           NA           NA
#>       R 2314302 9465592       48      150      BR           NA           NA
#>      Oe 2314304 9465398        0        4     MPT            0            0
#>  fragvoltot_h sandtotal_l
#>             0          NA
#>            55          34
#>            80          37
#>            NA          NA
#>            NA          NA
#>             0          NA
#> [... more horizons ...]
#> 
#> ----- Sites (6 / 392 rows  |  10 / 87 columns) -----
#>    coiid  dmudesc   compname comppct_r compkind majcompflag localphase
#>  2314302 6326319E Mariaspass        20   family           1      stony
#>  2314304 6326319E   Jefflake        25   family           1       <NA>
#>  2314305 6326319E   Potlatch        10   family           0       <NA>
#>  2314306 6326319E     Cowood         8   family           0 very stony
#>  2314308 6326319G Mariaspass        25   family           1      stony
#>  2314310 6326319G   Jefflake        15   family           1       <NA>
#>  drainagecl hydricrating elev_l
#>        well           no   1625
#>      poorly           no   1625
#>      poorly          yes   1625
#>        well           no   1625
#>        well           no   1775
#>      poorly           no   1775
#> [... more sites ...]
#> 
#> Spatial Data:
#> [EMPTY]
```
