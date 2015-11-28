#' Hierarchy Characteristics
#'
#' When data gathering takes place for concept hierarchies there are two
#' approaches: Counts are made to the lowest possible level (this is common in
#' biological sciences), or counts are made to a specific level (as may be more
#' common in competency data, where the value is part of the definition of the
#' model).
#'
#' We need to know which is which, so we test when a higher order concept has
#' children in the dataset whether these are already a sum of the lower
#' concepts or a different value. The result is a data frame with two columns:
#' `concept name` and `accumulated`. The latter has a yes/no value.
#' resulting data frame has column names as the aggregated columns.
#'
#' @param data Data object to be included
#' @param hierarchy Data frame containing hierarchy data
#' @export aggregate_all

inspect_hierarchy <- function(data, hierarchy) {
  print("The inspect_hierarchy function has not been implemented yet.")
}

#' Concept Characteristics
#'
#' Aggregate all data to the level given by (level 1 for the highest level). The
#' resulting data frame has column names as the aggregated columns.
#'
#' It needs to answer: are all classes filled / balanced down to the lowest
#' hierarchical level?
#'
#' @param data Data object to be included
#' @param hierarchy Data frame containing hierarchy data
#' @param concept The concept name (column name) that needs to be aggregated
#' @export aggregate_all

inspect_concept <- function(data, hierarchy, concept) {
  print("The inspect_concept function has not been implemented yet.")
}
