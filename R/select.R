#' Select at level
#'
#' Get all the variables at the given level (level 1 for the highest level). If
#' the requested level does not exist give a warning.
#'
#' Note that you are only selecting, not aggregating. If you want to roll-up
#' to any given level, use the aggregate_bylevel function instead.
#' @param data The data set
#' @param hierarchy The hierachy definitoin
#' @param level The level of interest
#' @export select_level
select_level <- function(data, hierarchy, level) {
  # Get the names of the concepts at the requested level
  selected_columns <- hierarchy %>%
    filter(parent_id==level)

  column_names <- as.vector(make.names(selected_columns$name))

  result <- result %>%
    select(one_of(column_names))
  return(result)
}
