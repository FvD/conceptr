###############################################################################
context("select_level")
###############################################################################

data <- read.csv(system.file("data.csv", package = "conceptr"))
hierarchy <- read.csv(system.file("concept-hierarchy.csv", package = "conceptr"))


test_that("selection of level with single column is correct", {
  selected_data <- select_level(data, hierarchy, 4)
  selected_level4.CABA <- selected_data$Level4.CABA
  #aggregated_cuticles <- data$Cuticles
  expect_that(selected_level4.CABA[1], equals(data$Level4.CABA[1]))
  expect_that(selected_level4.CABA[2], equals(data$Level4.CABA[2]))
  expect_that(selected_level4.CABA[3], equals(data$Level4.CABA[3]))
  expect_that(selected_level4.CABA[4], equals(data$Level4.CABA[4]))
  expect_that(selected_level4.CABA[5], equals(data$Level4.CABA[5]))
  # Special case with NA valu.CABAe in the data
  expect_that(selected_level4.CABA[9], equals(NA_integer_))
})

test_that("there is an error for non-existing level", {
  aggregated_level1D <- select_level(data, hierarchy, 23)
})

test_that("selection of level with multiple columns is correct", {
  selected_data <- select_level(data, hierarchy, 2)
  selected_level2.AA <- selected_data$Level2.AA
  expect_that(selected_level2.AA[1], equals(data$Level2.AA[1]))
  expect_that(selected_level2.AA[2], equals(data$Level2.AA[2]))
  expect_that(selected_level2.AA[3], equals(data$Level2.AA[3]))
  expect_that(selected_level2.AA[4], equals(data$Level2.AA[4]))
  # Special case with NA Level1Athe data
  expect_that(selected_level2.AA[5], equals(data$Level2.AA[5]))
  expect_that(selected_level2.AA[8], equals(data$Level2.AA[8]))
})

test_that("selection with empty (NA) columns is correct", {
  selected_data <- select_level(data, hierarchy, 3)
  selected_Level3.CAB <- selected_data$Level3.CAB
  expect_that(selected_Level3.CAB[1], equals(NA))
  expect_that(selected_Level3.CAB[2], equals(NA))
  expect_that(selected_Level3.CAB[3], equals(NA))
  expect_that(selected_Level3.CAB[4], equals(NA))
})

