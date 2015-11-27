#' Add Child ID to self-referential table
#'
#' @param hierarchy
#' @export add_child_id
add_child_id <-  function(hierarchy){
  max_id <- max(hierarchy$id)
  new_list <- data.frame("id" = NA, "name" = NA, "parent_id" = NA, "child_id" = NA)
  for (i in 1:max_id){
    # check for children and add them to the list
    parent_id <- hierarchy[i,]$parent_id
    concept_name <- as.vector(hierarchy[i,]$name)
    child_list <- dplyr::filter(hierarchy, parent_id == i)
    if (nrow(child_list) > 0) {
      for (current_id in child_list$id) {
        new_row <- c(i, concept_name, parent_id, current_id)
        new_list <- rbind(new_list, new_row)
      }
    }else{
      new_row <- c(i, concept_name, parent_id, NA)
      new_list <- rbind(new_list, new_row)
    }
  }
  new_list <- new_list[-1,]
  new_list$id <- as.numeric(new_list$id)
  new_list$parent_id <- as.numeric(new_list$parent_id)
  new_list$child_id <- as.numeric(new_list$child_id)
  return(new_list)
}

#' Add hierarchy level to self-referential table
#'
#' @param hierarchy
#' @export add_hierarchy_level
add_hierarchy_level <- function(hierarchy){
# Check for a child id
  if ("child_id" %in% colnames(hierarchy)) {
    print("found child_id, continuing ...")
    new_hierarchy <- hierarchy
    list_hierarchy <- new_hierarchy
  } else{
    print("child_id column not found, adding one first ...")
    new_hierarchy <- add_child_id(hierarchy)
    list_hierarchy <- new_hierarchy
  }
  # Add a column with the hierarchical level
  # Recurse through entire list to get the maximum level depth
  # This an ugly solution and computationally expensive
  # TODO: find better way to deal with self-referenced hierarchies
  max_id <- max(list_hierarchy$id)
  level_index <- 1

  # Get level_1 as reference
  new_hierarchy[new_hierarchy$parent_id == 0, "level"] <- level_index
  parent_level <- dplyr::filter(list_hierarchy, parent_id == 0)
  list_hierarchy <- dplyr::filter(list_hierarchy, parent_id != 0)

  # get next levels until there are not more records
  while (nrow(list_hierarchy) > 0) {
    level_index <- 1 + level_index
    new_parent_level <- parent_level[0, ]
    for (i in 1:max_id) {
      if (i %in% parent_level$child_id) {
        new_hierarchy[new_hierarchy$id == i, "level"] <- level_index
        #   current_parent_id <- dplyr::filter(current_parent_id, id!=i)
        new_rows <- dplyr::filter(list_hierarchy, id == i)
        new_parent_level <- rbind(new_parent_level, new_rows)
        list_hierarchy <- dplyr::filter(list_hierarchy, id != i)
      }
    }
    parent_level <- new_parent_level
  }
  return(new_hierarchy)
}

#' Create hierarchy as list of lists
#'
#' To work with networkD3 we need the hierarchy as a list of lists following
#' JSON structure.  This function takes the hierachy table and converts it to
#' the required list of lists format.
#'
#' Since we are working with sel-referential tables, the depth of each
#' concept in the hierarchy needs to be identified first.
#'
#' It accepts a level in case a lower level structure is required for the
#' visualization
#' @param hierarchy
#' @param level
#' @import dplyr
#' @export create_list
create_list <- function(hierarchy, level=1) {
  hierarchy$name <- make.names(hierarchy$name)

  # Add a column with the child_id
  new_hierarchy <- add_child_id(hierarchy)
  list_hierarchy <- new_hierarchy

  # Add a column with the hierarchical level
  # Recurse through entire list to get the maximum level depth
  # This an ugly solution and computationally expensive
  # TODO: find better way to deal with self-referenced hierarchies
  max_id <- max(list_hierarchy$id)
  level_index <- 1

 # Get level_1 as reference
 new_hierarchy[new_hierarchy$parent_id == 0, "level"] <- level_index
 parent_level <- dplyr::filter(list_hierarchy, parent_id == 0)
 list_hierarchy <- dplyr::filter(list_hierarchy, parent_id != 0)

  # get next levels until there are not more records
  while (nrow(list_hierarchy) > 0) {
    level_index <- 1 + level_index
    new_parent_level <- parent_level[0, ]
    for (i in 1:max_id) {
      if (i %in% parent_level$child_id) {
         new_hierarchy[new_hierarchy$id == i, "level"] <- level_index
      #   current_parent_id <- dplyr::filter(current_parent_id, id!=i)
         new_rows <- dplyr::filter(list_hierarchy, id == i)
         new_parent_level <- rbind(new_parent_level, new_rows)
         list_hierarchy <- dplyr::filter(list_hierarchy, id != i)
      }
    }
    parent_level <- new_parent_level
  }

#------------------------------------------------------------------------------
# Use found levels to create list of lists

 join_hierarchy <- new_hierarchy %>%
   select(id, level) %>%
   distinct()

 hierarchy <- hierarchy %>%
    left_join(join_hierarchy, by = c("id" = "id"))

 child_hierarchy <- new_hierarchy %>%
   left_join(hierarchy, by = c("child_id" = "id"))

#------------------------------------------------------------------------------
# Find positions in list

 max_depth <- max(new_hierarchy$level)
 max_id <- max(hierarchy$id)
 index <- ""

 # Set the root level order and initialize the column
 level_id <- 1
 current_level <- dplyr::filter(hierarchy, level == level_id )

 for(i in 1:nrow(current_level)){
   #order_index <- paste("$children[[",i,"]]", as.vector(current_level[i,]$name), sep="")
   order_index <- paste("$children[[",i,"]]", sep="")
   current_id <- current_level[i,]$id
   hierarchy$order[hierarchy$id==current_id] <- order_index
 }

 for(level_id in 2:max_depth){
   current_level <- dplyr::filter(hierarchy, level==level_id )

   for(current_parent_id in 1:max_id){
   current_parent <- dplyr::filter(current_level, parent_id==current_parent_id )

   if(nrow(current_parent) > 0){

     for(i in 1:nrow(current_parent)){
       current_concept <- current_parent[i,]
       current_id <- current_parent[i,]$id
     #  current_parent_id <- current_parent[i, ]$parent_id

       parent_index <- as.vector(hierarchy$order[hierarchy$id==current_parent_id])
       order_index <- paste(parent_index, "$children[[",i,"]]", sep="")
       hierarchy$order[hierarchy$id==current_id] <- order_index
      }
     }
   }
 }
 # -------------------------
 # create the list
 listoflists <- list(name="")
 #max_level <- max(hierarchy$level)

  for(i in 1:max_id) {
          new <- paste("listoflists",
                       hierarchy[i, ]$order
                       , " <- ",
                       "list(name='", hierarchy[i, ]$name, "')", sep="")
          eval(parse(text=new))
  }

return(listoflists)
}

#' Create json formatted hierarchy
#'
#' Small convenience function to convert the list of list as required by networkD3
#' to JSON format.
#'
#' @param hierarchy_as_list Hierarchy as a list of lists
#' @export jsonify
#' @importFrom jsonlite toJSON
jsonify <- function(hierarchy_as_list){
  hierarchy_as_json <- toJSON(hierarchy_as_list)
  return(hierarchy_as_json)
}

