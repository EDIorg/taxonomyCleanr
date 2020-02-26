context('Write taxa map')
library(taxonomyCleanr)

# Parameterize ----------------------------------------------------------------

data <- data.table::fread(
  file = system.file('taxa_map.csv', package = 'taxonomyCleanr'),
  fill = TRUE,
  blank.lines.skip = TRUE
)
path <- system.file('test_data.txt', package = 'taxonomyCleanr')
path <- substr(path, 1, nchar(path) - 14)

# Test ------------------------------------------------------------------------

testthat::test_that('Expect errors', {
  expect_error(write_taxa_map(x = data))
  expect_error(write_taxa_map(path = path))
})
