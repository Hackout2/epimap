
#' Convert a graph into Spatial objects
#' 
#' This function converts a graph (igraph) with geolocated vertices into Spatial objects (points and lines).
#' 
#' @param x an igraph object with at least two vertices attributes \code{"lon"} and \code{"lat"}
#' giving the longitude and the latitude of each vertex respectively.
#' @param edges a character string giving the style to use for edges (lines connecting vertices).
#' Can be one of \code{"lines"} for straight lines, \code{"gc"} for great circles or \code{"arc"} for user defined arcs.
#' @param alpha if \code{edges} is set to \code{"arc"}, a numeric giving the value of the central angle for the arcs.
#' 
#' @return A list of two \code{Spatial} objects. A \code{SpatialPointsDataFrame} for the vertices
#' and a \code{SpatialLinesDataFrame} for the edges.
#' @export
#' 
graph2sp <- function(x, edges = c("lines", "gc", "arc"), alpha = 45){
  if(!is.igraph(x)){
    stop("x must be a graph of class 'igraph'.")
  }
  edges <- match.arg(edges)
  points.dat <- as.data.frame(vertex.attributes(x))
  points.coord <- cbind(points.dat$lon, points.dat$lat)
  SPDF <- SpatialPointsDataFrame(coords = points.coord, data = points.dat)
  
  if(is.directed(x)){
    if(length(edge.attributes(x)) != 0){
      warning("Possible loss of data when converting to undirected graph.") 
    }
    x <- as.undirected(x)
  }
  edg <- get.edgelist(x)
  edg <- lapply(seq_len(nrow(edg)), function(x) edg[x, ])
  id <- seq_len(length(edg))
  
  lin <- lapply(edg, function(i){
    cbind(get.vertex.attribute(x, "lon", i),
          get.vertex.attribute(x, "lat", i))})
  
  if(edges == "gc"){
    lin <- lapply(lin, function(x) geosphere::gcIntermediate(x[1, ], x[2, ]))
  }
  if(edges == "arc"){
    lin <- lapply(lin, function(x) arcAngle(x[1, ], x[2, ], alpha = alpha, n = 100))
  }
  
  lin <- lapply(lin, function(x) Line(x))
  lins <- mapply(function(x, y) Lines(x, ID = y), lin, id)
  SL <- SpatialLines(lins)
  
  E(x)$IDs <- id
  lines.dat <- as.data.frame(edge.attributes(x))
  SLDF <- SpatialLinesDataFrame(SL, lines.dat, match.ID = FALSE)
  
  return(list(vertices = SPDF, edges = SLDF))
}



#' Arc of a Circle
#' 
#' Compute the arc between two points with its angular distance.
#' 
#' @param pt1 a numeric vector of length 2  giving the coordinates (x and y) of the first point.
#' @param pt1 a numeric vector of length 2  giving the coordinates (x and y) of the second point.
#' @param alpha a numeric giving the value of the central angle (angular distance in degrees).
#' @param n the number of points to generate.
#' @param inv a logical. Since there are two solutions, can be used to get the second arc.
#' 
#' @return A two-column matrix of points coordinates.
#' @export
arcAngle <- function (pt1, pt2, alpha = 45, n = 100, inv = FALSE){
  
  f <- sqrt((pt1[1] - pt2[1])^2 + (pt1[2] - pt2[2])^2)
  R <- f / (2 * sin(alpha * pi/180 /2 ))
  xm <- (pt1[1] + pt2[1])/2
  ym <- (pt1[2] + pt2[2])/2
  m <- (pt1[1] - pt2[1])/(pt2[2] - pt1[2])
  a <- sqrt(R^2 - (f/2)^2)
  if(inv){
    xc <- xm + a/sqrt(m^2 + 1)
    yc <- ym + m * (a/sqrt(m^2 + 1))
  } else {
    xc <- xm - a/sqrt(m^2 + 1)
    yc <- ym - m * (a/sqrt(m^2 + 1))
  }
  
  startAngle = atan2(pt1[2] - yc, pt1[1] - xc) * 180/pi
  endAngle = atan2(pt2[2] - yc, pt2[1] - xc) * 180/pi
  gen <- seq(startAngle, endAngle, length = n)
  xx <- xc + R * cos(gen * 2 * pi/360)
  yy <- yc + R * sin(gen * 2 * pi/360)
  res <- cbind(x = xx, y = yy)
  return(res)
}
