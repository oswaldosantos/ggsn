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

Read a shapefile:

``` r
library(ggsn); library(sf)
dsn <- system.file('extdata', package = 'ggsn')

# Map in geographic coordinates
map <- st_read(dsn, 'sp', quiet = TRUE)

# Map in projected coordinates
map2 <- st_transform(map, 31983)
```

**ggplot** map:

``` r
(ggm1 <- ggplot(map, aes(fill = nots)) +
    geom_sf() +
    scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8))
```

![](figure/unnamed-chunk-3-1.png)

Now, let's use the **ggsn** package to add a blank background, a north symbol and a scale bar with segments of 5km:

``` r
ggm1 +
    blank() +
    north(map) +
    scalebar(map, dist = 5, dd2km = TRUE, model = 'WGS84')
```

![](figure/unnamed-chunk-4-1.png)

The scale bar works with maps in geographic and meter coordinates:

``` r
ggm1 +
    north(map) +
    scalebar(map, dist = 5, dd2km = TRUE, model = 'WGS84')
```

![](figure/unnamed-chunk-5-1.png)

``` r
ggplot(map2, aes(fill = nots)) +
    geom_sf() +
    north(map2, symbol = 16, scale = 0.15) +
    scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8) +
    scalebar(map2, dist = 5) +
    xlab('Meters') +
    ylab('Meters')
```

![](figure/unnamed-chunk-6-1.png)

The packages **ggsn** and **ggmap** can be used together:

``` r
library(ggmap)
library(sp)
library(rgdal)
library(broom)
sp <- get_googlemap("São Paulo")
bb <- c(st_bbox(map) * matrix(rep(c(1.001, 0.999), e = 2), ncol = 2))
nms <- names(attr(sp, "bb"))
attr(sp, "bb")[1, ] <- bb[c(2, 1, 4, 3)]

map_sp <- readOGR(dsn, "sp")
#> OGR data source with driver: ESRI Shapefile 
#> Source: "/home/oswaldo/R/x86_64-pc-linux-gnu-library/3.4/ggsn/extdata", layer: "sp"
#> with 96 features
#> It has 2 fields
map_sp@data$id <- 0:(nrow(map_sp@data) - 1)
map_sp <- merge(tidy(map_sp), map_sp, by = 'id')

ggmap(sp) +
    geom_polygon(data = map_sp, aes(long, lat, group = group, fill = nots),
                 alpha = .7) +
    coord_equal() +
    geom_path(data = map_sp, aes(long, lat, group = group)) +
    blank() +
    scalebar(map_sp, dist = 5, dd2km = T, model = 'WGS84') +
    north(map) +
    scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8) +
    theme(legend.position = c(0.9, 0.35))
```

![](figure/unnamed-chunk-7-1.png)

We have used default behaviors but we can change the position and size of the north symbol and the scale bar. For the scale bar, its height, text size and text position can be controlled too. To see the available north symbols, use:

``` r
northSymbols()
```

![](figure/unnamed-chunk-8-1.png)
