#' North symbol
#' @description Adds a north symbol to maps created with ggplot or ggmap.
#' @param data the same \code{\link{data.frame}} passed to \code{\link{ggplot}} to plot the map.
#' @param location string indicating the symbol's location in the plot. Possible options: "topright" (default), "bottomright", "bottomleft" and "topleft".
#' @param scale number between 0 and 1 to indicate the symbol size as a proportion of the map size (bounding box).
#' @param symbol number between 1 and 18 to choose a symbol (see \code{\link{northSymbols}}).
#' @param anchor named \code{\link{vector}} with coordinates to control the symbol position. For \code{location = "topright"}, \code{anchor} defines the coordinates of the symbol's topright corner and so forth. The x coordinate must be named as x and the y coordinate as y.
#' @param x.min if \code{data} is not defined, number with the minimum x coordinate. Useful for ggmap.
#' @param x.max if \code{data} is not defined, number with the maximum x coordinate. Useful for ggmap.
#' @param y.min if \code{data} is not defined, number with the minimum y coordinate. Useful for ggmap.
#' @param y.max if \code{data} is not defined, number with the maximum y coordinate. Useful for ggmap.
#' @details
#' North symbols are included in the plot with the \code{\link{annotation_custom}} function, which do not works when used together with an empty call to ggplot (see last example). When it is convenient to use an empty call to ggplot, use \code{\link{north2}} instead.
#' @export
#' @examples
#' library(rgdal); library(rgeos)
#' dsn <- system.file('extdata', package = 'ggsn')
#' map <- readOGR(dsn, 'sp')
#' map@@data$id <- 1:nrow(map@@data)
#' map.ff <- fortify(map, region = 'id')
#' map.df <- merge(map.ff, map@@data, by = 'id')
#' 
#' ggplot(map.df, aes(long, lat, group = group, fill = nots)) +
#'     geom_polygon() +
#'     coord_equal() +
#'     geom_path() +
#'     north(map.df) +
#'     scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8)
#' 
#' ggplot(data = map.df, aes(long, lat, group = group, fill = nots)) +
#'     geom_polygon() +
#'     coord_equal() +
#'     geom_path() +
#'     north(map.df, location = 'bottomleft', symbol = 8) +
#'     scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8)
#' 
#' ggplot(map.df, aes(long, lat, group = group, fill = nots)) +
#'     geom_polygon() +
#'     coord_equal() +
#'     geom_path() +
#'     north(data = map.df, location = 'bottomright', scale = 0.2, symbol = 14,
#'           anchor = c(x = -46.4, y = -23.9)) +
#'     scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8)
#'
#' \dontrun{
#' ggplot() +
#'    geom_polygon(data = map.df, aes(long, lat, group = group, fill = nots)) +
#'    coord_equal() +
#'    geom_path() +
#'    north(map.df)
#' }
north <- function(data = NULL, location = 'topright', scale = 0.1, symbol = 1, x.min, x.max, y.min, y.max, anchor = NULL) {
    if (is.null(data)) {
        if (is.null(x.min) | is.null(x.max) |
            is.null(y.min) | is.null(y.max) ) {
            stop('If data is not defined, x.min, x.max, y.min and y.max must be.')
        }
        data <- data.frame(long = c(x.min, x.max), lat = c(y.min, y.max))
    }
    scale.x <- (max(data$long) - min(data$long)) * scale
    scale.y <- (max(data$lat) - min(data$lat)) * scale
    if (location == 'bottomleft') {
        if (is.null(anchor)) {
            x.min <- min(data$long)
            y.min <- min(data$lat)
        } else {
            x.min <- anchor['x']
            y.min <- anchor['y']
        }
        x.max <- x.min + scale.x
        y.max <- y.min + scale.y
    }
    if (location == 'bottomright') {
        if (is.null(anchor)) {
            x.max <- max(data$long)
            y.min <- min(data$lat)
        } else {
            x.max <- anchor['x']
            y.min <- anchor['y']
        }
        x.min <- x.max - scale.x
        y.max <- y.min + scale.y
    }
    if (location == 'topleft') {
        if (is.null(anchor)) {
            x.min <- min(data$long)
            y.max <- max(data$lat)
        } else {
            x.min <- anchor['x']
            y.max <- anchor['y']
        }
        x.max <- x.min + scale.x
        y.min <- y.max - scale.y
    }
    if (location == 'topright') {
        if (is.null(anchor)) {
            x.max <- max(data$long)
            y.max <- max(data$lat)
        } else {
            x.min <- anchor['x']
            y.max <- anchor['y']
        }
        x.min <- x.max - scale.x
        y.min <- y.max - scale.y
    }
    symbol <- sprintf("%02.f", symbol)
    symbol <- readPNG(paste0(system.file('symbols', package = 'ggsn'),
                            '/', symbol, '.png'))
    symbol <- rasterGrob(symbol, interpolate = TRUE)
    return(annotation_custom(symbol,
                      xmin = x.min, xmax = x.max,
                      ymin = y.min, ymax = y.max))
}
