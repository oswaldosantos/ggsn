# ggsn
The ggsn package improves the GIS capabilities of R, making possible to add 18 different north symbols and scale bars in kilometers to maps in geographic or metric coordinates created with "ggplot" or "ggmap".  

To install the production version use: `r install.packages('ggsn')̀`
To install the production version use: `r install_github('oswaldosantos/ggsn')̀` (make surethat devtools is loaded).

## Example

Read a shapefile and preprae it to plot  
```{r}
library(ggsn); library(ggmap); library(rgdal); library(broom)
shape.directory <- system.file('extdata', package = 'ggsn')

# Map in geographic coordinates
map <- readOGR(shape.directory, 'sp')
map@data$id <- 0:(nrow(map@data) - 1)
map.df <- merge(tidy(map), map, by = 'id')

# Map in projected coordinates
map2 <- spTransform(map, CRS("+init=epsg:31983"))
map2@data$id <- 0:(nrow(map@data) - 1)
map2.df <- merge(tidy(map2), map2, by = 'id')
```  

ggplot map

```{r}
(ggm1 <- ggplot(data = map.df, aes(long, lat, group = group, fill = nots)) +
    geom_polygon() +
    coord_equal() +
    geom_path() +
    scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8))
```  

![](https://cloud.githubusercontent.com/assets/3876657/9424410/dbc23144-48c1-11e5-888d-041d28b920ae.jpg)  

Now, let's use the ggsn package to add a blank background, a north symbol and a scaale bar with segments of 5km.  

```{r}
ggm1 +
    blank() +
    north(map.df) +
    scalebar(map.df, dist = 5, dd2km = TRUE, model = 'WGS84')
```  

![](https://cloud.githubusercontent.com/assets/3876657/9424404/bc5e88ca-48c1-11e5-9f43-ef62225545a8.jpg)  

The scale bar works with maps in geographic and meter coordinates.  

```{r}
ggm1 +
    north(map.df) +
    scalebar(map.df, dist = 5, dd2km = TRUE, model = 'WGS84')
```  

![](https://cloud.githubusercontent.com/assets/3876657/9424480/7afac044-48c4-11e5-9403-b8a440d348b4.jpg)  

```{r}
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
![](https://cloud.githubusercontent.com/assets/3876657/9424407/c22f248a-48c1-11e5-9b65-b63d4691b334.jpg)  

The packages ggsn and ggmap can be used together.
```{r}
sp <- get_map(bbox(map) * matrix(rep(c(1.001, 0.999), e = 2), ncol = 2),
              source = 'osm')

ggmap(sp, extent = 'device') +
    geom_polygon(data = map.df, aes(long, lat, group = group, fill = nots),
                 alpha = .7) +
    coord_equal()+
    geom_path(data = map.df, aes(long, lat, group = group)) +
    scalebar(map.df, dist = 5, dd2km = T, model = 'WGS84') +
    north(map.df) +
    scale_fill_brewer(name = 'Animal abuse\nnotifications', palette = 8) +
    theme(legend.position = c(0.9, 0.35))
```  
![](https://cloud.githubusercontent.com/assets/3876657/9424481/82dd8576-48c4-11e5-957b-5bf2ccb689c8.jpg)  

We have used default behaviors but we can change the position and size of the north symbol and the scale bar. For the scale bar, its hegiht, text size and text position can be controlled to. To see the available north symbols, use:  

```{r}
symbols()
```  
![](https://cloud.githubusercontent.com/assets/3876657/9424484/888714d8-48c4-11e5-8587-789eb71690c5.jpg)
