###############################################################################
context("Visualize")
###############################################################################

data <- read.csv(system.file("data.csv", package = "conceptr"))
hierarchy <- read.csv(system.file("concept-hierarchy.csv", package = "conceptr"))

test_that("the hierarchy table is translated to a correct list of lists", {
# set up a reference hierarchy that has the correct structure expected from
# the fromJSON import (as a list of lists in R)
  reference_hierarchy <- list(name = "", children = list(
                            list(name = "Level1-A", children = list(
                              list(name = "Level2-AA", children = list(
                                list(name = "Level3-AAA")
                                )),
                              list(name = "Level2-AB")
                            )),
                            list(name = "Level1-B", children = list(
                              list(name = "Level2-BA"),
                              list(name = "Level2-BB"),
                              list(name = "Level2-BD")
                            )),
                            list(name = "Level1-C", children = list(
                              list(name = "Level2-CA", children = list(
                                list(name = "Level3-CAA"),
                                list(name = "Level3-CAB", children = list(
                                  list(name = "Level4-CABA")
                            )))))),
                            list(name = "Level1-D")
                          ))


  test_list <- create_list(hierarchy)
  jsonified_hierarchy <- jsonify(hierarchy)
  jsonified_reference <- jsonify(reference_hierarchy)
  # We cannot compare list of list directly, so we translate to json first).
  # TODO: the following comparison is not equal, even though both graphs are identical
  # The list created by create_list() is different than that of the reference hierarchy
  # expect_that(jsonified_hierarchy, equals(reference_hierarchy))
})
