context('Write taxa map')
library(taxonomyCleanr)

# Parameterize ----------------------------------------------------------------

data <- utils::read.table(
  system.file('taxa_map.csv', package = 'taxonomyCleanr'),
  header = TRUE,
  sep = ',',
  as.is = TRUE
)

path <- system.file('test_data.txt', package = 'taxonomyCleanr')
path <- substr(path, 1, nchar(path) - 14)

# Test ------------------------------------------------------------------------

testthat::test_that('Expect errors', {
  expect_error(write_taxa_map(x = data))
  expect_error(write_taxa_map(path = path))
})
