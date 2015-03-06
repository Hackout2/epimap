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
  
  if(show.contour){
    cont <- contour2sp(x, nlevels = nlevels)
    cont.map <- spLayer(cont, stroke.lwd = 2, stroke.col = 1, popup = cont$level)
  }
  if(show.gradient){
    heat.map <- spLayer(x, layer = 1, cells.alpha = seq(0.1, 0.8, length.out = 12))
  }
  
  if(show.contour & show.gradient){
    writeMap(bm, heat.map, cont.map, setView = c(win[2], win[1]), ...)
  } else {
    if(show.contour){
      writeMap(bm, cont.map, setView = c(win[2], win[1]), ...)
    }
    if(show.gradient){
      writeMap(bm, heat.map, setView = c(win[2], win[1]), ...)
    }
  }
}