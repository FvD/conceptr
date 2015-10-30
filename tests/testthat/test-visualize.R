###############################################################################
context("Visualize")
###############################################################################

data <- read.csv(system.file("data.csv", package="conceptr"))
hierarchy <- read.csv(system.file("concept-hierarchy.csv", package="conceptr"))

test_that("the hierarchy table is translated to a correct list of lists", {
# set up a reference hierarchy that has the correct structure expected from
# the fromJSON import (as a list of lists in R)

  reference_hierarchy <- list(name="", children=list(
                            list(name="Level1-A", children=list(
                              list(name="Level2-AA", children=list(
                                list(name="Level3-AAA")
                                )),
                              list(name="Level2-AB")
                            )),
                            list(name="Level1-B", children=list(
                              list(name="Level2-BA"),
                              list(name="Level2-BB"),
                              list(name="Level2-BD")
                            )),
                            list(name="Level1-C", children=list(
                              list(name="Level2-CA", children=list(
                                list(name="Level3-CAA"),
                                list(name="Level3-CAB"),
                                list(name="Level4-CABA")
                                ))
                            )),
                            list(name="Level1-D")
                          ))


  jsonified_hierarchy <- jsonify(hierarchy)
  # We cannot compare list of list directly, so we translate to json first).
  expect_that(jsonified_hierarchy, equals(reference_hierarchy))

# =================================
# working example to compare lists of lists

  list_one <- list(name="", children=list(
    list(name="Level1-A"),
    list(name="Level1-B"),
    list(name="Level1-C"),
    list(name="Level1-D")
    ))

  list_two <- list(name="", children=list(
    list(name="Level1-A"),
    list(name="Level1-B"),
    list(name="Level1-C"),
    list(name="Level1-D")
  ))

library(jsonlite)
jsonified_l1 <- toJSON(list_one)
jsonified_l2 <- toJSON(list_two)
jsonified_l1 == jsonified_l2
# >[1] TRUE
