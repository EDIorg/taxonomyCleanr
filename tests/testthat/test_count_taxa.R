context('Count unique taxa')
library(taxonomyCleanr)

# Parameterize ----------------------------------------------------------------

data <- read.table(
  system.file('test_data.txt', package = 'taxonomyCleanr'),
  header = T,
  sep = '\t'
  )

# Trim white space ------------------------------------------------------------

testthat::test_that('A data frame input creates a data frame output', {

  expect_equal(
    class(
      count_taxa(
        x = data,
        col = 'Species'
        )
      ),
    'data.frame'
    )

  expect_equal(
    colnames(
      count_taxa(
        x = data,
        col = 'Species'
      )
    ),
    c('Taxa', 'Count')
  )

})

