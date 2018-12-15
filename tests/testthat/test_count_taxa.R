context('Count and report unique taxa')
library(taxonomyCleanr)

# Parameterize ----------------------------------------------------------------

data <- utils::read.table(
  system.file('test_data.txt', package = 'taxonomyCleanr'),
  header = TRUE,
  sep = '\t',
  as.is = T
)

counts <- count_taxa(x = data, col = 'Species')

path <- system.file('test_data.txt', package = 'taxonomyCleanr')
path <- substr(path, 1, nchar(path) - 14)

# Tests -----------------------------------------------------------------------

# Generate errors
testthat::test_that('Expect errors', {
  expect_error(count_taxa(col = 'Species'))
  #expect_error(count_taxa(x = c(1,2,3,4,5), col = 'Species'))
  expect_error(count_taxa(x = data))
  expect_error(count_taxa(x = data, col = 'Species', path = path))
})

# Input argument "x" is a data frame
testthat::test_that('Output data.frame', {
  expect_equal(class(counts), 'data.frame')
  expect_equal(dim(counts), c(length(unique(data$Species)), ncol(counts)))
})

# Input argument "x" is a vector of character strings
testthat::test_that('Input is vector of character strings', {
  expect_equal(nrow(count_taxa(x = data$Species)),
               length(unique(data$Species)))
})


