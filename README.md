[![Build Status](https://travis-ci.org/Hackout2/epimap.svg?branch=master)](https://travis-ci.org/Hackout2/epimap)

# epimap

## Description
A set of functions to quickly and easily create interactive maps based on Leaflet. Designed to work with `mapData` via `sp` objects. Also implements some functions to convert more complex objects (like contourlines, graphs, ...) into `sp` object.

## Install
To install the package you can use `devtools`. You also need to install `rleafmap`.

    devtools::install_github("fkeck/rleafmap")
    devtools::install_github("Hackout2/epimap")

## Demo
First, load the package and the cholera dataset.

    library(epimap)
    data(cholera)

The package provides a collection of simple `*Map` functions to easily get interactive maps.

#### quickMap
You can use `quickMap` to quickly represent points and polygons and set colors and sizes using a column of the dataframe linked to the `sp` object.

    quickMap(cholera$deaths, col.by="Count", size.by="Count")

![quickmap](https://cloud.githubusercontent.com/assets/9269625/7374091/9fc6c160-edd0-11e4-8d42-5cdf01face3e.png)

#### heatMap
You can use the `heatMap` function to get an heat map (raster image and/or contour lines) from a `SpatialGridDataFrame`.

    heatMap(cholera$deaths.den)
    
![heatmap](https://cloud.githubusercontent.com/assets/9269625/7374266/81d155a2-edd1-11e4-846e-6a2a12c80de7.png)

#### netMap
You can use `netMap` to map spatial networks from an `igraph` object. For example we can create a network of pumps in Snow's London by connecting pumps which are geographically close. Note that you need to set explicitly geographical coordinates to the graph vertices with the `lat` and `lon` attributes.

    library(igraph)
    library(sp)
    
    pump.adj <- as.matrix(dist(coordinates(cholera$pumps)))
    pump.graph <- graph.adjacency(pump.adj < 0.003, diag = FALSE)
    V(pump.graph)$lat <- coordinates(cholera$pumps)[, 2]
    V(pump.graph)$lon <- coordinates(cholera$pumps)[, 1]
    
    netMap(pump.graph, v.size=5, width=500, height=300)

![netmap](https://cloud.githubusercontent.com/assets/9269625/7374270/854e9046-edd1-11e4-956d-f9e7c6e63696.png)
