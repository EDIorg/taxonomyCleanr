context('Remove taxa')
library(taxonomyCleanr)

# Parameterize ----------------------------------------------------------------

data <- utils::read.table(
  system.file('test_data.txt', package = 'taxonomyCleanr'),
  header = TRUE,
  sep = '\t',
  as.is = T
)

path <- system.file('test_data.txt', package = 'taxonomyCleanr')
path <- substr(path, 1, nchar(path) - 14)

# Tests -----------------------------------------------------------------------

testthat::test_that('Generate errors', {
  expect_error(remove_taxa(input = 'Stipa sparteaaaaa', x = data,
                           col = 'Species'))
})

testthat::test_that('Data source is taxa_map.csv', {
  expect_equal(class(remove_taxa(input = 'Stipa spartea', path = path)),
               'data.frame')
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


