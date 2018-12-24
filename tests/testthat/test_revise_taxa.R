context('Revise raw data')
library(taxonomyCleanr)

# Parameterize ----------------------------------------------------------------

data <- utils::read.table(
  system.file('test_data.txt', package = 'taxonomyCleanr'),
  header = TRUE,
  sep = '\t',
  as.is = TRUE
)

path <- system.file('taxa_map.csv', package = 'taxonomyCleanr')
path <- substr(path, 1, nchar(path) - 13)

# Tests -----------------------------------------------------------------------

testthat::test_that('Expect errors', {

  expect_error(revise_taxa(x = data))
  expect_error(revise_taxa(path = path))
  expect_error(revise_taxa(x = data, col = 'Species'))
  expect_error(revise_taxa(x = data, col = 'Species', sep = ','))

})

testthat::test_that('Output table is standardized', {

  expect_equal(class(revise_taxa(path = path, x = data, col = 'Species',
                                 sep = ',')),
               'data.frame')
  expect_equal(colnames(revise_taxa(path = path, x = data,
                                    col = 'Species', sep = ',')),
               c('Year', 'Sample_Date', 'Plot', 'Heat_Treatment', 'Species',
                 'Mass', 'taxa_clean', 'taxa_rank', 'taxa_authority',
                 'taxa_authority_id'))
})
