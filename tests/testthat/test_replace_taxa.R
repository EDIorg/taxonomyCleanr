context('Replace taxa')
library(taxonomyCleanr)

# Parameterize ----------------------------------------------------------------

data <- data.table::fread(
  file = system.file('test_data.txt', package = 'taxonomyCleanr'),
  fill = TRUE,
  blank.lines.skip = TRUE
)
path <- system.file('test_data.txt', package = 'taxonomyCleanr')
path <- substr(path, 1, nchar(path) - 14)

# Tests -----------------------------------------------------------------------

testthat::test_that('Expect errors', {
  expect_error(replace_taxa(input = 'Mossessss', output = 'Mossez', x = data,
                            col = 'Species'))
  expect_error(replace_taxa(input = 'Mossessss', output = 'Mossez',
                            path = path))
})

testthat::test_that('Output class is data.frame', {
  expect_true(
    all(
      class(replace_taxa(input = 'Mosses', output = 'Mossez', x = data, col = 'Species')) %in%
        c("data.frame", "data.table")
    )
  )
  expect_true(
    all(
      class(replace_taxa(input = 'Mosses', output = 'Mossez', path = path)) %in%
        c("data.frame", "data.table")
    )
  )
})

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
  expect_true(
    all(
      class(data_out) %in% c("data.frame", "data.table")
    )
  )
  expect_equal(
    sum(use_i),
    sum(use_i2)
  )

})


