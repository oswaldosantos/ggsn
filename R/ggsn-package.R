#' North symbols and scale bars for maps created with 'ggplot' or 'ggmap'. Adds north symbols (18 options) and scale bars in kilometers to maps in geographic or metric coordinates created with 'ggplot' or 'ggmap'.
#'
#' \tabular{ll}{
#' Package: \tab ggsn\cr
#' Type: \tab Package\cr
#' Version: \tab 0.5.0\cr
#' Date: \tab 2016-11-12\cr
#' Depends: \tab R (>= 3.4), ggplot2\cr
#' Imports: \tab grid, ggmap, sf, png, maptools\cr
#' Suggests: \tab rgdal, broom\cr
#' License: \tab GPL (>= 2)\cr
#' LazyLoad: \tab yes\cr
#' URL: \tab \url{https://github.com/oswaldosantos/ggsn}\cr
#' Author: \tab Oswaldo Santos Baquero \email{baquero@@usp.br}\cr
#' Maintainer: \tab Oswaldo Santos Baquero \email{baquero@@usp.br}\cr
#' }
#'
#' @name ggsn-package
#' @docType package
#' @title The ggsn Package
#' @keywords package
#' @import ggplot2
#' @importFrom sf st_bbox
#' @importFrom maptools gcDestination
#' @importFrom graphics plot rasterImage
#' @importFrom ggmap inset
#' @importFrom png readPNG
#' @importFrom grid viewport pushViewport grid.newpage grid.layout rasterGrob
NULL
