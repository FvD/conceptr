library(networkD3)
library(ggtern)
library(jsonlite)
#' Add Child ID to self-referential table
#'
#' @param hierarchy
add_child_id <-  function(hierarchy){
  max_id <- max(hierarchy$id)
  new_list <- data.frame("id"=NA, "name"=NA, "parent_id"=NA, "child_id"=NA)
  for(i in 1:max_id){
    # check for children and add them to the list
    parent_id <- hierarchy[i,]$parent_id
    concept_name <- as.vector(hierarchy[i,]$name)
    child_list <- dplyr::filter(hierarchy, parent_id==i)
    if(nrow(child_list) > 0) {
      for(current_id in child_list$id) {
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

#' Create json formatted hierarchy
#'
#' To work with networkD3 we need the hierarchy as a json formatted document.
#' This function takes the hierachy table and converts it to the required json
#' format. Since we are working with sel-referential tables, the depth of each
#' concept in the hierarchy needs to be identified first.
#'
#' It accepts a level in case a lower level structure is required for the
#' visualization
#' @param hierarchy
#' @param level
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
 new_hierarchy[new_hierarchy$parent_id==0, "level"] <- level_index
 parent_level <- dplyr::filter(list_hierarchy, parent_id==0)
 list_hierarchy <- dplyr::filter(list_hierarchy, parent_id!=0)

  # get next levels until there are not more records
  while(nrow(list_hierarchy) > 0){
    level_index = 1 + level_index
    new_parent_level <- parent_level[0,]
    print(list_hierarchy)
    for(i in 1:max_id){
      cat("loop index", i, "\n")
      if(i %in% parent_level$child_id){
         new_hierarchy[new_hierarchy$id==i, "level"] <- level_index
      #   current_parent_id <- dplyr::filter(current_parent_id, id!=i)
         new_rows <- dplyr::filter(list_hierarchy, id==i)
         new_parent_level <- rbind(new_parent_level, new_rows)
         list_hierarchy <- dplyr::filter(list_hierarchy, id!=i)
         print(new_parent_level)
         cat("end of loop", list_hierarchy$id, "\n------\n")
      }else{
        print("not in parent level \n")
      }
    }
    parent_level <- new_parent_level
  }

 join_hierarchy <- new_hierarchy %>%
   select(id, level) %>%
   distinct()

 hierarchy <- hierarchy %>%
    left_join(join_hierarchy, by=c("id"="id"))

 listoflists <- list(name="")
 max_level <- max(hierarchy$level)
 try{
  for(i in 1:max_level) {
  current_level <- dplyr::filter(hierarchy, level==i)
  level_string <- ""
  # create children to the correct depth
  for(c in 1:i){
    level_string <- paste(level_string, "$children", sep="")
  }
  # Append the levels using the level_string as the position
  # cat("current level with parent_id = ", i, "\n")
    if(nrow(current_level) > 0){
      for(j in 1:nrow(current_level)){

        cat("current level, ", i, " index =", j, "\n")
        new <- paste("listoflists", level_string, "[[", j, "]]", " <- ", "list(name='", current_level$name[j], "')", sep="")
        eval(parse(text=new))
    #  listoflists <- append(listoflists, list(children=(list(children, name=current_level$name[j]))))
      }
    }
  }
 } # End of try
return(listoflists)
}

#' Visualize concept hierarchy by level
#'
#' Visualize all the variables at the given level (level 1 for the highest
#' level) in a network3D diagram. If the requested levels do not exist give a
#' warning
#' @param data
#' @param hierarchy
#' @param level
#' @export visualize_atlevel
visualize_atlevel <- function(data, hierarchy, level) {
  print("The visualize_atlevelfunction has not been implemented yet.")
}

#' Visualize concept hierarchy by name
#'
#' Get all the variables at the given level (level 1 for the highest level). If
#' the requested levels do not exist give a warning
#' @param data
#' @param hierarchy
#' @param name name of highest level concept to visualize
#' @export visualize_byname
visualize_byname <- function(data, hierarchy, name) {
  print("The visualize_byname function has not been implemented yet.")
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
