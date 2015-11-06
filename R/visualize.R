library(networkD3)
library(ggtern)
library(jsonlite)

#' Visualize concept hierarchy
#'
#' Visualize all the variables at the given level (level 1 for the highest
#' level) in a network3D diagram. If the requested levels do not exist give a
#' warning
#' @param hierarchy
#' @export visualize_hierarchy
visualize_hierarchy <- function(hierarchy) {
  listoflists <- create_list(hierarchy)
  p <- diagonalNetwork(listoflists)
  return(p)
}

#' Visualize concept relationships by name
#'
#' Get all the variables at the given level (level 1 for the highest level). If
#' the requested levels do not exist give a warning
#' @param data
#' @param hierarchy
#' @param plot_categories
#' @param color
#' @export visualize_ternary
visualize_ternary <- function(data, hierarchy, plot_categories, color) {
  plot_legend <- color
  plot_categories <- plot_categories
  one   <- aggregate_byname(data, hierarchy, plot_categories[1])[plot_categories[1]]
  two   <- aggregate_byname(data, hierarchy, plot_categories[2])[plot_categories[2]]
  three <- aggregate_byname(data, hierarchy, plot_categories[3])[plot_categories[3]]
  plot_data <-  cbind(one, two, three, plot_legend)
  colnames(plot_data) <- c("one", "two", "three", "Legend")

  p <- ggtern(data=plot_data, aes(x=one, y=two, z=three, color=Legend))
  p <- p + theme_rgbw() + geom_point()
  p <- p + xlab(plot_categories[1]) + ylab(plot_categories[2]) + zlab(plot_categories[3])
  p
  return(p)
}
