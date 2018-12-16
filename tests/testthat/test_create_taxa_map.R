context('Initialize taxa_map.R')
library(taxonomyCleanr)

# Initialize test data --------------------------------------------------------

data <- utils::read.table(
  system.file('test_data.txt', package = 'taxonomyCleanr'),
  header = TRUE,
  sep = '\t',
  as.is = TRUE
)

taxa_map <- suppressWarnings(create_taxa_map(x = data, col = 'Species'))

path <- system.file('test_data.txt', package = 'taxonomyCleanr')
path <- substr(path, 1, nchar(path) - 14)

# Tests -----------------------------------------------------------------------

testthat::test_that('Return data frame', {
  expect_equal(class(taxa_map), 'data.frame')
})

testthat::test_that('Dimensions should agree', {
  expect_equal(dim(taxa_map),c(length(unique(data$Species)), ncol(taxa_map)))
})

# Generate errors
testthat::test_that('Expect errors', {
  expect_error(create_taxa_map(path = path, x = data))
  expect_error(create_taxa_map(path = path, col = 'Species'))
})
