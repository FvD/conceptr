library(dplyr)

#' Aggregate all children into parents
#'
#' Aggregate data by calling the top-level hierarchy that is required plus any
#' additional columns to be included.
#'
#' Note that a hierarchy data frame is required, which is a data frame consisting
#' of the Class ID, Class Name and Parent ID.
#' @param data Data object to be included
#' @param hierarchy Data frame containing hierarchy data
#' @export aggregate_byname
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
#' @param data Data object to be included
#' @param hierarchy Data frame containing hierarchy data
#' @param colname The column name that needs to be aggregated
#' @export aggregate_byname
aggregate_byname <- function(data, hierarchy, colname) {
  # Lookup children of colname and make a vector of child names
  parent_name <- make.names(colname)
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
  selected_rows <- data %>%
    select(one_of(c(parent_name, children)[available_cols])) %>%
    transmute(hsum=rowSums(., na.rm=TRUE))

  result <- data %>%
    select(-one_of(c(parent_name, children)))  %>%
    cbind(selected_rows)

  names(result)[names(result)=="hsum"] <- paste(parent_name)

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
#' @export aggregate_bylevel
aggregate_bylevel <- function(data, hierarchy, level) {
  print("The aggregate_bylevel function has not been implemented yet.")
}

#' get_children by name
#'
#' Returns a data.frame with all children of a named concept.
#'
#' @param data Data object to be included
#' @param hierarchy Data frame containing hierarchy data
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
