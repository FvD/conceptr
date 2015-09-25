library(dplyr)
#' Aggregate data by concept name
#'
#' Aggregate data by calling the top-level hierarchy that is required plus any
#' additional columns to be included.
#'
#' Note that a hierarchy data frame is required, which is a data frame consisting
#' of the Class ID, Class Name and Parent ID.
#' @param data Data object to be included
#' @param hierarchy Data frame containing hierarchy data
#' @param colname The column name that needs to be aggregated
#' @export aggregate.byname
aggregate.byname <- function(data, hierarchy, colname) {
  # Lookup children of colname and make a vector of child names
  parent <- make.names(colname)

  hierarchy$name <- make.names(hierarchy$name)

  parentID <- hierarchy %>%
    filter(name==parent) %>%
    select(id)
  parentID <- parentID[[1]]

  childrenID <- hierarchy %>%
    filter(parent_id==parentID) %>%
    select(name)

 children = as.vector(childrenID$name)

  # Sum parent + children with na.rm=TRUE
  selected_rows <- data %>%
    select(one_of(c(parent, children))) %>%
    transmute(hsum=rowSums(., na.rm=TRUE))


  result <- data %>%
    select(-one_of(c(parent, children)))  %>%
    cbind(selected_rows)

  names(result)[names(result)=="hsum"] <- paste(parent)

 return(result)

}


#' Aggregate at level
#'
#' Aggregate data by calling the top-level hierarchy that is required plus any
#' additional columns to be included.
#'
#' Note that a hierarchy data frame is required, which is a data frame consisting
#' of the Class ID, Class Name and Parent ID.
#' @param data Data object to be included
#' @param hierarchy Data frame containing hierarchy data
#' @export aggregate.bylevel
aggregate.bylevel <- function(data, hierarchy, level) {
  print("The aggregate.bylevel function has not been implemented yet.")
}


