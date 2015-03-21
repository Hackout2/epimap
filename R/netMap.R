

#' Interactive network on a map
#' 
#' This is a wrapping function to create interactive
#' network on a map from an \code{igraph} object.
#' 
#' @param x an \code{igraph} object with at least two vertices attributes \code{"lon"} and \code{"lat"}
#' giving the longitude and the latitude of each vertex respectively.
#' @param bm a character string giving the base map tiles server adress.
#' Use \code{\link[rleafmap]{bmSource}} to get a list of preconfigured servers.
#' 
#' @export
netMap <- function(x, bm = "cartodb.darkmatter.nolab", ...){
  bm <- basemap(bm)
  net.sp <- graph2sp(x, edges = "gc")
  
  win <- apply(bbox(net.sp[[1]]), 1, mean)
  
  net.map.pt <- spLayer(net.sp[[1]], popup = net.sp[[1]]$name, fill.alpha = 1)
  net.map.pt2 <- spLayer(net.sp[[1]], popup = net.sp[[1]]$name, fill.alpha = 0.2,
                         size = 18, stroke = FALSE)
  net.map.li <- spLayer(net.sp[[2]], stroke.lwd=1, stroke.col = "white")
  
  writeMap(bm, net.map.pt, net.map.pt2, net.map.li, setView = c(win[2], win[1]), ...)
}







