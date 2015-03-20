#' Interactive heatmaps and contour lines
#' 
#' This is a wrapping function to create interactive
#' heatmaps and contour lines from a SpatialGridDataFrame.
#' 
#' @param x a \code{SpatialGridDataFrame}.
#' @param bm a character string giving the base map tiles server adress.
#' Use \code{\link[rleafmap]{bmSource}} to get a list of preconfigured servers.
#' @param show.contour a logical stating whether contour lines should be displayed.
#' @param show.gradient a logical stating whether the heatmap should be displayed.
#' @param n.levels if \code{show.contour} is \code{TRUE}, number of contour levels.
#' @param ... other argument to be passed to \code{\link[rleafmap]{writeMap}}
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
    ui <- ui(layers = "topright")
    writeMap(bm, cont.map, heat.map, interface = ui, setView = c(win[2], win[1]), ...)
  } else {
    if(show.contour){
      writeMap(bm, cont.map, setView = c(win[2], win[1]), ...)
    }
    if(show.gradient){
      writeMap(bm, heat.map, setView = c(win[2], win[1]), ...)
    }
  }
}