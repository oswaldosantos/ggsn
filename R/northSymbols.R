#' Available north symbols.
#' @description Displays avaliable north symbols.
#' @note The symbols were obtained from QGIS 2.8.1 - Wien.
#' @references http://www.qgis.org/en/site
#' @export
#' @examples 
#' northSymbols()
northSymbols <- function() {
    img <- readPNG(paste0(system.file('symbols', package = 'ggsn'),
                          '/', 'symbols.png'))
    plot(0, type='n', xlim=0:1, ylim=0:1, axes = F, xlab = '', ylab = '')
    rasterImage(img, 0, 0, 1, 1)
}


