#' North symbol 2
#' @description Alternative implementation to add a north symbol to maps created with ggplot or map.
#' @param ggp ggplot2 object.
#' @param x number between 0 and 1 to indicate the x axis position of the symbol's bottom left corner. 0 is the left side and 1 the right side.
#' @param y number between 0 and 1 to indicate the y axis position of the symbol's bottom left corner. 0 is the bottom and 1 the top.
#' @param scale number between 0 and 1 to indicate the symbol size as a proportion of the plot area (not the map size).
#' @param symbol number between 1 and 18 to choose a symbol (see \code{\link{northSymbols}}).
#' @details
#' North symbols are included in the plot with the \code{\link{annotation_custom}} function, which do not works when used together with an empty call to ggplot (see last example). When it is convenient to use an empty call to ggplot, use \code{\link{north2}} instead.
#' @export
#' @examples
#' \dontrun{
#' library(sf)
#' data(domestic_violence)
#' map <- ggplot(domestic_violence, aes(fill = Scaled)) +
#'     geom_sf() +
#'     scale_fill_continuous(low = "#fff7ec", high = "#7F0000") +
#'     blank()
#' north2(map, .5, .5, symbol = 10)
#' }
north2 <- function(ggp, x = 0.65, y = 0.9, scale = 0.1, symbol = 1) {
    symbol <- sprintf("%02.f", symbol)
    symbol <- png::readPNG(paste0(system.file('symbols', package = 'ggsn'),
                             '/', symbol, '.png'))
    symbol <- grid::rasterGrob(symbol, interpolate = TRUE)
    ins <- qplot(0:1, 0:1, geom = "blank") + blank() +
        ggmap::inset(symbol, xmin = 0, xmax = 1, ymin = 0, ymax = 1)
    vp <- grid::viewport(x, y, scale, scale)
    print(ggp)
    print(ins, vp = vp)
}
