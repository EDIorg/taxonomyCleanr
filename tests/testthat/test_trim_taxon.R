context('Trim excess characters from raw taxon string')
library(taxonomyCleanr)

# Trim white space ------------------------------------------------------------

testthat::test_that('Removes white spaces.', {

  # Leading white space

  expect_equal(
    trim_taxon(
      ' Genus'
      ),
    'Genus'
    )

  # Trailing white space

  expect_equal(
    trim_taxon(
      'Genus '
      ),
    'Genus'
    )

  # Leading & trailing white space in vector

  expect_equal(
    trim_taxon(
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

testthat::test_that('Removes rank abbreviations.', {

  # Common species abbreviations at the genus level

  expect_equal(
    trim_taxon(
      c(
        'Genus S',
        'Genus S.',
        'Genus S..',
        'Genus Sp',
        'Genus Sp.',
        'Genus S.p.',
        'Genus Sp..',
        'Genus Spp',
        'Genus   Spp.',
        'Genus Sp.p.',
        'Genus S.p.p.',
        'Genus C',
        'Genus C.',
        'Genus C..',
        'Genus Cf',
        'Genus Cf.',
        'Genus C.f.',
        'Genus Cf..',
        'Genus    Cff',
        'Genus Cff.',
        'Genus Cf.f.',
        'Genus C.f.f.',
        'Genus species'
        )
      ),
    c(
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus',
      'Genus species'
      )
    )

})

# Replace underscores with spaces ---------------------------------------------

testthat::test_that('Replaces underscores with spaces.', {

  expect_equal(
    trim_taxon(
      'Genus_species',
      'Genus_species_',
      '_Genus_species_'
    ),
    'Genus species',
    'Genus species',
    'Genus species'
  )

})
