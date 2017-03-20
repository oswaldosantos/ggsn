#' Blank theme
#' @description ggplot blank theme.
#' @export
#' @examples
#' library(rgdal)
#' library(broom)
#' dsn <- system.file('extdata', package = 'ggsn')
#' map <- readOGR(dsn, 'sp')
#' map@@data$id <- 0:(nrow(map@data) - 1)
#' map.df <- merge(tidy(map), map, by = 'id')
#' 
#' ggplot(map.df, aes(long, lat, group = group, fill = nots)) +
#'       geom_polygon() +
#'       coord_equal() +
#'       geom_path() +
#'       north(map.df) +
#'       blank()
#'       
#' ggplot(map.df, aes(long, lat, group = group, fill = nots)) +
#'       geom_polygon() +
#'       coord_equal() +
#'       geom_path() +
#'       north(map.df)

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
