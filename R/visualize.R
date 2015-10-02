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
visualize.ternary <- function(plot_categories, color="") {
  one   <- aggregate.byname(data, hierarchy, plot_categories[1])[plot_categories[1]]
  two   <- aggregate.byname(data, hierarchy, plot_categories[2])[plot_categories[2]]
  three <- aggregate.byname(data, hierarchy, plot_categories[2])[plot_categories[3]]
  plot_data <-  cbind(one, two, three, Ambiente)
  colnames(plot_data) <- c("one", "two", "three", "Ambiente")

  p <- ggtern(data=plot_data, aes(x=one, y=two, z=three, color=Ambiente))
  p <- p + theme_rgbw() + geom_point()
  p <- p + xlab(plot_categories[1]) + ylab(plot_categories[2]) + zlab(plot_categories[3])
  p
  return(p)
}
