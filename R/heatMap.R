#' Map interactive contour lines
#' 
#' @param x a SpatialGridDataFrame
#' 
#' @export
heatMap <- function(x, bm = "stamen.toner.lite",
                    show.contour = TRUE, show.gradient = TRUE,
                    nlevels = 12, ...){
  bm <- basemap(bm)
  win <- apply(bbox(x), 1, mean)
  cont <- contour2sp(x, nlevels = nlevels)
  cont.map <- spLayer(cont, stroke.lwd = 2, stroke.col = 1, popup = cont$level)
  heat.map <- spLayer(x, layer = 1, cells.alpha = seq(0.1, 0.8, length.out = 12))
  writeMap(bm, heat.map, cont.map, setView = c(win[2], win[1]), ...)
}