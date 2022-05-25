
<!-- README.md is generated from README.Rmd. -->

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
database.

The sample data for testing the `from="pedons"` functionality are
queried into the local database, accepted, and queried into and selected
set using MLRA04_Bozeman query `_PedonPC_Plus_DataDump_select` targeting
Site and Pedon objects. User Site ID matches `"2015MT663%"`, NASIS site
name matches `"%"` and NASIS group name matches `"4-MIS Pedons"`. A
total of `134` Site and Pedon objects should be found.

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
#> Wrote 154 tables to inst/extdata/fetchNASIS_pedons.sqlite in 4.51 seconds
DBI::dbDisconnect(con)

if (!is.null(res)) {
  f <- try(soilDB::fetchNASIS(dsn = attr(res, 'output_path'), 
                              SS = TRUE,
                              rmHzErrors = TRUE))
  f2 <- try(soilDB::fetchNASIS(dsn = attr(res, 'output_path'),
                               SS = FALSE, 
                               fill = TRUE))
}
#> NOTE: some records are missing surface fragment cover
#> mixing dry colors ... [1 of 98 horizons]
#> mixing moist colors ... [1 of 454 horizons]
#> NOTE: some records are missing rock fragment volume
#> NOTE: all records are missing artifact volume
#> NOTE: some records are missing surface fragment cover
#> mixing dry colors ... [1 of 98 horizons]
#> mixing moist colors ... [1 of 454 horizons]
#> NOTE: some records are missing rock fragment volume
#> NOTE: all records are missing artifact volume
#> Warning: Horizon top depths contain NA! Check depth logic with
#> aqp::checkHzDepthLogic()
#> Warning: Horizon bottom depths contain NA! Check depth logic with
#> aqp::checkHzDepthLogic()
#> Warning: cannot set `phiid` as unique pedon horizon key - `NA` introduced by
#> fill=TRUE

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
#> ----- Sites (6 / 115 rows  |  10 / 123 columns) -----
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
#> SoilProfileCollection with 134 profiles and 580 horizons
#> profile ID: peiid  |  horizon ID: hzID 
#> Depth range: 30 - 150 cm
#> 
#> ----- Horizons (6 / 580 rows  |  10 / 73 columns) -----
#>  hzname   peiid hzID hzdept hzdepb   phiid genhz bounddistinct boundtopo clay
#>    <NA> 1092607    1     NA     NA    <NA>  <NA>          <NA>      <NA>   NA
#>      Oi 1092608    2      0      5 4718124  <NA>          <NA>      <NA>   NA
#>       E 1092608    3      5     13 4718125  <NA>         clear      wavy   16
#>      Bw 1092608    4     13     31 4718126  <NA>         clear      wavy   17
#>     2Bw 1092608    5     31     64 4718127  <NA>         clear      wavy   15
#>      2C 1092608    6     64    110 4718128  <NA>          <NA>      <NA>   10
#> [... more horizons ...]
#> 
#> ----- Sites (6 / 134 rows  |  10 / 123 columns) -----
#>  siteiid   peiid      pedon_id       site_id   obs_date utmzone utmeasting
#>  1100701 1092607 2015MT6630501 2015MT6630501 2015-06-06      12   265103.6
#>  1100702 1092608 2015MT6630502 2015MT6630502 2015-06-19      12   269662.2
#>  1100703 1092609 2015MT6630503 2015MT6630503 2015-06-19      12   271991.7
#>  1100704 1092610 2015MT6630505 2015MT6630505 2015-08-09      12   332411.8
#>  1100705 1092611 2015MT6630506 2015MT6630506 2015-07-17      12   291297.7
#>  1100706 1092612 2015MT6630507 2015MT6630507 2015-07-18      12   294229.4
#>  utmnorthing         x        y
#>      5414112 -114.2012 48.83550
#>      5387224 -114.1242 48.59568
#>      5386371 -114.0921 48.58888
#>      5363082 -113.2642 48.39861
#>      5417307 -113.8463 48.87357
#>      5419511 -113.8075 48.89435
#> [... more sites ...]
#> 
#> Spatial Data:
#> [EMPTY]
```

## Example 2 `soilDB::fetchNASIS('components')`

Create a “static” snapshot for `soilDB::fetchNASIS('components')` from
your local NASIS database.

The sample data for testing the `from="components"` functionality are
queried into the local database, accepted, and queried into selected set
using MLRA02_Davis query
`Whole multiple legends by area sym != addit. and DMU = yes +` targeting
Area, Legend, Mapunit and Data Mapunit objects. Area Symbol matches
`"MT663"`. A total of `1` Legend, `82` Mapunit and `86` Data Mapunit
objects should be brought into local database. A total of `1` Area, `1`
Legend, `63` Mapunit and `63` Data Mapunit objects should be brought
into selected set.

``` r
library(soilDBdata)

