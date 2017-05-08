#' Add a north symbol to a ggplot object, with automated detection of axis limits
#' @description This function uses the ggplot object as an argument, enabling automated detection of the axis limits, and making it pipeable.
#' @param p ggplot object
#' @param x Argument passed to north2: Number between 0 and 1 to indicate the x axis position of the symbol's bottom left corner. 0 is the left side and 1 the right side. Defaults to \code{NULL}, which means \code{\link{north}} will be used.
#' @param y Argument passed to north2: Number between 0 and 1 to indicate the y axis position of the symbol's bottom left corner. 0 is the bottom and 1 the top. Defaults to \code{NULL}, which means \code{\link{north}} will be used.
#' @param ... arguments passed to \code{\link{north}} or \code{\link{north2}}
#' @return ggplot object with the north symbol
#' @export
#' @examples
#' library(rgdal); library(broom); library(ggplot2); library(magrittr)
#' dsn <- system.file('extdata', package = 'ggsn')
#' 
#' ## Map in geographic coordinates.
#' map <- readOGR(dsn, 'sp')
#' map@@data$id <- 1:nrow(map@@data)
#' map.df <- merge(tidy(map), map, by = 'id')
#'  
#' {ggplot(data = map.df, aes(long, lat, group = group, fill = nots)) +
#'    geom_polygon() +
#'    coord_equal() +
#'    geom_path() +
#'    scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8)} %>% 
#'    add_north()
#' {ggplot(data = map.df, aes(long, lat, group = group, fill = nots)) +
#'     geom_polygon() +
#'     coord_equal() +
#'     geom_path() +
#'     scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8)} %>% 
#'     add_north(x = 0.6, y = 0.3, scale = 0.2)
add_north <- function(p, x = NULL, y = NULL, ...) {
    if(is.null(x) & is.null(y)) {
        build <- ggplot_build(p)
        dat <- data.frame(long = build$panel$x_scales[[1]]$range$range,
                          lat = build$panel$y_scales[[1]]$range$range)
        return(p + north(data = dat, ...))
    } else {
        return(north2(ggp = p, x = x, y = y, ...))
    }
}