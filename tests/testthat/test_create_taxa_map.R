context('Initialize taxa_map.R')
library(taxonomyCleanr)

# Initialize test data --------------------------------------------------------

data <- read.table(
  paste0(
    path.package('taxonomyCleanr'),
    '/inst/test_data.txt'),
  header = TRUE,
  sep = '\t'
)

taxa_map <- suppressWarnings(create_taxa_map(x = data, col = 'Species'))

# Tests -----------------------------------------------------------------------

testthat::test_that('Return data frame', {

  expect_equal(
    class(taxa_map),
    'data.frame'
  )

})

testthat::test_that('Dimensions should agree', {

  expect_equal(
    dim(taxa_map),
    c(length(unique(data$Species)), ncol(taxa_map))
  )

})
