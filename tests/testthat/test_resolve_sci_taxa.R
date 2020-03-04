context('Resolve scientific taxa')
library(taxonomyCleanr)

# Parameterize ----------------------------------------------------------------

data <- data.table::fread(
  system.file('test_data.txt', package = 'taxonomyCleanr'))

# Input arguments -------------------------------------------------------------

testthat::test_that('Expect errors', {

  expect_error(resolve_sci_taxa(data.sources = 3))
  expect_error(resolve_sci_taxa(x = 'Yellow Perch'))
  expect_error(resolve_sci_taxa(path = tempdir()))

})

# Standardized output ---------------------------------------------------------

testthat::test_that('Output table is standardized', {

  # Create helper function to check output format

  check_output_table <- function(taxa, data.source, path = NULL) {

    r <- resolve_sci_taxa(
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

  check_output_table("Oncorhynchus tshawytscha", data.source = 3)
  # check_output_table("Oncorhynchus tshawytscha", data.source = 1)
  check_output_table("Oncorhynchus tshawytscha", data.source = 9)
  check_output_table("Oncorhynchus tshawytscha", data.source = 11)
  check_output_table("Oncorhynchus tshawytscha", data.source = 165)

})
