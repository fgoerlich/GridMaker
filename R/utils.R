#   Script Name: utils.R
#   Description: Utilities for GridMaker
#   Created By:  Paco Goerlich.
#   Date:        11/06/2025
#   Last change: 11/06/2025

#   Note: Se requiere: future::plan(multisession, workers = ##)
#         https://posit.co/blog/geospatial-distributed-processing-with-furrr/

###############
#   CELL_ID   #
###############
#   Description: Builds a GRD_ID for the grid
#
#   Arguments:
#      epsg: The EPSG code of the grid coordinate reference system.
#      res:  The grid resolution (pixel size).
#      Y_LLC: Latitud coordinate of the lower-left coner of the grid cell.
#      X_LLC: Longitud coordinate of the lower-left coner of the grid cell.
#   Value:
#      GRD_ID id cell according to INSPIRE specifications
#
CELL_ID <- function(epsg, res, Y_LLC, X_LLC){
  paste0("CRS", epsg, "RES", as.integer(res), "mN", as.integer(Y_LLC), "E", as.integer(X_LLC))
}


###################
#   grid_fields   #
###################
#   Description: Builds the grid fields as a tibble from a sfc
#
#   Arguments:
#      grid: sfc with the cell coordinates.
#      epsg: The EPSG code of the grid CRS.
#      res:  The grid resolution (pixel size).
#      gt:   SURF The type of grid cell geometry: Squared surface representation ('SURF') or its centroid ('CPT').
#   Value:
#      a tibble with 3 variables in this order: X_LLC, GRD_ID, Y_LCC
#
grid_fields <- function(grid, epsg, res, gt){
  fields <- sf::st_coordinates(grid) %>%
    tibble::as_tibble()

  if (gt == "SURF"){
    fields <- fields %>%
      dplyr::group_by(L2) %>%
      dplyr::slice_head(n = 1) %>%
      dplyr::ungroup() %>%
      dplyr::select(X_LLC = X, Y_LLC = Y) %>%
      dplyr::mutate(GRD_ID = CELL_ID(epsg, res, Y_LLC, X_LLC), .before = Y_LLC)
  } else {
    fields <- fields %>%
      dplyr::select(X_LLC = X, Y_LLC = Y) %>%
      dplyr::mutate(X_LLC = X_LLC - res/2, Y_LLC = Y_LLC - res/2) %>%
      dplyr::mutate(GRD_ID = CELL_ID(epsg, res, Y_LLC, X_LLC), .before = Y_LLC)
  }

  fields
}


###################
#   full_extend   #
###################
#   Description: Builds a full extend sf given a bbox and a CRS
#                It uses as default the full extend of GridMaker under EPSG = 3035
#
#   Arguments:
#      xmin: 0        xmin value of the bbox.
#      ymin: 0        ymin value of the bbox.
#      xmax: 10100000 xmax value of the bbox.
#      ymax: 10100000 ymax value of the bbox.
#      epsg: The EPSG code of the grid CRS.
#   Value:
#      sf of the bbox
#
full_extend <- function(xmin = 0, ymin = 0, xmax = 10100000, ymax = 10100000, epsg = 3035){
  bbox <- c(xmin = xmin, ymin = ymin, xmax = xmax, ymax = ymax)
  sf::st_bbox(bbox, crs = sf::st_crs(paste0("EPSG:", epsg))) %>%
    sf::st_as_sfc() %>%
    sf::st_sf()
}


#################
#   CellMaker   #
#################
#   Description: Builds a grid from a vector layer or a tile (that makes the role of a layer)
#
#   Arguments:
#      layer: a simple feature (sf) containing the geometry of the region to be covered by the tiles.
#      res: The grid resolution (pixel size).
#   Value:
#      sf grid
#
#   Details:
#      For internal use ONLY. No error conditions are checked
#
CellMaker <- function(layer, res){
  #   building the grid
  origin <- (sf::st_bbox(layer)[c("xmin", "ymin")]%/%res)*res
  #   full grid covering st_bbox --> sfc
  grid <- sf::st_make_grid(layer, cellsize = res, offset = origin, what = "polygons")
  sf::st_sf(geometry = grid)
}


#################
#   TileMaker   #
#################
#   Description: Makes tiles for reducing the computational burden of GridMaker,
#                so the grid is not build for the complete bounding box.
#
#   Arguments:
#      layer: a simple feature (sf) containing the geometry of the region to be covered by the tiles.
#      res: The grid resolution (pixel size).
#      tilesize: size of the tile
#   Value:
#      list of:
#        sfc grid tiles
#        sfc of intersected layer
#
#   Details:
#      For internal use ONLY. No error conditions are checked
#
TileMaker <- function(layer, res, tilesize){
  res_new <- tilesize*res
  #   building the tiles
  origin <- (sf::st_bbox(layer)[c("xmin", "ymin")]%/%res_new)*res_new
  #   full grid tile covering st_bbox --> sfc
  tiles <- sf::st_make_grid(layer, cellsize = res_new, offset = origin, what = "polygons")
  #   return only the intersecting tiles...
  tiles <- tiles[layer]
  #   ...and also the intersected layer
  layer_tiles <- sf::st_intersection(sf::st_geometry(layer), tiles)
  return(list(tiles = tiles, layer_tiles = layer_tiles))
}
