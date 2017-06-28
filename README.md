<!-- README.md is generated from README.Rmd. Please edit that file -->
The **ggsn** package improves the GIS capabilities of R, making possible to add 18 different north symbols and scale bars in kilometers to maps in geographic or metric coordinates created with **ggplot** or **ggmap**.

To install the CRAN version use:

``` r
install.packages('ggsn')
```

To install the development version use (make sure that **devtools** is installed):

``` r
devtools::install_github('oswaldosantos/ggsn')
```

Examples
--------

Read a shapefile and prepare it to plot:

``` r
library(ggsn); library(ggmap); library(rgdal); library(broom)
shape.directory <- system.file('extdata', package = 'ggsn')

# Map in geographic coordinates
map <- readOGR(shape.directory, 'sp', verbose = FALSE)
map@data$id <- 0:(nrow(map@data) - 1)
map.df <- merge(tidy(map), map, by = 'id')

# Map in projected coordinates
map2 <- spTransform(map, CRS("+init=epsg:31983"))
map2@data$id <- 0:(nrow(map@data) - 1)
map2.df <- merge(tidy(map2), map2, by = 'id')
```

**ggplot** map:

``` r
(ggm1 <- ggplot(data = map.df, aes(long, lat, group = group, fill = nots)) +
    geom_polygon() +
    coord_equal() +
    geom_path() +
    scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8))
```

![](figure/unnamed-chunk-3-1.png)

Now, let's use the **ggsn** package to add a blank background, a north symbol and a scale bar with segments of 5km:

``` r
ggm1 +
    blank() +
    north(map.df) +
    scalebar(map.df, dist = 5, dd2km = TRUE, model = 'WGS84')
```

![](figure/unnamed-chunk-4-1.png)

The scale bar works with maps in geographic and meter coordinates:

``` r
ggm1 +
    north(map.df) +
    scalebar(map.df, dist = 5, dd2km = TRUE, model = 'WGS84')
```

![](figure/unnamed-chunk-5-1.png)

``` r
ggplot(data = map2.df, aes(long, lat, group = group, fill = nots)) +
    geom_polygon() +
    coord_equal() +
    geom_path() +
    north(map2.df, symbol = 16, scale = 0.15) +
    scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8) +
    scalebar(map2.df, dist = 5) +
    xlab('Meters') +
    ylab('Meters')
```

![](figure/unnamed-chunk-6-1.png)

The packages **ggsn** and **ggmap** can be used together:

``` r
library(ggmap)
library(sp)
sp <- get_googlemap("São Paulo")
bb <- c(bbox(map) * matrix(rep(c(1.001, 0.999), e = 2), ncol = 2))
nms <- names(attr(sp, "bb"))
attr(sp, "bb")[1, ] <- bb[c(2, 1, 4, 3)]

ggmap(sp) +
    geom_polygon(data = map.df, aes(long, lat, group = group, fill = nots),
                 alpha = .7) +
    coord_equal() +
    geom_path(data = map.df, aes(long, lat, group = group)) +
    blank() +
    scalebar(map.df, dist = 5, dd2km = T, model = 'WGS84') +
    north(map.df) +
    scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8) +
    theme(legend.position = c(0.9, 0.35))
```

![](figure/unnamed-chunk-7-1.png)

We have used default behaviors but we can change the position and size of the north symbol and the scale bar. For the scale bar, its height, text size and text position can be controlled too. To see the available north symbols, use:

``` r
northSymbols()
```

![](figure/unnamed-chunk-8-1.png)
