context('Replace taxa')
library(taxonomyCleanr)

# Parameterize ----------------------------------------------------------------

data <- utils::read.table(
  system.file('test_data.txt', package = 'taxonomyCleanr'),
  header = TRUE,
  sep = '\t',
  as.is = T
)

# Tests -----------------------------------------------------------------------

testthat::test_that('Target taxa should be replaced in output', {

  input <- 'Oncorhynchus tshawytscha'
  output <- 'Test_output_taxa'
  use_i <- data$Species == input
  data_out <- replace_taxa(
    input = input,
    output = output,
    x = data$Species
  )
  use_i2 <- data_out == output

  expect_equal(
    class(data_out),
    'data.frame'
  )

  expect_equal(
    sum(use_i),
    sum(use_i2)
  )

})


testthat::test_that('Input can be character vector or data frame', {

  # Character vector
  input <- 'Oncorhynchus tshawytscha'
  output <- 'Test_output_taxa'
  use_i <- data$Species == input
  data_out <- replace_taxa(
    input = input,
    output = output,
    x = data$Species
  )
  use_i2 <- data_out == output
  expect_equal(
    class(data_out),
    'data.frame'
  )
  expect_equal(
    sum(use_i),
    sum(use_i2)
  )

  # Data frame
  input <- 'Oncorhynchus tshawytscha'
  output <- 'Test_output_taxa'
  use_i <- data$Species == input
  data_out <- replace_taxa(
    input = input,
    output = output,
    x = data,
    col = 'Species'
  )
  use_i2 <- data_out == output
  expect_equal(
    class(data_out),
    'data.frame'
  )
  expect_equal(
    sum(use_i),
    sum(use_i2)
  )

})


