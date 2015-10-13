context("Aggregate")

data <- read.csv(system.file("data.csv", package="conceptr"))
hierarchy <- read.csv(system.file("concept-hierarchy.csv", package="conceptr"))


test_that("aggregation of single column is correct", {
  aggregated_level1D <- aggregate.byname(data, hierarchy, "Level1.D")
  aggregated_level1D <- aggregated_level1D$Level1.D
  #aggregated_cuticles <- data$Cuticles
  expect_that(aggregated_level1D[1], equals(data$Level1.D[1]))
  expect_that(aggregated_level1D[2], equals(data$Level1.D[2]))
  expect_that(aggregated_level1D[3], equals(data$Level1.D[3]))
  expect_that(aggregated_level1D[4], equals(data$Level1.D[4]))
  expect_that(aggregated_level1D[5], equals(data$Level1.D[5]))
  # Special case with NA value in the data
  expect_that(aggregated_level1D[9], equals(0))
})

test_that("there is an error for non-existing name", {
  aggregated_level1D <- aggregate.byname(data, hierarchy, "Level1-D")
})

test_that("aggregation of multiple columns is correct", {
  aggregated_Level1A <- aggregate.byname(data, hierarchy, "Level1.A")
  aggregated_Level1A <- aggregated_Level1A$Level1.A
  expect_that(aggregated_Level1A[1], equals(sum(data$Level1.A[1],
                                                data$Level2.AA[1],
                                                data$Level2.AB[1],
                                                data$Level3.AAA[1],
                                                na.rm=TRUE)))
  expect_that(aggregated_Level1A[2], equals(sum(data$Level1.A[2],
                                                data$Level2.AA[2],
                                                data$Level2.AB[2],
                                                data$Level3.AAA[2],
                                                na.rm=TRUE)))
  expect_that(aggregated_Level1A[3], equals(sum(data$Level1.A[3],
                                                data$Level2.AA[3],
                                                data$Level2.AB[3],
                                                data$Level3.AAA[3],
                                                na.rm=TRUE)))
  expect_that(aggregated_Level1A[4], equals(sum(data$Level1.A[4],
                                                data$Level2.AA[4],
                                                data$Level2.AB[4],
                                                data$Level3.AAA[4],
                                                na.rm=TRUE)))
  # Special case with NA Level1Athe data
  expect_that(aggregated_Level1A[5], equals(sum(data$Level1.A[5],
                                                data$Level2.AA[5],
                                                data$Level2.AB[5],
                                                data$Level3.AAA[5],
                                                na.rm=TRUE)))
  expect_that(aggregated_Level1A[8], equals(sum(data$Level1.A[8],
                                                data$Level2.AA[8],
                                                data$Level2.AB[8],
                                                data$Level3.AAA[8],
                                                na.rm=TRUE)))
})

test_that("aggregation of with empty (NA) columns is correct", {
  aggregated_Level1C <- aggregate.byname(data, hierarchy, "Level1.C")
  aggregated_Level1C <- aggregated_Level1A$Level1.A
  expect_that(aggregated_Level1C[1], equals(sum(data$Level1.C[1],
                                                data$Level2.CA[1],
                                                data$Level3.CAA[1],
                                                data$Level3.CAB[1],
                                                data$Level4.CABA[1],
                                                na.rm=TRUE)))
  expect_that(aggregated_Level1C[2], equals(sum(data$Level1.C[2],
                                                data$Level2.CA[2],
                                                data$Level3.CAA[2],
                                                data$Level3.CAB[2],
                                                data$Level4.CABA[2],
                                                na.rm=TRUE)))
  expect_that(aggregated_Level1C[3], equals(sum(data$Level1.C[3],
                                                data$Level2.CA[3],
                                                data$Level3.CAA[3],
                                                data$Level3.CAB[3],
                                                data$Level4.CABA[3],
                                                na.rm=TRUE)))
  expect_that(aggregated_Level1C[4], equals(sum(data$Level1.C[4],
                                                data$Level2.CA[4],
                                                data$Level3.CAA[4],
                                                data$Level3.CAB[4],
                                                data$Level4.CABA[4],
                                                na.rm=TRUE)))
})
