#' Add a scale bar to a ggplot object, with automated detection of axis limits
#' @description This function uses the ggplot object as an argument, enabling automated detection of the axis limits, and making it pipeable.
#' @param p ggplot object
#' @param ... arguments passed to \code{\link{scalebar}}
#' @return ggplot object with the scalebar
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
#'    add_scalebar(dist = 5, dd2km = TRUE, model = 'WGS84')
add_scalebar <- function(p, ...) {
    build <- ggplot_build(p)
    dat <- data.frame(long = build$panel$x_scales[[1]]$range$range,
                      lat = build$panel$y_scales[[1]]$range$range)
    return(p + scalebar(data = dat, ...))
}