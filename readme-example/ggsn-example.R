library(ggsn); library(ggmap); library(rgdal); library(rgeos)
shape.directory <- system.file('extdata', package = 'ggsn')

# Map in geographic coordinates
map <- readOGR(shape.directory, 'sp')
map@data$id <- 1:nrow(map@data)
map.ff <- fortify(map, region = 'id')
map.df <- merge(map.ff, map@data, by = 'id')

# Map in projected coordinates
map2 <- spTransform(map, CRS("+init=epsg:31983"))
map2@data$id <- 1:nrow(map2@data)
map2.ff <- fortify(map2, region = 'id')
map2.df <- merge(map2.ff, map2@data, by = 'id')

tiff('north-symbols.tiff', width = 6.83, height = 6.83,
     units = 'in', compression = 'lzw', res = 600)
northSymbols()
dev.off()

tiff('map1.tiff', width = 6.83, height = 6.83,
     units = 'in', compression = 'lzw', res = 600)
(ggm1 <- ggplot(data = map.df, aes(long, lat, group = group, fill = nots)) +
    geom_polygon() +
    coord_equal() +
    geom_path() +
    scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8))
dev.off()

tiff('map2.tiff', width = 6.83, height = 6.83,
     units = 'in', compression = 'lzw', res = 600)
ggm1 +
    blank() +
    north(map.df) +
    scalebar(map.df, dist = 5, dd2km = TRUE, model = 'WGS84', st.size = 4)
dev.off()

tiff('map3.tiff', width = 6.83, height = 6.83,
     units = 'in', compression = 'lzw', res = 600)
ggplot(data = map2.df, aes(long, lat, group = group, fill = nots)) +
    geom_polygon() +
    coord_equal() +
    geom_path() +
    north(map2.df, symbol = 16, scale = 0.15) +
    scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8) +
    scalebar(map2.df, dist = 5, st.size = 4) +
    xlab('Meters') +
    ylab('Meters')
dev.off()

sp <- get_map(bbox(map) * matrix(rep(c(1.001, 0.999), e = 2), ncol = 2),
              source = 'osm')

tiff('map4.tiff', width = 6.83, height = 6.83,
     units = 'in', compression = 'lzw', res = 600)
ggmap(sp, extent = 'device') +
    geom_polygon(data = map.df, aes(long, lat, group = group, fill = nots),
                 alpha = .7) +
    coord_equal()+
    geom_path(data = map.df, aes(long, lat, group = group)) +
    scalebar(map.df, dist = 5, dd2km = T, model = 'WGS84', st.size = 4) +
    north(map.df) +
    scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8) +
    theme(legend.position = c(0.9, 0.35))
dev.off()