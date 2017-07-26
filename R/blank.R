#' Blank theme
#' @description ggplot blank theme.
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
#'     blank() +
#'     scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8)
#'     
blank <- function() {
    return(
        theme(panel.grid.major = element_line(colour = 'transparent'),
              panel.grid.minor = element_line(colour = 'transparent'),
              panel.background = element_rect(fill = 'transparent', colour = NA),
              plot.background = element_rect(fill = "transparent",colour = NA),
              axis.text.x = element_blank(),
              axis.text.y = element_blank(),
              axis.ticks.x = element_blank(),
              axis.ticks.y = element_blank(),
              axis.title = element_blank(),
              plot.margin = unit(rep(0, 4), "lines"))
    )
}
