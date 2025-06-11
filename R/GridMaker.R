#################
#   GridMaker   #
#################
#   Description: Builds a grid from a vector layer
#                R version of GridMaker from Eurostat: https://github.com/eurostat/GridMaker
#
#   Arguments:
#      layer: a simple feature (sf) containing the geometry of the region to be covered by the grid.
#             if NULL the full extend of GridMaker under EPSG = 3035
#      res: 100 000 The grid resolution (pixel size).
#                   The unit of measure is expected to be the same as the one of the CRS.
#                   Minimun value allowed 1
#      epsg: 3035 (corresponding to ETRS89-LAEA) The EPSG code of the grid CRS.
#                 Only proyected layers are allowed
#      tol: 0 (buffer on layer) A tolerance distance to keep the cells that are not too far from the layer.
#                               This uses st_buffer() before building the grid with default values.
#                               Negative tol is possible
#      gt: SURF The type of grid cell geometry: Squared surface representation ('SURF') or its centroid ('CPT').
#      tilesize: tile size if the computation has to be done using tiles (strongly recomended for big grids)
#                tilesize is an scale factor so the eventual tile size = res*tilesize
#      progress: FALSE/TRUE show progress in case of tiling.
#      parallel: FALSE/TRUE in case of tiling, if the proccess should be run in parallel.
#                Requires "future::plan(multisession, workers = ##)" outside the function.
#      ... Other parameters passed onto buffer if tol > 0.
#   Value:
#      sf grid layer
#
#   Details:
#      If layer has a different CRS that epgs it is reproyected to epsg
#      if gt = "CPT", a polygonal grid is build first, then converted to point (centroids)
#
GridMaker <- function(layer = NULL, res = 100000L, epsg = 3035, tol = 0L, gt = c("SURF", "CPT"), tilesize = NULL,
                      progress = FALSE, parallel = FALSE, ...){
  if(progress) cat("Read parameters...\n")
  gt <- match.arg(gt)

  if(is.null(layer))
    layer <- full_extend(epsg = epsg)

  stopifnot("sf" %in% class(layer))
  layer <- sf::st_union(layer)

  #   Only proyected CRS are allowed
  stopifnot(!sf::st_is_longlat(sf::st_crs(paste0("EPSG:", epsg))))

  #   Minimum resolution = 1
  stopifnot(res >= 1)

  #   tilessize > 1 or NULL
  stopifnot(is.null(tilesize) | tilesize > 1)

  #   If CRS of layer != epgs it is reproyected to epgs
  if (sf::st_crs(layer) != sf::st_crs(paste0("EPSG:", epsg)))
    layer <- sf::st_transform(layer, sf::st_crs(paste0("EPSG:", epsg)))

  if (tol != 0)
    layer <- sf::st_buffer(layer, dist = tol, ...)

  #   Building the grid
  if(progress) cat("Build grid...\n")
  if (is.null(tilesize)){
    grid <- CellMaker(layer, res)
    grid <- grid[layer, ]
  } else {
    if(progress) cat("Make tiles...\n")
    tiles <- TileMaker(layer, res, tilesize)
    if (parallel){
      if(progress) cat("Runing parallel with", future::nbrOfWorkers(), "cores...\n")
      grid <- furrr::future_map2(tiles$tiles, tiles$layer_tiles, \(x, y) CellMaker(x, res)[y, ], .progress = progress, .options = furrr::furrr_options(seed = TRUE)) |>
        dplyr::bind_rows() |>
        sf::st_set_crs(sf::st_crs(layer))
    } else {
      grid <- CellMaker(tiles$tiles[1], res)
      grid <- grid[tiles$layer_tiles[1], ]
      n <- length(tiles$tiles)
      for (i in 2:n) {
        if(progress) cat("Tile", i, "of", n, "\r")
        g <- CellMaker(tiles$tiles[i], res)
        g <- g[tiles$layer_tiles[i], ]
        grid <- dplyr::bind_rows(grid, g)
      }
    }
  }
  #   Converting to point grid if gt = "CPT"
  if(gt == "CPT")
    grid <- sf::st_centroid(grid)
  #   Computing the fields
  fields <- grid_fields(grid, epsg, res, gt)

  dplyr::bind_cols(fields, grid) |> sf::st_sf() |> dplyr::arrange(GRD_ID)
}
