#' epimap
#'
#' @import sp
#' @import rleafmap
#' @import igraph
#' @importFrom geosphere gcIntermediate
#' 
#' @name epimap
#' @docType package
NULL



#' Cholera Data
#' 
#' Cholera dataset of John Snow in London.
#' 
#' @format a list of two \code{SpatialPointsDataFrame}.
#' \itemize{
#'    \item deaths Cholera Death locations.
#'    \item deaths.den Cholera deaths density.
#'    \item pumps Pumps locations.
#'  }
#' @source http://blog.rtwilson.com/john-snows-cholera-data-in-more-formats/
#' @docType data
#' @keywords datasets
#' @name cholera
#' @usage data(cholera)
NULL