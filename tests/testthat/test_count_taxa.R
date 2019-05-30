context('Count and report unique taxa')
library(taxonomyCleanr)

# Parameterize ----------------------------------------------------------------

data <- utils::read.table(
  system.file('test_data.txt', package = 'taxonomyCleanr'),
  header = TRUE,
  sep = '\t',
  as.is = T
)

taxa_map <- utils::read.table(
  system.file('/taxa_map_resolve_sci_taxa/taxa_map.csv', package = 'taxonomyCleanr'),
  header = TRUE,
  sep = ',',
  as.is = T
)

counts <- count_taxa(x = data, col = 'Species')

path <- system.file('test_data.txt', package = 'taxonomyCleanr')
path <- substr(path, 1, nchar(path) - 14)

# Tests -----------------------------------------------------------------------

# Generate errors
testthat::test_that('Expect errors', {
  expect_error(count_taxa(col = 'Species'))
  expect_error(count_taxa(x = data))
  expect_error(count_taxa(x = as.matrix(data), col = 'Species'))
})

# Test outputs
testthat::test_that('Output data.frame', {
  expect_equal(class(counts), 'data.frame')
  expect_equal(dim(counts), c(length(unique(data$Species)), ncol(counts)))
})

# Input argument "x" is a vector of character strings
testthat::test_that('Input is vector of character strings', {
  expect_equal(nrow(count_taxa(x = data$Species)),
               length(unique(data$Species)))
})

# taxa_map.txt is the input data
testthat::test_that('Count taxa_map.txt is supported', {
  expect_equal(class(count_taxa(x = data, col = 'Species', path = path)),
               'data.frame')
})
