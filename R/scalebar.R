#' North symbol
#' @description Adds a north symbol to maps created with ggplot or ggmap.
#' @param data the same \code{\link{data.frame}} passed to \code{\link{ggplot}} to plot the map.
#' @param location string indicating the symbol's location in the plot. Possible options: "topright" (default), "bottomright", "bottomleft" and "topleft".
#' @param dist distance in km to represent with the scale bar.
#' @param height number between 0 and 1 to indicate the height of the scale bar, as a proportion of the y axis.
#' @param st.dist number between 0 and 1 to indicate the distance between the scale bar and the scale bar text, as a proportion of the y axis.
#' @param st.bottom logical. If TRUE (default) the scale bar text is displayed at the bottom of the scale bar, if FALSE, it is displayed at the top.
#' @param st.size number to indicate the scale bar text size. It is passed to the size argument of \code{\link{annotate}} function.
#' @param dd2km logical. If TRUE \code{dist} it is assumed that map coordinates are in decimal degrees, if FALSE, it assumed they are in meters.
#' @param model choice of ellipsoid model ("WGS84", "GRS80", "Airy", "International", "Clarke", "GRS67") Used when dd2km is TRUE.
#' @param anchor named \code{\link{vector}} with coordinates to control the symbol position. For \code{location = "topright"}, \code{anchor} defines the coordinates of the symbol's topright corner and so forth. The x coordinate must be named as x and the y coordinate as y.
#' @param x.min if \code{data} is not defined, number with the minimum x coordinate. Useful for ggmap.
#' @param x.max if \code{data} is not defined, number with the maximum x coordinate. Useful for ggmap.
#' @param y.min if \code{data} is not defined, number with the minimum y coordinate. Useful for ggmap.
#' @param y.max if \code{data} is not defined, number with the maximum y coordinate. Useful for ggmap.
#' @export
#' @examples
#' library(rgdal); library(rgeos)
#' dsn <- system.file('extdata', package = 'ggsn')
#' 
#' ## Map in geographic coordinates.
#' map <- readOGR(dsn, 'sp')
#' map@@data$id <- 1:nrow(map@@data)
#' map.ff <- fortify(map, region = 'id')
#' map.df <- merge(map.ff, map@@data, by = 'id')
#' 
#' ggplot(data = map.df, aes(long, lat, group = group, fill = nots)) +
#'     geom_polygon() +
#'     coord_equal() +
#'     geom_path() +
#'     scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8) +
#'     scalebar(map.df, dist = 5, dd2km = TRUE, model = 'WGS84')
#'
#' ## Map in meter coordinates.
#' map2 <- spTransform(map, CRS("+init=epsg:31983"))
#' map2@@data$id <- 1:nrow(map2@@data)
#' map2.ff <- fortify(map2, region = 'id')
#' map2.df <- merge(map2.ff, map2@@data, by = 'id')
#' 
#' ggplot(data = map2.df, aes(long, lat, group = group, fill = nots)) +
#'     geom_polygon() +
#'     coord_equal() +
#'     geom_path() +
#'     scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8) +
#'     scalebar(map2.df, dist = 5)
#'
#' ggplot(data = map2.df, aes(long, lat, group = group, fill = nots)) +
#'     geom_polygon() +
#'     coord_equal() +
#'     geom_path() +
#'     scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8) +
#'     scalebar(map2.df, dist = 7, anchor = c(x = 355000, y = 7360000),
#'              st.bottom = FALSE, st.size = 8)
#' 
#' ggplot(data = map2.df, aes(long, lat, group = group, fill = nots)) +
#'     geom_polygon() +
#'     coord_equal() +
#'     geom_path() +
#'     scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8) +
#'     scalebar(map2.df, location = 'topright', dist = 5)
scalebar <- function(data = NULL, location = "bottomright", dist, height = 0.02, st.dist = 0.02, st.bottom = TRUE, st.size = 5, dd2km = NULL, model, x.min, x.max, y.min, y.max, anchor = NULL){
    if (is.null(data)) {
        if (is.null(x.min) | is.null(x.max) |
            is.null(y.min) | is.null(y.max) ) {
            stop('If data is not defined, x.min, x.max, y.min and y.max must be.')
        }
        data <- data.frame(long = c(x.min, x.max), lat = c(y.min, y.max))
    }
    if (location == 'bottomleft') {
        if (is.null(anchor)) {
        x <- min(data$long)
        y <- min(data$lat)
        } else {
            x <- as.numeric(anchor['x'])
            y <- as.numeric(anchor['y'])
        }
        direction <- 1
        
    }
    if (location == 'bottomright') {
        if (is.null(anchor)) {
        x <- max(data$long)
        y <- min(data$lat)
        } else {
            x <- as.numeric(anchor['x'])
            y <- as.numeric(anchor['y'])
        }
        direction <- -1
        
    }
    if (location == 'topleft') {
        if (is.null(anchor)) {
        x <- min(data$long)
        y <- max(data$lat)
        } else {
            x <- as.numeric(anchor['x'])
            y <- as.numeric(anchor['y'])
        }
        direction <- 1
        
    }
    if (location == 'topright') {
        if (is.null(anchor)) {
        x <- max(data$long)
        y <- max(data$lat)
        } else {
            x <- as.numeric(anchor['x'])
            y <- as.numeric(anchor['y'])
        }
        direction <- -1
        
    }
    if (!st.bottom) {
        st.dist <-
            y + (max(data$lat) - min(data$lat)) * (height + st.dist)
    } else {
        st.dist <- y - (max(data$lat) - min(data$lat)) * st.dist
    }
    height <- y + (max(data$lat) - min(data$lat)) * height
    
    if (!is.null(dd2km)) {
        break1 <- gcDestination(lon = x, lat = y, bearing = 90 * direction,
                                dist = dist, dist.units = 'km',
                                model = model)[1, 1]
        break2 <- gcDestination(lon = x, lat = y, bearing = 90 * direction,
                                dist = dist*2, dist.units = 'km',
                                model = model)[1, 1]
    } else {
        if (location == 'bottomleft' | location == 'topleft') {
            break1 <- x + dist * 1e3
            break2 <- x + dist * 2e3
        } else {
            break1 <- x - dist * 1e3
            break2 <- x - dist * 2e3
        }
        
    }
    box1 <- data.frame(x = c(x, x, rep(break1, 2), x),
                       y = c(y, height, height,y, y), group = 1)
    box2 <- data.frame(x = c(rep(break1, 2), rep(break2, 2), break1),
                       y=c(y, rep(height, 2), y, y), group = 1)
    
    legend <- data.frame(text = c(0, dist, dist * 2))
    
    gg.box1 <- geom_polygon(data = box1, aes(x, y), fill = 'white',
                            color = 'black')
    gg.box2 <- geom_polygon(data = box2, aes(x, y), fill = 'black',
                            color = 'black')
    x.st.pos <- c(box1[c(1, 3), 1], box2[3, 1])
    if (location == 'bottomright' | location == 'topright') {
        x.st.pos <- rev(x.st.pos)
    }
    gg.legend <- annotate('text', label = paste0(legend[,'text'], 'km'),
                          x = x.st.pos, y = st.dist, size = st.size)
    
    return(list(gg.box1, gg.box2, gg.legend))
}