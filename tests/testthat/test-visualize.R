###############################################################################
context("Visualize")
###############################################################################

# set up a reference hierarchy that has the correct structure expected from
# the fromJSON import (as a list of lists in R)

reference_hierarchy <- list(name="", children=list(
                          list(name="Level1-A", children=list(
                            list(name="Level2-AA", children=list(
                              list(name="Level3-AAA"))),
                          list(name="Level2-AB"),
                          list(name="Level1-B", children=list(
                            list(name="Level2-BA"),
                            list(name="Level2-BB"),
                            list(name="Level2-BD")),
                          list(name="Level1-C", children=list(
                            list(name="Level2-CA", children=list(
                              list(name="Level3-CAA"),
                              list(name="Level3-CAB"),
                              list(name="Level4-CABA"))),
                          list(name="Level1-D")
                          )))))))