con <- soilDB::NASIS()

if (inherits(con, 'DBIConnection')) 
  res <- create_fetchNASIS_components(output_path = "inst/extdata/fetchNASIS_components.sqlite")
#> Wrote 114 tables to inst/extdata/fetchNASIS_components.sqlite in 4.35 seconds
DBI::dbDisconnect(con)

if (!is.null(res)) {
  f <- try(soilDB::fetchNASIS(from = "components",
                              dsn = attr(res, 'output_path'),
                              SS = TRUE,
                              rmHzErrors = TRUE))
  
  f2 <-  try(soilDB::fetchNASIS(from = "components",
                                dsn = attr(res, 'output_path'),
                                SS = FALSE, 
                                fill = TRUE))
}
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
#> Warning: Horizon top depths contain NA! Check depth logic with
#> aqp::checkHzDepthLogic()
#> Warning: Horizon bottom depths contain NA! Check depth logic with
#> aqp::checkHzDepthLogic()
#> Warning: cannot set `chiid` as unique component horizon key - `NA` introduced by
#> fill=TRUE

if (!is.null(f))
  show(f)
#> SoilProfileCollection with 191 profiles and 894 horizons
#> profile ID: coiid  |  horizon ID: chiid 
#> Depth range: 150 - 200 cm
#> 
#> ----- Horizons (6 / 894 rows  |  10 / 112 columns) -----
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
#> ----- Sites (6 / 191 rows  |  10 / 109 columns) -----
#>    coiid  liid dmuiid  dmudesc   compname comppct_r compkind majcompflag
#>  2314302 20908 715195 6326319E Mariaspass        20   family           1
#>  2314304 20908 715195 6326319E   Jefflake        25   family           1
#>  2314305 20908 715195 6326319E   Potlatch        10   family           0
#>  2314306 20908 715195 6326319E     Cowood         8   family           0
#>  2314308 20908 715194 6326319G Mariaspass        25   family           1
#>  2314310 20908 715194 6326319G   Jefflake        15   family           1
#>  localphase drainagecl
#>       stony       well
#>        <NA>     poorly
#>        <NA>     poorly
#>  very stony       well
#>       stony       well
#>        <NA>     poorly
#> [... more sites ...]
#> 
#> Spatial Data:
#> [EMPTY]

if (!is.null(f2))
  show(f2)
#> SoilProfileCollection with 546 profiles and 1978 horizons
#> profile ID: coiid  |  horizon ID: hzID 
#> Depth range: 150 - 200 cm
#> 
#> ----- Horizons (6 / 1978 rows  |  10 / 112 columns) -----
#>  hzname   coiid hzID hzdept_r hzdepb_r   chiid texture fragvoltot_l
#>    <NA> 1889394    1       NA       NA      NA    <NA>           NA
#>    <NA>  199488    2       NA       NA      NA    <NA>           NA
#>      Oi 2314302    3        0        2 9465593     SPM            0
#>       E 2314302    4        2       10 9708039  PCNV-L           35
#>       C 2314302    5       10       38 9465589  PCNX-L           60
#>      Cr 2314302    6       38       48 9465590      BR           NA
#>  fragvoltot_r fragvoltot_h
#>            NA           NA
#>            NA           NA
#>             0            0
#>            45           55
#>            70           80
#>            NA           NA
#> [... more horizons ...]
#> 
#> ----- Sites (6 / 546 rows  |  10 / 109 columns) -----
#>    coiid  liid dmuiid             dmudesc   compname comppct_r
#>  1889394 20908 566914 NOTCOM National DMU     NOTCOM       100
#>   199488    NA 105969                638W      Water       100
#>  2314302 20908 715195            6326319E Mariaspass        20
#>  2314304 20908 715195            6326319E   Jefflake        25
#>  2314305 20908 715195            6326319E   Potlatch        10
#>  2314306 20908 715195            6326319E     Cowood         8
#>            compkind majcompflag localphase drainagecl
#>                <NA>           1       <NA>       <NA>
#>  miscellaneous area           1       <NA>       <NA>
#>              family           1      stony       well
#>              family           1       <NA>     poorly
#>              family           0       <NA>     poorly
#>              family           0 very stony       well
#> [... more sites ...]
#> 
#> Spatial Data:
#> [EMPTY]
```
