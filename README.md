
<!-- README.md is generated from README.Rmd. Please edit that file -->

# GridMaker

<!-- badges: start -->

<!-- badges: end -->

GridMaker produces vector GIS grid datasets of various resolutions
covering user-defined countries or regions.

<img src="man/figures/demo_ex.png" width="100%" />

It is just the translation to *R* of the [Eurostat
GridMaker](https://github.com/eurostat/GridMaker) java utility that is
used by [Eurostat-GISCO](https://ec.europa.eu/eurostat/web/gisco) for
the production of [gridded
datasets](https://ec.europa.eu/eurostat/web/gisco/geodata/grids)

## Installation

You can install the development version of GridMaker from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("fgoerlich/GridMaker")
```

## Example

This is a basic example which shows you how to use the function:

``` r
library(ggplot2)
library(GridMaker)
region <- sf::read_sf(system.file("extdata/test_grid_area.gpkg", package = "GridMaker"))
grid <- GridMaker(region)
ggplot() +
  geom_sf(data = region, col = "blue") +
  geom_sf(data = grid, fill = NA, col = "red")
```

<img src="man/figures/README-example-1.png" width="100%" />
