
<!-- README.md is generated from README.Rmd. Please edit that file -->

# abs

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of abs is to provide a function to read csv tables downloaded
from ABS TableBuilder without having to ‘tidy’ it first. Thus, helps
retain meta information of the tables.

## Installation

You can install the development version of abs from GitHub with:

``` r
remotes::install_githib("asiripanich/abs")
```

## Example

``` r
library(abs)
data_dir <- system.file("extdata", package = "abs")
test_csv <- file.path(data_dir, "tb1.csv")
mytable <- abs_read_tb(test_csv, exclude_total = TRUE)
#> Attempting to read with fread.
#> <simpleWarning in fread(x): Found and resolved improper quoting in first 100 rows. If the fields are not quoted (e.g. field separator does not appear within any field), try quote="" to avoid this warning.>
#> 
#> 'x' is not cleaned.
#> Warning in fread(x, skip = which(has_count), header = FALSE): Previous fread()
#> session was not cleaned up properly. Cleaned up ok at the beginning of this
#> fread() call.
#> Warning in fread(x, skip = which(has_count), header = FALSE): Stopped early on
#> line 20. Expected 3 fields but found 0. Consider fill=TRUE and comment.char=.
#> First discarded non-empty line: <<"Data Source: Census of Population and
#> Housing, 2011, TableBuilder">>
mytable
#>                              Counting CACF Count of All Children in Family
#> 1: Families, Place of Usual Residence                  One child in family
#> 2: Families, Place of Usual Residence               Two children in family
#> 3: Families, Place of Usual Residence             Three children in family
#> 4: Families, Place of Usual Residence              Four children in family
#> 5: Families, Place of Usual Residence              Five children in family
#> 6: Families, Place of Usual Residence       Six or more children in family
#> 7: Families, Place of Usual Residence                       Not applicable
#>         Count
#> 1: 16.0922299
#> 2: 15.1560423
#> 3:  5.8328819
#> 4:  1.5950983
#> 5:  0.3659169
#> 6:  0.1763784
#> 7: 60.7814864
```
