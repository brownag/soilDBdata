
<!-- README.md is generated from README.Rmd. -->

# {soilDBdata}

<!-- badges: start -->
<!-- badges: end -->

The goal of {soilDBdata} is to provide a standard way of building test
data sets for the soilDB R package. Most of these test datasets are in
the form of SQLite ‘snapshots’ of NASIS tables.

These data sets are regularly updated to support unit testing of [NASIS
functionality in the {soilDB}
package](https://github.com/ncss-tech/soilDB/blob/master/tests/testthat/test-soilDBdata.R).
A few data sets housed in this repository are also used for training
courses provided by the Soil and Plant Science Division such as
[Statistics for Soil
Survey](https://ncss-tech.github.io/stats_for_soil_survey/book/index.html).

Access to the NASIS transactional database requires eAuth and a NASIS
user account. NASIS data are intended for internal use by NRCS staff and
authorized cooperators. NASIS-related functions in {soilDB} provide a
standard read-only connection to a local NASIS instance for users that
have such access, or alternately can be supplied with the optional `dsn`
argument. The `dsn` argument can be a *DBIConnection* to an MSSQL,
SQLite or PostgreSQL database with the NASIS schema (for instance), or a
path to a SQLite database file.

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
set using SSRO_Northwest query `PedonPC_Plus_DataDump_select` targeting
Site and Pedon objects. User Site ID matches `"2015MT663%"`, NASIS site
name matches `"%"` and NASIS group name matches `"NW-MIS Point Data"`.

A total of `134` Site and Pedon objects should be found, and `115` of
those profiles are retained in `fetchNASIS()` with `rmHzErrors = TRUE`
because `19` profiles do not have horizons. These profiles represented
with a single `NA` depth horizon when `fill = TRUE`.

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
rebuild <- FALSE
dsn <- "inst/extdata/fetchNASIS_pedons.sqlite"

if (rebuild && inherits(con, 'DBIConnection')) {
  res <- create_fetchNASIS_pedons(output_path = dsn)
  DBI::dbDisconnect(con)
}

if (file.exists(dsn)) {
  
  f <- try(soilDB::fetchNASIS(
    from = "pedons",
    dsn = dsn,
    SS = TRUE,
    rmHzErrors = TRUE
  ))
  
  f2 <- try(soilDB::fetchNASIS(
    from = "pedons",
    dsn = dsn, 
    SS = FALSE, 
    fill = TRUE
  ))
  
}
#> NOTE: all records are missing artifact volume
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
#> ----- Horizons (6 / 561 rows  |  10 / 77 columns) -----
#>    peiid   phiid hzdept hzdepb hzname texture      pedon_id dspcomplayerid
#>  1092608 4718124      0      5     Oi     SPM 2015MT6630502           <NA>
#>  1092608 4718125      5     13      E   GRV-L 2015MT6630502           <NA>
#>  1092608 4718126     13     31     Bw   GRV-L 2015MT6630502           <NA>
#>  1092608 4718127     31     64    2Bw  GRX-SL 2015MT6630502           <NA>
#>  1092608 4718128     64    110     2C  CBX-SL 2015MT6630502           <NA>
#>  1092609 4718129      0      2     Oi     SPM 2015MT6630503           <NA>
#>  bounddistinct boundtopo
#>           <NA>      <NA>
#>          clear      wavy
#>          clear      wavy
#>          clear      wavy
#>           <NA>      <NA>
#>           <NA>      <NA>
#> [... more horizons ...]
#> 
#> ----- Sites (6 / 115 rows  |  10 / 147 columns) -----
#>  siteiid   peiid ecositeid ecositenm ecositecorrdate es_classifier
#>  1100702 1092608      <NA>      <NA>            <NA>          <NA>
#>  1100703 1092609      <NA>      <NA>            <NA>          <NA>
#>  1100704 1092610      <NA>      <NA>            <NA>          <NA>
#>  1100705 1092611      <NA>      <NA>            <NA>          <NA>
#>  1100706 1092612      <NA>      <NA>            <NA>          <NA>
#>  1100707 1092613      <NA>      <NA>            <NA>          <NA>
#>  siteecositehistory.classifier es_selection_method      upedonid siteobsiid
#>                           <NA>                <NA> 2015MT6630502    1076863
#>                           <NA>                <NA> 2015MT6630503    1076864
#>                           <NA>                <NA> 2015MT6630505    1076865
#>                           <NA>                <NA> 2015MT6630506    1076866
#>                           <NA>                <NA> 2015MT6630507    1076867
#>                           <NA>                <NA> 2015MT6630508    1076868
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
#> ----- Horizons (6 / 580 rows  |  10 / 77 columns) -----
#>    peiid hzID hzdept hzdepb hzname texture   phiid      pedon_id dspcomplayerid
#>  1092607    1     NA     NA   <NA>    <NA>    <NA> 2015MT6630501           <NA>
#>  1092608    2      0      5     Oi     SPM 4718124 2015MT6630502           <NA>
#>  1092608    3      5     13      E   GRV-L 4718125 2015MT6630502           <NA>
#>  1092608    4     13     31     Bw   GRV-L 4718126 2015MT6630502           <NA>
#>  1092608    5     31     64    2Bw  GRX-SL 4718127 2015MT6630502           <NA>
#>  1092608    6     64    110     2C  CBX-SL 4718128 2015MT6630502           <NA>
#>  bounddistinct
#>           <NA>
#>           <NA>
#>          clear
#>          clear
#>          clear
#>           <NA>
#> [... more horizons ...]
#> 
#> ----- Sites (6 / 134 rows  |  10 / 147 columns) -----
#>  siteiid   peiid ecositeid ecositenm ecositecorrdate es_classifier
#>  1100701 1092607      <NA>      <NA>            <NA>          <NA>
#>  1100702 1092608      <NA>      <NA>            <NA>          <NA>
#>  1100703 1092609      <NA>      <NA>            <NA>          <NA>
#>  1100704 1092610      <NA>      <NA>            <NA>          <NA>
#>  1100705 1092611      <NA>      <NA>            <NA>          <NA>
#>  1100706 1092612      <NA>      <NA>            <NA>          <NA>
#>  siteecositehistory.classifier es_selection_method      upedonid siteobsiid
#>                           <NA>                <NA> 2015MT6630501    1076862
#>                           <NA>                <NA> 2015MT6630502    1076863
#>                           <NA>                <NA> 2015MT6630503    1076864
#>                           <NA>                <NA> 2015MT6630505    1076865
#>                           <NA>                <NA> 2015MT6630506    1076866
#>                           <NA>                <NA> 2015MT6630507    1076867
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
using SSRO_Southwest query
`Whole multiple legends by area sym != addit. and DMU = yes +` targeting
Area, Legend, Mapunit and Data Mapunit objects, where Area Symbol
matches `"MT663"`.

A total of `1` Legend, `82` Mapunit and `86` Data Mapunit objects should
be downloaded into local database, with `63` (non-additional) Mapunit
and `63` Data Mapunit objects loaded into selected set.
`fetchNASIS(from="components")` will return `191` component profiles
with `fill=FALSE` and `546` with `fill=TRUE`.

``` r
library(soilDBdata)

con <- soilDB::NASIS()
rebuild <- FALSE
dsn <- "inst/extdata/fetchNASIS_components.sqlite"

if (rebuild & inherits(con, 'DBIConnection')) {
  res <- create_fetchNASIS_components(output_path = dsn)
  DBI::dbDisconnect(con)
}

if (file.exists(dsn)) {
  f <- try(soilDB::fetchNASIS(
    from = "components",
    dsn = dsn,
    SS = TRUE,
    rmHzErrors = TRUE
  ))
  
  f2 <-  try(soilDB::fetchNASIS(
    from = "components",
    dsn = dsn,
    SS = FALSE,
    fill = TRUE
  ))
}
#> NOTE: all records are missing artifact volume
#> -> QC: multiple othervegclasses / component.
#>  Use `get('multiple.otherveg.per.coiid', envir=get_soilDB_env())` for component record IDs (coiid)
#> converting profile IDs from integer to character
#> converting horizon IDs in column `chiid` to character
#> NOTE: all records are missing artifact volume
#> -> QC: multiple othervegclasses / component.
#>  Use `get('multiple.otherveg.per.coiid', envir=get_soilDB_env())` for component record IDs (coiid)
#> converting profile IDs from integer to character
#> Warning: Horizon top depths contain NA! Check depth logic with
#> aqp::checkHzDepthLogic()
#> Warning: Horizon bottom depths contain NA! Check depth logic with
#> aqp::checkHzDepthLogic()
#> Warning: cannot set `chiid` as unique component horizon key - `NA` introduced
#> by fill=TRUE

if (!is.null(f))
  show(f)
#> SoilProfileCollection with 191 profiles and 894 horizons
#> profile ID: coiid  |  horizon ID: chiid 
#> Depth range: 150 - 200 cm
#> 
#> ----- Horizons (6 / 894 rows  |  10 / 112 columns) -----
#>    coiid   chiid hzdept_r hzdepb_r hzname texture fragvoltot_l fragvoltot_r
#>  2314302 9465593        0        2     Oi     SPM            0            0
#>  2314302 9708039        2       10      E  PCNV-L           35           45
#>  2314302 9465589       10       38      C  PCNX-L           60           70
#>  2314302 9465590       38       48     Cr      BR           NA           NA
#>  2314302 9465592       48      150      R      BR           NA           NA
#>  2314304 9465398        0        4     Oe     MPT            0            0
#>  fragvoltot_h sandtotal_l
#>             0          NA
#>            55          34
#>            80          37
#>            NA          NA
#>            NA          NA
#>             0          NA
#> [... more horizons ...]
#> 
#> ----- Sites (6 / 191 rows  |  10 / 92 columns) -----
#>    coiid  dmudesc   compname comppct_r compkind majcompflag localphase
#>  2314302 6326319E Mariaspass        20   family           1      stony
#>  2314304 6326319E   Jefflake        25   family           1       <NA>
#>  2314305 6326319E   Potlatch        10   family           0       <NA>
#>  2314306 6326319E     Cowood         8   family           0 very stony
#>  2314308 6326319G Mariaspass        25   family           1      stony
#>  2314310 6326319G   Jefflake        15   family           1       <NA>
#>  drainagecl hydricrating hydgrp
#>        well           no      d
#>      poorly           no    c/d
#>      poorly          yes    c/d
#>        well           no      d
#>        well           no      d
#>      poorly           no    c/d
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
#>    coiid hzID hzdept_r hzdepb_r hzname texture   chiid fragvoltot_l
#>  1889394    1       NA       NA   <NA>    <NA>      NA           NA
#>   199488    2       NA       NA   <NA>    <NA>      NA           NA
#>  2314302    3        0        2     Oi     SPM 9465593            0
#>  2314302    4        2       10      E  PCNV-L 9708039           35
#>  2314302    5       10       38      C  PCNX-L 9465589           60
#>  2314302    6       38       48     Cr      BR 9465590           NA
#>  fragvoltot_r fragvoltot_h
#>            NA           NA
#>            NA           NA
#>             0            0
#>            45           55
#>            70           80
#>            NA           NA
#> [... more horizons ...]
#> 
#> ----- Sites (6 / 546 rows  |  10 / 92 columns) -----
#>    coiid             dmudesc   compname comppct_r           compkind
#>  1889394 NOTCOM National DMU     NOTCOM       100               <NA>
#>   199488                638W      Water       100 miscellaneous area
#>  2314302            6326319E Mariaspass        20             family
#>  2314304            6326319E   Jefflake        25             family
#>  2314305            6326319E   Potlatch        10             family
#>  2314306            6326319E     Cowood         8             family
#>  majcompflag localphase drainagecl hydricrating hydgrp
#>            1       <NA>       <NA>         <NA>   <NA>
#>            1       <NA>       <NA>     unranked   <NA>
#>            1      stony       well           no      d
#>            1       <NA>     poorly           no    c/d
#>            0       <NA>     poorly          yes    c/d
#>            0 very stony       well           no      d
#> [... more sites ...]
#> 
#> Spatial Data:
#> [EMPTY]
```

## Example 3 `soilDB::fetchVegdata()`

Create a “static” snapshot for `soilDB::fetchVegdata()` from your local
NASIS database.

The sample data for testing the `fetchVegdata()` functionality are
queried using two queries to the national database. First run
`POINT - Pedon/Site by User Site ID` with target table “Pedon” to
download “Site”, “Pedon”, and “Transect” objects where User Site ID
matches`"2010WY629%"`.. Then run
`VEG - Veg Plots by User Site ID and Vegplot ID` with target table
“Vegetation Plot” to get “Site” and “Vegetation Plot” objects where User
Site ID and Vegetation Plot ID matches `"2010WY629%"`.

The first query will result in `26` Site and `26` Pedon objects. Of the
`26` pedons, `11` have vegetation plots linked to the same site
observation. The second query will result in `137` Site, and `138`
Vegetation Plot objects. One Site Observation has two Vegetation Plot
objects linked to it. All `138` Vegetation Plots have `assocuserpedonid`
populated, but most of the pedons do not exist in NASIS. The two queries
result in `152` unique sites matching `"2010WY629%"`, of which `127`
lack Pedons and `15` lack Vegetation Plots.

``` r
library(soilDBdata)

con <- soilDB::NASIS()
rebuild <- FALSE
dsn <- "inst/extdata/fetchVegdata.sqlite"

if (rebuild && inherits(con, 'DBIConnection')) {
  res <- create_fetchVegdata(output_path = dsn)
  DBI::dbDisconnect(con)
}

if (file.exists(dsn)) {
  f <- try(soilDB::fetchVegdata(
    dsn = dsn, 
    SS = TRUE
  ))

  f2 <- try(soilDB::fetchVegdata(
    dsn = dsn, 
    SS = FALSE,
    include_pedon = "assocuserpedonid"
  ))
  
  f3 <- try(soilDB::fetchVegdata(
    dsn = dsn, 
    SS = FALSE,
    include_pedon = FALSE
  ))
}

if (!is.null(f))
  str(f, max.level = 1)
#> List of 13
#>  $ vegplot         :'data.frame':    138 obs. of  153 variables:
#>  $ vegplotlocation :'data.frame':    138 obs. of  34 variables:
#>  $ vegplotrhi      :'data.frame':    138 obs. of  32 variables:
#>  $ vegplotspecies  :'data.frame':    2087 obs. of  44 variables:
#>  $ vegtransect     :'data.frame':    138 obs. of  82 variables:
#>  $ vegtransplantsum:'data.frame':    201 obs. of  86 variables:
#>  $ vegtranspoint   :'data.frame':    763 obs. of  15 variables:
#>  $ vegprodquadrat  :'data.frame':    184 obs. of  19 variables:
#>  $ vegsiteindexsum :'data.frame':    138 obs. of  16 variables:
#>  $ vegsiteindexdet :'data.frame':    138 obs. of  20 variables:
#>  $ vegbasalarea    :'data.frame':    0 obs. of  18 variables:
#>  $ vegplottext     :'data.frame':    117 obs. of  9 variables:
#>  $ site            :'data.frame':    152 obs. of  101 variables:

if (!is.null(f2))
  str(f2, max.level = 1)
#> List of 13
#>  $ vegplot         :'data.frame':    138 obs. of  153 variables:
#>  $ vegplotlocation :'data.frame':    138 obs. of  34 variables:
#>  $ vegplotrhi      :'data.frame':    138 obs. of  32 variables:
#>  $ vegplotspecies  :'data.frame':    2087 obs. of  44 variables:
#>  $ vegtransect     :'data.frame':    138 obs. of  82 variables:
#>  $ vegtransplantsum:'data.frame':    201 obs. of  86 variables:
#>  $ vegtranspoint   :'data.frame':    763 obs. of  15 variables:
#>  $ vegprodquadrat  :'data.frame':    184 obs. of  19 variables:
#>  $ vegsiteindexsum :'data.frame':    138 obs. of  16 variables:
#>  $ vegsiteindexdet :'data.frame':    138 obs. of  20 variables:
#>  $ vegbasalarea    :'data.frame':    0 obs. of  18 variables:
#>  $ vegplottext     :'data.frame':    117 obs. of  9 variables:
#>  $ site            :'data.frame':    152 obs. of  101 variables:

if (!is.null(f3))
  str(f3, max.level = 1)
#> List of 13
#>  $ vegplot         :'data.frame':    138 obs. of  152 variables:
#>  $ vegplotlocation :'data.frame':    138 obs. of  34 variables:
#>  $ vegplotrhi      :'data.frame':    138 obs. of  32 variables:
#>  $ vegplotspecies  :'data.frame':    2087 obs. of  44 variables:
#>  $ vegtransect     :'data.frame':    138 obs. of  82 variables:
#>  $ vegtransplantsum:'data.frame':    201 obs. of  86 variables:
#>  $ vegtranspoint   :'data.frame':    763 obs. of  15 variables:
#>  $ vegprodquadrat  :'data.frame':    184 obs. of  19 variables:
#>  $ vegsiteindexsum :'data.frame':    138 obs. of  16 variables:
#>  $ vegsiteindexdet :'data.frame':    138 obs. of  20 variables:
#>  $ vegbasalarea    :'data.frame':    0 obs. of  18 variables:
#>  $ vegplottext     :'data.frame':    117 obs. of  9 variables:
#>  $ site            :'data.frame':    152 obs. of  86 variables:
```
