
<!-- README.md is generated from README.Rmd. Please edit that file -->

# GridMaker

<!-- badges: start -->

<!-- badges: end -->

GridMaker produces vector GIS grid datasets of various resolutions
covering user-defined countries or regions.

<img src="img/demo_ex.png" width="100%" />

It is just the translation to *R* of the [Eurostat
GridMaker](https://github.com/eurostat/GridMaker) java utility that is
used by [Eurostat-GISCO](http://ec.europa.eu/eurostat/web/gisco) for the
production of [gridded
datasets](https://ec.europa.eu/eurostat/web/gisco/geodata/grids)

## Installation

You can install the development version of GridMaker from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("fgoerlich/GridMaker")
#> ℹ Loading metadata database✔ Loading metadata database ... done
#>  
#> → Will install 31 packages.
#> → Will update 1 package.
#> → Will download 28 CRAN packages (66.53 MB), cached: 3 (1.02 MB).
#> → Will download 1 package with unknown size.
#> + classInt                0.4-11     [dl] (503.68 kB)
#> + cli                     3.6.5      [dl] (1.40 MB)
#> + DBI                     1.2.3      [dl] (939.17 kB)
#> + digest                  0.6.37     [dl] (223.12 kB)
#> + dplyr                   1.1.4      [dl] (1.58 MB)
#> + e1071                   1.7-16     [dl] (671.01 kB)
#> + furrr                   0.3.1      [dl] (1.03 MB)
#> + future                  1.58.0     [dl] (1.03 MB)
#> + generics                0.1.4      [dl] (84.66 kB)
#> + globals                 0.18.0     
#> + glue                    1.8.0      [dl] (183.69 kB)
#> + GridMaker  0.0.0.9000 → 0.0.0.9000 [bld][cmp][dl] (GitHub: 3f4e620)
#> + lifecycle               1.0.4      [dl] (141.02 kB)
#> + listenv                 0.9.1      [dl] (109.03 kB)
#> + magrittr                2.0.3      [dl] (229.25 kB)
#> + parallelly              1.45.0     [dl] (613.51 kB)
#> + pillar                  1.10.2     [dl] (671.38 kB)
#> + pkgconfig               2.0.3      [dl] (22.81 kB)
#> + proxy                   0.4-27     [dl] (181.04 kB)
#> + purrr                   1.0.4      [dl] (550.52 kB)
#> + R6                      2.6.1      [dl] (88.59 kB)
#> + Rcpp                    1.0.14     [dl] (2.90 MB)
#> + rlang                   1.1.6      [dl] (1.63 MB)
#> + s2                      1.1.9      [dl] (4.47 MB)
#> + sf                      1.0-21     [dl] (42.51 MB)
#> + tibble                  3.3.0      
#> + tidyselect              1.2.1      [dl] (227.98 kB)
#> + units                   0.8-7      [dl] (907.51 kB)
#> + utf8                    1.2.6      
#> + vctrs                   0.6.5      [dl] (1.36 MB)
#> + withr                   3.0.2      [dl] (231.63 kB)
#> + wk                      0.9.4      [dl] (2.04 MB)
#> ℹ Getting 28 pkgs (66.53 MB) and 1 pkg with unknown size, 3 (1.02 MB) cached
#> ✔ Cached copy of GridMaker 0.0.0.9000 (source) is the latest build
#> ✔ Cached copy of DBI 1.2.3 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of R6 2.6.1 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of Rcpp 1.0.14 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of classInt 0.4-11 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of cli 3.6.5 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of digest 0.6.37 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of dplyr 1.1.4 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of e1071 1.7-16 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of furrr 0.3.1 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of future 1.58.0 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of generics 0.1.4 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of glue 1.8.0 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of lifecycle 1.0.4 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of listenv 0.9.1 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of magrittr 2.0.3 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of parallelly 1.45.0 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of pillar 1.10.2 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of pkgconfig 2.0.3 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of proxy 0.4-27 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of purrr 1.0.4 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of rlang 1.1.6 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of s2 1.1.9 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of tidyselect 1.2.1 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of units 0.8-7 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of vctrs 0.6.5 (x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of withr 3.0.2 (i386+x86_64-w64-mingw32) is the latest build
#> ✔ Cached copy of wk 0.9.4 (x86_64-w64-mingw32) is the latest build
#> ✔ Got sf 1.0-21 (x86_64-w64-mingw32) (44.89 MB)
#> ✔ Installed DBI 1.2.3  (547ms)
#> ✔ Installed R6 2.6.1  (539ms)
#> ✔ Installed classInt 0.4-11  (602ms)
#> ✔ Installed cli 3.6.5  (661ms)
#> ✔ Installed digest 0.6.37  (732ms)
#> ✔ Installed e1071 1.7-16  (815ms)
#> ✔ Installed furrr 0.3.1  (850ms)
#> ✔ Installed generics 0.1.4  (880ms)
#> ✔ Installed listenv 0.9.1  (879ms)
#> ✔ Installed glue 1.8.0  (981ms)
#> ✔ Installed dplyr 1.1.4  (1.1s)
#> ✔ Installed pkgconfig 2.0.3  (952ms)
#> ✔ Installed lifecycle 1.0.4  (1.1s)
#> ✔ Installed globals 0.18.0  (1.2s)
#> ✔ Installed proxy 0.4-27  (1s)
#> ✔ Installed magrittr 2.0.3  (1.1s)
#> ✔ Installed tidyselect 1.2.1  (1s)
#> ✔ Installed utf8 1.2.6  (1s)
#> ✔ Installed pillar 1.10.2  (1.2s)
#> ✔ Installed rlang 1.1.6  (1.2s)
#> ✔ Installed purrr 1.0.4  (1.2s)
#> ✔ Installed s2 1.1.9  (1.2s)
#> ✔ Installed wk 0.9.4  (1.1s)
#> ✔ Installed withr 3.0.2  (1.2s)
#> ✔ Installed units 0.8-7  (1.3s)
#> ✔ Installed tibble 3.3.0  (1.3s)
#> ✔ Installed vctrs 0.6.5  (1.3s)
#> ✔ Installed parallelly 1.45.0  (1.5s)
#> ✔ Installed future 1.58.0  (1.7s)
#> ✔ Installed Rcpp 1.0.14  (1.8s)
#> ✔ Installed sf 1.0-21  (1.5s)
#> ℹ Packaging GridMaker 0.0.0.9000
#> ✔ Packaged GridMaker 0.0.0.9000 (383ms)
#> ℹ Building GridMaker 0.0.0.9000
#> ✔ Built GridMaker 0.0.0.9000 (667ms)
#> ✔ Installed GridMaker 0.0.0.9000 (github::fgoerlich/GridMaker@3f4e620) (44ms)
#> ✔ 1 pkg + 35 deps: kept 4, upd 1, added 31, dld 1 (44.89 MB) [34.7s]
```

## Example

This is a basic example which shows you how to use the function:

``` r
library(GridMaker)
GridMaker() |> sf::st_geometry() |> plot()
```

<img src="man/figures/README-example-1.png" width="100%" />
