context('Initialize table for cleaning taxa')
library(taxonomyCleanr)

# Initialize test data ----------------------------------------------------

data <- data.frame(
  taxa = c(
    'taxa 1',
    'taxa 2',
    'taxa 3',
    'taxa 3'
    ),
  count = c(
    2,
    4,
    5,
    4
    ),
  stringsAsFactors = F
  )

dim_data <- c(
  length(
    unique(
      data$taxa
      )
    ),
  10
  )

# Test dimensions ---------------------------------------------------------

testthat::test_that('Test dimensions', {

  expect_equal(
    dim(
      create_taxa_map(
        x = data,
        col = 'taxa'
        )
      ),
    dim_data
    )

  })

