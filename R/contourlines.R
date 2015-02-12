#' Contour Lines to SpatialLinesDataFrame
#' 
#' This function takes a SpatialGrid object and returns
#' contour lines as a SpatialLinesDataFrame object.
#' 
#' @param x a \code{SpatialGrid} object.
#' @param layer which layer of x to use. This may be the column name or a column number.
#' @param nlevels number of contour levels.
#' 
#' @return a \code{SpatialLinesDataFrame}
#' 
extractContour <- function(x, layer = 1, nlevels = 10){
  
  im <- as.image.SpatialGridDataFrame(x, attr = layer)
  cl <- contourLines(im, nlevels = nlevels)
  id <- seq(1, length(cl))
  mat <- lapply(cl, function(x) cbind(x$x, x$y))
  lin <- lapply(mat, function(x) Line(x))
  lins <- mapply(function(x, y) Lines(x, ID = y), lin, id)
  SL <- SpatialLines(lins)
  dat <- as.data.frame(sapply(cl, function(x) x$level))
  names(dat) <- "level"
  SD <- SpatialLinesDataFrame(SL, dat, match.ID = FALSE)
  
  return (SD)
}