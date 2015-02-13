#' Map interactive contour lines
#' 
#' @param x a SpatialGridDataFrame
#' 
#' @export
contour <- function(x, nlevels =12, ...){
  bbm <- basemap("stamen.toner.lite")
  win <- apply(bbox(x), 1, mean)
  cont <- extractContour(x, nlevels = nlevels)
  cont.map <- spLayer(cont, stroke.lwd = 2, stroke.col = 1, popup = cont$level)
  writeMap(bbm, cont.map, setView = c(win[2], win[1]), ...)
  }
}