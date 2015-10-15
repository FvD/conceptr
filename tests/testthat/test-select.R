###############################################################################
context("select_level")
###############################################################################

data <- read.csv(system.file("data.csv", package="conceptr"))
hierarchy <- read.csv(system.file("concept-hierarchy.csv", package="conceptr"))


test_that("selection of level with single column is correct", {
  selected_data <- select_level(data, hierarchy, 4)
  selected_level4.CABA <- selected_data$Level4.CABA
  #aggregated_cuticles <- data$Cuticles
  expect_that(selected_level4[1], equals(data$Level4.CABA[1]))
  expect_that(selected_level4[2], equals(data$Level4.CABA[2]))
  expect_that(selected_level4[3], equals(data$Level4.CABA[3]))
  expect_that(selected_level4[4], equals(data$Level4.CABA[4]))
  expect_that(selected_level4[5], equals(data$Level4.CABA[5]))
  # Special case with NA value in the data
  expect_that(selected_level4[9], equals(0))
})

test_that("there is an error for non-existing level", {
  aggregated_level1D <- select_level(data, hierarchy, 23)
})

test_that("selection of level with multiple columns is correct", {
  selected_data <- select_level(data, hierarchy, 2)
  selected_level2.AA <- selected_data$Level2.AA
  expect_that(selected_level2.AA[1], equals(sum(data$Level2.AA[1],
                                                data$Level3.AAA[1],
                                                na.rm=TRUE)))
  expect_that(selected_level2.AA[2], equals(sum(data$Level2.AA[2],
                                                data$Level3.AAA[2],
                                                na.rm=TRUE)))
  expect_that(selected_level2.AA[3], equals(sum(data$Level2.AA[3],
                                                data$Level3.AAA[3],
                                                na.rm=TRUE)))
  expect_that(selected_level2.AA[4], equals(sum(data$Level2.AA[4],
                                                data$Level3.AAA[4],
                                                na.rm=TRUE)))
  # Special case with NA Level1Athe data
  expect_that(selected_level2.AA[5], equals(sum(data$Level2.AA[5],
                                                data$Level3.AAA[5],
                                                na.rm=TRUE)))
  expect_that(selected_level2.AA[8], equals(sum(data$Level2.AA[8],
                                                data$Level3.AAA[8],
                                                na.rm=TRUE)))
})

test_that("selection and aggregation of with empty (NA) columns is correct", {
  selected_data <- select_level(data, hierarchy, 1)
  selected_Level1C <- selected_data$Level1.C
  expect_that(selected_Level1C[1], equals(sum(data$Level1.C[1],
                                              data$Level2.CA[1],
                                              data$Level3.CAA[1],
                                              data$Level3.CAB[1],
                                              data$Level4.CABA[1],
                                              na.rm=TRUE)))
  expect_that(selected_Level1C[2], equals(sum(data$Level1.C[2],
                                              data$Level2.CA[2],
                                              data$Level3.CAA[2],
                                              data$Level3.CAB[2],
                                              data$Level4.CABA[2],
                                              na.rm=TRUE)))
  expect_that(selected_Level1C[3], equals(sum(data$Level1.C[3],
                                              data$Level2.CA[3],
                                              data$Level3.CAA[3],
                                              data$Level3.CAB[3],
                                              data$Level4.CABA[3],
                                              na.rm=TRUE)))
  expect_that(selected_Level1C[4], equals(sum(data$Level1.C[4],
                                              data$Level2.CA[4],
                                              data$Level3.CAA[4],
                                              data$Level3.CAB[4],
                                              data$Level4.CABA[4],
                                              na.rm=TRUE)))
})

