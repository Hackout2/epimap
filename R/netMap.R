

#' Interactive network on a map
#' 
#' This is a wrapping function to create interactive
#' network on a map from an \code{igraph} object.
#' 
#' @param x an \code{igraph} object with at least two vertices attributes \code{"lon"} and \code{"lat"}
#' giving the longitude and the latitude of each vertex respectively.
#' @param v.size a numeric vector indicating vertices size.
#' @param v.col a vector of R colors to use for the vertices.
#' @param bm a character string giving the base map tiles server adress.
#' Use \code{\link[rleafmap]{bmSource}} to get a list of preconfigured servers.
#' @param ... additional arguments which can be passed to \code{\link[rleafmap]{writeMap}}.
#' 
#' @examples
#' \dontrun{
#' require(igraph)
#' pump.adj <- as.matrix(dist(coordinates(cholera$pumps)))
#' pump.graph <- graph.adjacency(pump.adj < 0.003, diag = FALSE)
#' V(pump.graph)$lat <- coordinates(cholera$pumps)[, 2]
#' V(pump.graph)$lon <- coordinates(cholera$pumps)[, 1]
#' netMap(pump.graph, v.size = 5, width = 500, height = 300)
#' }
#' 
#' @export
netMap <- function(x, v.size = 5, v.col = 2, bm = "cartodb.darkmatter.nolab", ...){
  bm <- basemap(bm)
  net.sp <- graph2sp(x, edges = "gc")
  
  if(length(v.size) == 1 & is.character(v.size) & v.size %in% names(vertex.attributes(x))){
    v.size <- vertex.attributes(x)[[v.size]]
  }
  if(length(v.col) == 1 & is.character(v.col) & v.col %in% names(vertex.attributes(x))){
    v.col <- vertex.attributes(x)[[v.col]]
  }
  
  net.map.pt <- spLayer(net.sp[[1]], popup = net.sp[[1]]$name,
                        fill.col = v.col, fill.alpha = 1,
                        size = v.size)
  net.map.pt2 <- spLayer(net.sp[[1]], popup = net.sp[[1]]$name,
                         fill.col = v.col, fill.alpha = 0.2,
                         size = v.size * 3, stroke = FALSE)
  net.map.li <- spLayer(net.sp[[2]], stroke.lwd = 1, stroke.col = "white")
  
  writeMap(bm, net.map.pt, net.map.pt2, net.map.li, ...)
}







