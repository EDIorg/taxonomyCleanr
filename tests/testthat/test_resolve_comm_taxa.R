context('Resolve common taxa')
library(taxonomyCleanr)

# Parameterize ----------------------------------------------------------------

data <- data.table::fread(
  system.file('test_data.txt', package = 'taxonomyCleanr'))

# Input arguments -------------------------------------------------------------

testthat::test_that('Expect errors', {

  expect_error(resolve_comm_taxa(data.sources = 3))
  expect_error(resolve_comm_taxa(x = 'Yellow Perch'))
  expect_error(resolve_comm_taxa(path = path))

})

testthat::test_that('Output table is standardized', {

  # Create helper function to check output format

  check_output_table <- function(taxa, data.source, path = NULL) {

    r <- resolve_comm_taxa(
      x = taxa,
      data.sources = data.source)

    expect_equal(
      class(r),
      'data.frame')

    expect_true(
      all(
        colnames(r) %in%
          c('index', 'taxa', 'taxa_clean', 'rank', 'authority',
            'authority_id', 'score')))

  }

  # Check outputs of accepted sources

  check_output_table("King salmon", data.source = 3)

})
