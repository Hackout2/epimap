

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
  win <- apply(bbox(x), 1, mean)
  net.sp <- graph2sp(x)
  net.map.pt <- spLayer(net.sp[[1]], popup = net.sp[[1]]$name)
  net.map.li <- spLayer(net.sp[[2]], stroke.lwd=3)
  writeMap(bm, net.map.pt, net.map.li, setView = c(win[2], win[1]), ...)
}







