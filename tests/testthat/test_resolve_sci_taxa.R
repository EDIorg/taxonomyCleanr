context('Resolve scientific taxa')
library(taxonomyCleanr)

# Parameterize ----------------------------------------------------------------

data <- data.table::fread(
  system.file('test_data.txt', package = 'taxonomyCleanr'))

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

# Only try unresolved items in taxa_map.csv -----------------------------------
# The example dataset has a minority of marine taxa. First, pass example data
# to WORMS and index rows where authority is "WORMS" and authority_id is
# present. Second, pass the data to ITIS (which would normally resolve the marine
# taxa and overwrite their entries in taxa map) and index the rows where
# authority is "ITIS" and authority_id is present. Then compare the indexed
# rows and expect no overlap.

testthat::test_that("Only try unresolved items in taxa_map.csv", {

  tm <- create_taxa_map(path = tempdir(), x = data, col = "Species")
  r <- resolve_sci_taxa(path = tempdir(), data.sources = 9)
  i_worms <- seq(nrow(r))[
    (r$authority == "World Register of Marine Species") &
      (!is.na(r$authority_id))]
  r <- resolve_sci_taxa(path = tempdir(), data.sources = 3)
  i_itis <- seq(nrow(r))[
    (r$authority == "ITIS") & (!is.na(r$authority_id))]

  expect_true(!any(i_worms %in% i_itis))

})
