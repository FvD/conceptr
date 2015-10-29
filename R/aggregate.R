library(dplyr)

#' Aggregate all children into parents
#'
#' Aggregate data by calling the top-level hierarchy that is required plus any
#' additional columns to be included.
#'
#' Note that a hierarchy data frame is required, which is a data frame consisting
#' of the Class ID, Class Name and Parent ID.
#'
#' @param data Data object to be included
#' @param hierarchy Data frame containing hierarchy data
#' @export aggregate_all
aggregate_all <- function(data, hierarchy) {
  all_levels <- make.names(hierarchy$name)
  all_colls <- data[,0]

  for(i in 1:length(all_levels)){
    new_coll <- aggregate_byname(data, hierarchy, all_levels[i])[all_levels[i]]
    all_colls <- cbind(all_colls, new_coll)
  }

  return(all_colls)
}

#' Aggregate data by concept name
#'
#' Aggregate data by calling the top-level hierarchy that is required plus any
#' additional columns to be included.
#'
#' Note that a hierarchy data frame is required, which is a data frame consisting
#' of the Class ID, Class Name and Parent ID.
#'
#' @param data Data object to be included
#' @param hierarchy Data frame containing hierarchy data
#' @param concept The concept name (column name) that needs to be aggregated
#' @export aggregate_byname
aggregate_byname <- function(data, hierarchy, concept) {
  # Lookup children of colname and make a vector of child names
  parent_name <- make.names(concept)
  max_level <- max(hierarchy$id)

  colnames(data) <- make.names(colnames(data))
  colnames(hierarchy) <- c("id","name", "parent_id")
  hierarchy$name <- make.names(hierarchy$name)

  root_parent <- hierarchy %>%
    filter(name==parent_name)

 children <- get_children(hierarchy, root_parent)
 children = as.vector(children$name)

  # Sum parent + children with na.rm=TRUE
  available_cols <- c(parent_name, children) %in% colnames(data)
  if(available_cols){
    selected_rows <- data %>%
      select(one_of(c(parent_name, children)[available_cols])) %>%
      transmute(hsum=rowSums(., na.rm=TRUE))
  result <- data %>%
    select(-one_of(c(parent_name, children)))  %>%
    cbind(selected_rows)

  names(result)[names(result)=="hsum"] <- paste(parent_name)
  } else {
  warning("No data available for the selected concepts")
  result <- data
}
 return(result)
}

#' Aggregate at level
#'
#' Aggregate data at the requested level. The requested level will be the
#' cut-off point so that any levels below will be rolled up to the requested
#' level, and any levels above will remain as they are.
#'
#' Note that a hierarchy data frame is required, which is a data frame consisting
#' of the Class ID, Class Name and Parent ID.
#' @param data Data object to be included
#' @param hierarchy Data frame containing hierarchy data
#' @param level The level of interest
#' @export aggregate_atlevel
aggregate_atlevel <- function(data, hierarchy, level) {
  # Get the names of the concepts at the requested level
  selected_columns <- hierarchy %>%
    filter(parent_id==level)

  column_names <- as.vector(make.names(selected_columns$name))

  # Roll up the data to the names at the requested level
  result <- data
  for(i in 1:length(column_names)){
    result <- result %>%
       aggregate_byname(hierarchy, column_names[i])
  }

  return(result)
}

# get_children by name
#
# Returns a data.frame with all children of a named concept.
#
# @param data Data object to be included
# @param hierarchy Data frame containing hierarchy data
get_children <- function(hierarchy, parent){

 hierarchy$name <- make.names(hierarchy$name)

 children   <- data.frame("id"=NA, "name"=NA, "parent_id"=NA)[0,]
 new_parent <- data.frame("id"=NA, "name"=NA, "parent_id"=NA)[0,]
 result  <- data.frame("id"=NA, "name"=NA, "parent_id"=NA)[0,]

 for(j in 1:nrow(hierarchy)){
   if(nrow(parent)>0){
     for(i in 1:nrow(parent)){
       parentID <- parent[i,]$id
       new_children <- hierarchy %>%
        filter(parent_id==parentID)
       children <- rbind(children, new_children)
       new_parent <- new_children
     }
   }
  parent <- new_parent
  test <- rbind(result, children)
 }
 children <- distinct(children, id)
  return(children)
}
