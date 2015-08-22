library(rgdal); library(ggmap)
dsn <- system.file('extdata', package = 'ggsn')
map <- readOGR(dsn, 'sp')
map@data$id <- 1:nrow(map@data)
map.ff <- fortify(map, region = 'id')
map.df <- merge(map.ff, map@data, by = 'id')

sp <- get_map(bbox(map) * matrix(rep(c(1.001, 0.999), e = 2), ncol = 2),
              source = 'osm')
sp2 <- get_map('são paulo state',
               source = 'google')

ggmap(sp, extent = 'device') +
    geom_polygon(data = map.df, aes(long, lat, group = group, fill = nots),
                 alpha = .7) +
    coord_equal()+
    geom_path(data = map.df, aes(long, lat, group = group)) +
    scalebar(map.df, dist = 5, dd2km = T, model = 'WGS84') +
    north(map.df) +
    scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8) +
    theme(legend.position = c(0.9, 0.35))

ggmap(sp2, extent = 'device') +
    geom_polygon(data = map.df, aes(long, lat, group = group, fill = nots),
                 alpha = .7) +
    coord_equal()+
    geom_path(data = map.df, aes(long, lat, group = group)) +
    scalebar(map.df, dist = 5, dd2km = T, model = 'WGS84') +
    north(map.df) +
    scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8) +
    theme(legend.position = c(0.9, 0.35))

ggmap(sp, extent = 'device') +
    geom_polygon(data = map.df, aes(long, lat, group = group, fill = nots),
                 colour = 'black', alpha = .5) +
    coord_equal()+
    scalebar(x.min = bbox(map)[1, 1], x.max = bbox(map)[1, 2],
             y.min = bbox(map)[2, 1], y.max = bbox(map)[2, 2],
             dist = 5, dd2km = T, model = 'WGS84') +
    north(x.min = bbox(map)[1, 1], x.max = bbox(map)[1, 2],
          y.min = bbox(map)[2, 1], y.max = bbox(map)[2, 2])


ggmap(sp) +
    geom_polygon(data = map.df, aes(long, lat, group = group, fill = nots),
                 alpha = .7) +
    coord_equal()

sp <- get_map(matrix(c(-46.652, -23.551, -46.645, -23.545), ncol = 2),
              source = 'osm')
ggmap(sp)