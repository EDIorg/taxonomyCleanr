context('Get taxa classifications')
library(taxonomyCleanr)

# Initialize test data --------------------------------------------------------

data <- utils::read.table(
  system.file('/taxa_map_resolve_sci_taxa/taxa_map.csv', package = 'taxonomyCleanr'),
  header = TRUE,
  sep = ',',
  as.is = TRUE
)
data <- data[!is.na(data$authority), ]
data <- data[!data$rank == 'Common', ]
data <- data[data$authority == 'ITIS', ]

path <- system.file('test_data.txt', package = 'taxonomyCleanr')
path <- substr(path, 1, nchar(path) - 14)

taxclass <- get_classification(taxa.clean = data$taxa_clean[1],
                               authority = data$authority[1],
                               authority.id = as.numeric(data$authority_id[1]))

# Tests -----------------------------------------------------------------------

# Test output attributes
testthat::test_that('Return list', {
  expect_equal(
    class(get_classification(
      taxa.clean = data$taxa_clean[1],
      authority = data$authority[1],
      authority.id = as.numeric(data$authority_id[1]))),
    'list')
})
testthat::test_that('List should be data frame', {
  expect_equal(class(taxclass[[1]]), 'data.frame')
})

