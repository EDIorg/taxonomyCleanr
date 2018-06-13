context('Trim excess characters from raw taxon string')
library(taxonomyCleanr)

# Trim white space ------------------------------------------------------------

testthat::test_that('trim_taxa_str removes white spaces', {

  # Leading white space

  expect_equal(
    trim_taxa_str(
      ' Genus'
      ),
    'Genus'
    )

  # Trailing white space

  expect_equal(
    trim_taxa_str(
      'Genus '
      ),
    'Genus'
    )

  # Leading & trailing white space in vector

  expect_equal(
    trim_taxa_str(
      c(
        ' Genus',
        'Genus '
        )
      ),
    c(
      'Genus',
      'Genus'
      )
    )

})

# Remove rank abbreviations ---------------------------------------------------

testthat::test_that('trim_taxa_str removes rank abbreviations', {

  # Species

  expect_equal(
    trim_taxa_str(
      'Genus Sp.'
    ),
    'Genus'
  )

  expect_equal(
    trim_taxa_str(
      'Genus  Sp.'
    ),
    'Genus'
  )

  expect_equal(
    trim_taxa_str(
      'Genus Spp.'
    ),
    'Genus'
  )

  expect_equal(
    trim_taxa_str(
      'Genus sp.'
    ),
    'Genus'
  )

  expect_equal(
    trim_taxa_str(
      c(
        'Genus sp.',
        'Genus ssp.')
    ),
    c(
      'Genus',
      'Genus'
      )
  )

})
