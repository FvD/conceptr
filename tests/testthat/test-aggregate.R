context("Aggregate")

data <- read.csv(system.file("data.csv", package="conceptr"))
hierarchy <- read.csv(system.file("concept-hierarchy.csv", package="conceptr"))


test_that("aggregation of single column is correct", {
  aggregated_cuticles <- aggregate.byname(data, hierarchy, "Cuticles")
  aggregated_cuticles <- aggregated_cuticles$Cuticles
  #aggregated_cuticles <- data$Cuticles
  expect_that(aggregated_cuticles[1], equals(data$Cuticles[1]))
  expect_that(aggregated_cuticles[2], equals(data$Cuticles[2]))
  expect_that(aggregated_cuticles[3], equals(data$Cuticles[3]))
  expect_that(aggregated_cuticles[4], equals(data$Cuticles[4]))
  expect_that(aggregated_cuticles[5], equals(data$Cuticles[5]))
  # Special case with NA value in the data
  expect_that(aggregated_cuticles[9], equals(0))
})

test_that("aggregation of multiple columns is correct", {
  aggregated_Amorphous <- aggregate.byname(data, hierarchy, "Amorphous")
  aggregated_Amorphous <- aggregated_Amorphous$Amorphous
  expect_that(aggregated_Amorphous[1], equals(sum(data$Amorphous[1], data$Sapropelic[1], data$Fine.grained[1], na.rm=TRUE)))
  expect_that(aggregated_Amorphous[2], equals(sum(data$Amorphous[2], data$Sapropelic[2], data$Fine.grained[2], na.rm=TRUE)))
  expect_that(aggregated_Amorphous[3], equals(sum(data$Amorphous[3], data$Sapropelic[3], data$Fine.grained[3], na.rm=TRUE)))
  expect_that(aggregated_Amorphous[4], equals(sum(data$Amorphous[4], data$Sapropelic[4], data$Fine.grained[4], na.rm=TRUE)))
  # Special case with NA value in the data
  expect_that(aggregated_Amorphous[5], equals(sum(data$Amorphous[5], data$Sapropelic[5], data$Fine.grained[5], na.rm=TRUE)))
  expect_that(aggregated_Amorphous[8], equals(sum(data$Amorphous[8], data$Sapropelic[8], data$Fine.grained[8], na.rm=TRUE)))
})
