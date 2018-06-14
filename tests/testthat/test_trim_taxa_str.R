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

  # Common species abbreviations at the genus level

  expect_equal(
    trim_taxa_str(
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
