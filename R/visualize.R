library(networkD3)
library(ggtern)

#' Visualize concept hierarchy by level
#'
#' Visualize all the variables at the given level (level 1 for the highest
#' level) in a network3D diagram. If the requested levels do not exist give a
#' warning
#' @param data
#' @param hierarchy
#' @param level
#' @export visualize.bylevel
visualize.bylevel <- function(data, hierarchy, level) {
  print("The visualize.network function has not been implemented yet.")
}

#' Visualize concept hierarchy by name
#'
#' Get all the variables at the given level (level 1 for the highest level). If
#' the requested levels do not exist give a warning
#' @param data
#' @param hierarchy
#' @param name name of highest level concept to visualize
#' @export visualize.byname
visualize.byname <- function(data, hierarchy, name) {
  print("The visualize.network function has not been implemented yet.")
}

#' Visualize concept relationships by name
#'
#' Get all the variables at the given level (level 1 for the highest level). If
#' the requested levels do not exist give a warning
#' @param data
#' @param hierarchy
#' @param names vector of three names to include in ternary diagram
#' @export visualize.ternary
visualize.ternary <- function(data, hierarchy, names) {
  top   <- names[1]
  left  <- names[2]
  right <- names[3]

  axis_1 <- aggregate.byname(data, hierarchy, top)[top]
  axis_2 <- aggregate.byname(data, hierarchy, left)[left]
  axis_3 <- aggregate.byname(data, hierarchy, right)[right]

  plot_data <- cbind(axis_1, axis_2, axis_3)

  p <- ggtern(data=plot_data, aes_string(x=top, y=left, z=right))
  p <- p + theme_rgbw() + geom_point()
  return(p)
}
