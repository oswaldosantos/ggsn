#' Blank theme
#' @description ggplot blank theme.
#' @export
#' @examples
#' \dontrun{
#' library(sf)
#' data(domestic_violence)
#' ggplot(domestic_violence, aes(fill = Scaled)) +
#'     geom_sf() +
#'     blank() +
#'     scale_fill_continuous(low = "#fff7ec", high = "#7F0000")
#' }
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
