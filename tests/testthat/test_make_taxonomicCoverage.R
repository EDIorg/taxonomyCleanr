context('Create taxonomicCoverage EML')
library(taxonomyCleanr)
library(EML103)

# Initialize test data --------------------------------------------------------

data <- utils::read.table(
  system.file('taxa_map.csv', package = 'taxonomyCleanr'),
  header = TRUE,
  sep = ',',
  as.is = TRUE
)

path <- system.file('test_data.txt', package = 'taxonomyCleanr')
path <- substr(path, 1, nchar(path) - 14)

taxcov <- EML103::read_eml(system.file('taxonomicCoverage.xml',
                                    package = 'taxonomyCleanr'))

# Tests -----------------------------------------------------------------------

testthat::test_that('Classification should be taxonomicCoverage', {
  expect_equal(class(make_taxonomicCoverage(taxa.clean = data$taxa_clean,
                                      authority = data$authority,
                                      authority.id = data$authority_id))[1],
               class(taxcov)[1])
})

testthat::test_that('Classification should match from path source', {
  expect_equal(class(make_taxonomicCoverage(path = path))[1],
               class(taxcov)[1])
})
