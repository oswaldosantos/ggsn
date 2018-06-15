#' Scale bar
#' @description Adds a scale bar to maps created with ggplot or ggmap.
#' @param data the same \code{\link{data.frame}} passed to \code{\link{ggplot}} to plot the map.
#' @param location string indicating the symbol's location in the plot. Possible options: "topright" (default), "bottomright", "bottomleft" and "topleft".
#' @param dist distance in km to represent with each segment of the scale bar.
#' @param dd2km logical. If TRUE, it is assumed that coordinates are in decimal degrees. If FALSE, it assumed they are in meters.
#' @param model choice of ellipsoid model ("WGS84", "GRS80", "Airy", "International", "Clarke", "GRS67") Used when dd2km is TRUE.
#' @param dist_unit when \code{dist} is used, it defines the unit of measurement.  Possbile values: "km" and "m".
#' @param height number between 0 and 1 to indicate the height of the scale bar, as a proportion of the y axis.
#' @param st.dist number between 0 and 1 to indicate the distance between the scale bar and the scale bar text, as a proportion of the y axis.
#' @param st.bottom logical. If TRUE (default) the scale bar text is displayed at the bottom of the scale bar, if FALSE, it is displayed at the top.
#' @param st.size number to indicate the scale bar text size. It is passed to the size argument of \code{\link{annotate}} function.
#' @param st.color scale bar text color. Default is black.
#' @param box.fill box fill color. If vector of two colors, the two boxes are filled with a different color. Defaults to black and white.
#' @param box.color box border color. If vector of two colors, the borders of the two boxes are colored differently. Defaults to black.
#' @param border.size number to define the border width.
#' @param anchor named \code{\link{vector}} with coordinates to control the symbol position. For \code{location = "topright"}, \code{anchor} defines the coordinates of the symbol's topright corner and so forth. The x coordinate must be named as x and the y coordinate as y.
#' @param x.min if \code{data} is not defined, number with the minimum x coordinate. Useful for ggmap.
#' @param x.max if \code{data} is not defined, number with the maximum x coordinate. Useful for ggmap.
#' @param y.min if \code{data} is not defined, number with the minimum y coordinate. Useful for ggmap.
#' @param y.max if \code{data} is not defined, number with the maximum y coordinate. Useful for ggmap.
#' @param facet.var if faceting, character vector of variable names used for faceting. This is useful for placing the scalebar only in one facet and must be used together with \code{facet.lev}.
#' @param facet.lev character vector with the name of one level for each variable in \code{facet.var}. The scale bar will be drawn only in the \code{facet.lev} facet.
#' @param ... further arguments passed to \code{\link{geom_text}}.
#' @export
#' @examples
#' library(sf)
#' dsn <- system.file('extdata', package = 'ggsn')
#' map <- st_read(dsn, 'sp')
#' 
#' # If "map" is a "sp" object, convert it to "sf" with map <- st_as_sf(map).
#'
#' # Map in geographic coordinates
#' ggplot(map, aes(fill = nots)) +
#'     geom_sf() +
#'     scalebar(map, , dist = 5, dd2km = TRUE, model = 'WGS84') +
#'     scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8)
#'
#' # Map in projected coordinates
#' map2 <- st_transform(map, 31983)
#' ggplot(map2, aes(fill = nots)) +
#'     geom_sf() +
#'     scalebar(map2, dd2km = FALSE, dist = 5, model = 'WGS84') +
#'     scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8)
#'     
scalebar <- function(data = NULL, location = "bottomright", dist = NULL, dd2km = NULL, model = NULL, height = 0.02, st.dist = 0.02, dist_unit = "km", st.bottom = TRUE, st.size = 5, st.color = "black", box.fill = c("black", "white"), box.color = "black", border.size = 1, x.min = NULL, x.max = NULL, y.min = NULL, y.max = NULL, anchor = NULL, facet.var = NULL, facet.lev = NULL, ...){
    if (is.null(data)) {
        if (is.null(x.min) | is.null(x.max) |
            is.null(y.min) | is.null(y.max) ) {
            stop('If data is not defined, x.min, x.max, y.min and y.max must be.')
        }
        data <- data.frame(long = c(x.min, x.max), lat = c(y.min, y.max))
    }
    if (is.null(dd2km)) {
        stop("dd2km should be logical.")
    }
    if (any(class(data) %in% "sf")) {
        xmin <- sf::st_bbox(data)["xmin"]
        xmax <- sf::st_bbox(data)["xmax"]
        ymin <- sf::st_bbox(data)["ymin"]
        ymax <- sf::st_bbox(data)["ymax"]
    } else {
        xmin <- min(data$long)
        xmax <- max(data$long)
        ymin <- min(data$lat)
        ymax <- max(data$lat)
    }
    if (location == 'bottomleft') {
        if (is.null(anchor)) {
            x <- xmin
            y <- ymin
        } else {
            x <- as.numeric(anchor['x'])
            y <- as.numeric(anchor['y'])
        }
        direction <- 1
        
    }
    if (location == 'bottomright') {
        if (is.null(anchor)) {
            x <- xmax
            y <- ymin
        } else {
            x <- as.numeric(anchor['x'])
            y <- as.numeric(anchor['y'])
        }
        direction <- -1
        
    }
    if (location == 'topleft') {
        if (is.null(anchor)) {
            x <- xmin
            y <- ymax
        } else {
            x <- as.numeric(anchor['x'])
            y <- as.numeric(anchor['y'])
        }
        direction <- 1
        
    }
    if (location == 'topright') {
        if (is.null(anchor)) {
            x <- xmax
            y <- ymax
        } else {
            x <- as.numeric(anchor['x'])
            y <- as.numeric(anchor['y'])
        }
        direction <- -1
        
    }
    if (!st.bottom) {
        st.dist <-
            y + (ymax - ymin) * (height + st.dist)
    } else {
        st.dist <- y - (ymax - ymin) * st.dist
    }
    height <- y + (ymax - ymin) * height
    
    if (dd2km) {
        if (dist_unit == "m") {
            dist <- dist / 1e3
        }
        break1 <- maptools::gcDestination(lon = x, lat = y,
                                          bearing = 90 * direction,
                                          dist = dist, dist.units = 'km',
                                          model = model)[1, 1]
        break2 <- maptools::gcDestination(lon = x, lat = y,
                                          bearing = 90 * direction,
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
                       y = c(y, height, height, y, y), group = 1)
    box2 <- data.frame(x = c(rep(break1, 2), rep(break2, 2), break1),
                       y=c(y, rep(height, 2), y, y), group = 1)
    if (!is.null(facet.var) & !is.null(facet.lev)) {
        for (i in 1:length(facet.var)){
            if (any(class(data) == "sf")) {
                if (!is.factor(data[ , facet.var[i]][[1]])) {
                    data[ , facet.var[i]] <- factor(data[ , facet.var[i]][[1]])
                }
                box1[ , facet.var[i]] <- factor(facet.lev[i],
                                                levels(data[ , facet.var[i]][[1]]))
                box2[ , facet.var[i]] <- factor(facet.lev[i],
                                                levels(data[ , facet.var[i]][[1]]))
            } else {
                if (!is.factor(data[ , facet.var[i]])) {
                    data[ , facet.var[i]] <- factor(data[ , facet.var[i]])
                }
                box1[ , facet.var[i]] <- factor(facet.lev[i],
                                                levels(data[ , facet.var[i]]))
                box2[ , facet.var[i]] <- factor(facet.lev[i],
                                                levels(data[ , facet.var[i]]))
            }
            
        }
    }
    if (dist_unit == "km") {
        legend <- cbind(text = c(0, dist, dist * 2), row.names = NULL)
    }
    if (dist_unit == "m") {
        legend <- cbind(text = c(0, dist * 1e3, dist * 2e3), row.names = NULL)
    }
    
    gg.box1 <- geom_polygon(data = box1, aes(x, y),
                            fill = utils::tail(box.fill, 1),
                            color = utils::tail(box.color, 1),
                            size = border.size)
    gg.box2 <- geom_polygon(data = box2, aes(x, y), fill = box.fill[1],
                            color = box.color[1],
                            size = border.size)
    x.st.pos <- c(box1[c(1, 3), 1], box2[3, 1])
    if (location == 'bottomright' | location == 'topright') {
        x.st.pos <- rev(x.st.pos)
    }
    if (dist_unit == "km") {
        legend2 <- cbind(data[1:3, ], x = unname(x.st.pos), y = unname(st.dist),
                         label = paste0(legend[, "text"], c("", "", "km")))
    }
    if (dist_unit == "m") {
        legend2 <- cbind(data[1:3, ], x = unname(x.st.pos), y = unname(st.dist),
                         label = paste0(legend[, "text"], c("", "", "m")))
    }
    if (!is.null(facet.var) & !is.null(facet.lev)) {
        for (i in 1:length(facet.var)){
            if (any(class(data) == "sf")) {
                legend2[ , facet.var[i]] <- factor(facet.lev[i],
                                                   levels(data[ , facet.var[i]][[1]]))
            } else {
                legend2[ , facet.var[i]] <- factor(facet.lev[i],
                                                   levels(data[ , facet.var[i]]))
            }
        }
    } else if (!is.null(facet.var) & is.null(facet.lev)) {
        facet.levels0 <- unique(as.data.frame(data)[, facet.var])
        facet.levels <- unlist(unique(as.data.frame(data)[, facet.var]))
        legend2 <- do.call("rbind", replicate(length(facet.levels),
                                              legend2, simplify = FALSE))
        if (length(facet.var) > 1) {
            facet.levels0 <- expand.grid(facet.levels0)
            legend2[, facet.var] <-
                facet.levels0[rep(row.names(facet.levels0), each = 3), ]
        } else {
            legend2[, facet.var] <- rep(facet.levels0, each = 3)
        }
    }
    gg.legend <- geom_text(data = legend2, aes(x, y, label = label),
                           size = st.size, color = st.color, ...)
    return(list(gg.box1, gg.box2, gg.legend))
}
