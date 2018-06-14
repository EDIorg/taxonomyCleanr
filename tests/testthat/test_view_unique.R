context('View unique taxa with frequency')
library(taxonomyCleanr)

# Trim white space ------------------------------------------------------------

testthat::test_that('view_unique creates a human readable table', {

  expect_equal(
    class(
      view_unique(
        c(
          'Taxa 1',
          'Taxa 2',
          'Taxa 1'
          )
        )
      ),
    class(table(
      c(
        'Taxa 1',
        'Taxa 2',
        'Taxa 1'
        )
      )
    )
  )

})

