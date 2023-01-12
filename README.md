
<!-- README.md is generated from README.Rmd. -->

# {soilDBdata}

<!-- badges: start -->
<!-- badges: end -->

The goal of {soilDBdata} is to provide a standard way of building test
data sets for the soilDB R package.

Test data sets for the {soilDB} package fall into several categories:

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
in the {soilDB} package.

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
#> Wrote 157 tables to inst/extdata/fetchNASIS_pedons.sqlite in 4.85 seconds
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
#>    peiid   phiid hzdept hzdepb hzname texture genhz bounddistinct boundtopo
#>  1092608 4718124      0      5     Oi     SPM  <NA>          <NA>      <NA>
#>  1092608 4718125      5     13      E   GRV-L  <NA>         clear      wavy
#>  1092608 4718126     13     31     Bw   GRV-L  <NA>         clear      wavy
#>  1092608 4718127     31     64    2Bw  GRX-SL  <NA>         clear      wavy
#>  1092608 4718128     64    110     2C  CBX-SL  <NA>          <NA>      <NA>
#>  1092609 4718129      0      2     Oi     SPM  <NA>          <NA>      <NA>
#>  clay
#>    NA
#>    16
#>    17
#>    15
#>    10
#>    NA
#> [... more horizons ...]
#> 
#> ----- Sites (6 / 115 rows  |  10 / 125 columns) -----
#>  siteiid   peiid ecositeid ecositenm ecositecorrdate es_classifier
#>  1100702 1092608      <NA>      <NA>            <NA>          <NA>
#>  1100703 1092609      <NA>      <NA>            <NA>          <NA>
#>  1100704 1092610      <NA>      <NA>            <NA>          <NA>
#>  1100705 1092611      <NA>      <NA>            <NA>          <NA>
#>  1100706 1092612      <NA>      <NA>            <NA>          <NA>
#>  1100707 1092613      <NA>      <NA>            <NA>          <NA>
#>  siteecositehistory.classifier es_selection_method      pedon_id siteobsiid
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
#> ----- Horizons (6 / 580 rows  |  10 / 73 columns) -----
#>    peiid hzID hzdept hzdepb hzname texture   phiid genhz bounddistinct
#>  1092607    1     NA     NA   <NA>    <NA>    <NA>  <NA>          <NA>
#>  1092608    2      0      5     Oi     SPM 4718124  <NA>          <NA>
#>  1092608    3      5     13      E   GRV-L 4718125  <NA>         clear
#>  1092608    4     13     31     Bw   GRV-L 4718126  <NA>         clear
#>  1092608    5     31     64    2Bw  GRX-SL 4718127  <NA>         clear
#>  1092608    6     64    110     2C  CBX-SL 4718128  <NA>          <NA>
#>  boundtopo
#>       <NA>
#>       <NA>
#>       wavy
#>       wavy
#>       wavy
#>       <NA>
#> [... more horizons ...]
#> 
#> ----- Sites (6 / 134 rows  |  10 / 125 columns) -----
#>  siteiid   peiid ecositeid ecositenm ecositecorrdate es_classifier
#>  1100701 1092607      <NA>      <NA>            <NA>          <NA>
#>  1100702 1092608      <NA>      <NA>            <NA>          <NA>
#>  1100703 1092609      <NA>      <NA>            <NA>          <NA>
#>  1100704 1092610      <NA>      <NA>            <NA>          <NA>
#>  1100705 1092611      <NA>      <NA>            <NA>          <NA>
#>  1100706 1092612      <NA>      <NA>            <NA>          <NA>
#>  siteecositehistory.classifier es_selection_method      pedon_id siteobsiid
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
#> Wrote 114 tables to inst/extdata/fetchNASIS_components.sqlite in 4.46 seconds
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
#>  Use `get('multiple.otherveg.per.coiid', envir=get_soilDB_env())` for component record IDs (coiid)
#> converting profile IDs from integer to character
#> converting horizon IDs in column `chiid` to character
#> NOTE: some records are missing rock fragment volume
#> NOTE: all records are missing artifact volume
#> -> QC: multiple othervegclasses / component.
#>  Use `get('multiple.otherveg.per.coiid', envir=get_soilDB_env())` for component record IDs (coiid)
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
#> ----- Sites (6 / 191 rows  |  10 / 87 columns) -----
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
#> ----- Sites (6 / 546 rows  |  10 / 87 columns) -----
#>    coiid             dmudesc   compname comppct_r           compkind
#>  1889394 NOTCOM National DMU     NOTCOM       100               <NA>
#>   199488                638W      Water       100 miscellaneous area
#>  2314302            6326319E Mariaspass        20             family
#>  2314304            6326319E   Jefflake        25             family
#>  2314305            6326319E   Potlatch        10             family
#>  2314306            6326319E     Cowood         8             family
#>  majcompflag localphase drainagecl hydricrating elev_l
#>            1       <NA>       <NA>         <NA>     NA
#>            1       <NA>       <NA>     unranked     NA
#>            1      stony       well           no   1625
#>            1       <NA>     poorly           no   1625
#>            0       <NA>     poorly          yes   1625
#>            0 very stony       well           no   1625
#> [... more sites ...]
#> 
#> Spatial Data:
#> [EMPTY]
```
