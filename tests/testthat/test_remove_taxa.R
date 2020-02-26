context('Remove taxa')
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

testthat::test_that('Generate errors', {
  expect_error(remove_taxa(input = 'Stipa sparteaaaaa', x = data,
                           col = 'Species'))
  expect_error(remove_taxa(input = 'Stipa sparteaaaaa', path = path))
  expect_error(remove_taxa(input = 'Stipa sparteaaaa', path = path))
})

testthat::test_that('Data source is taxa_map.csv', {
  expect_true(
    all(
      class(remove_taxa(input = 'Stipa spartea', path = path)) %in% c("data.frame", "data.table")
    )
  )
})

testthat::test_that('Target taxa should be missing from output', {

  input <- 'Oncorhynchus tshawytscha'
  use_i <- data$Species == input
  data_out <- remove_taxa(
    input = input,
    x = data$Species
    )

  expect_equal(
    class(data_out),
    'character'
  )

  expect_equal(
    length(data$Species) - sum(use_i),
    length(data_out)
  )

})


testthat::test_that('Input can be character vector or data frame', {

  input <- 'Oncorhynchus tshawytscha'
  use_i <- data$Species == input

  # Character vector
  data_out <- remove_taxa(
    input = input,
    x = data$Species
  )
  expect_equal(
    length(data$Species) - sum(use_i),
    length(data_out)
  )

  # Data frame
  data_out <- remove_taxa(
    input = input,
    x = data,
    col = 'Species'
  )
  expect_equal(
    length(data$Species) - sum(use_i),
    length(data_out)
  )

})


