context('Count and report unique taxa')
library(taxonomyCleanr)

# Parameterize ----------------------------------------------------------------

data <- utils::read.table(
  system.file('test_data.txt', package = 'taxonomyCleanr'),
  header = TRUE,
  sep = '\t'
)

counts <- count_taxa(
  x = data,
  col = 'Species'
)

# Tests -----------------------------------------------------------------------

testthat::test_that('Output data.frame', {

  expect_equal(
    class(counts),
    'data.frame'
  )

  expect_equal(
    dim(counts),
    c(length(unique(data$Species)), ncol(counts))
  )

})


