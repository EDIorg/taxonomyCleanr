context('Trim excess characters from raw taxon string')
library(taxonomyCleanr)

# Parameterize ----------------------------------------------------------------

data <- data.table::fread(
  file = system.file('taxa_map.csv', package = 'taxonomyCleanr'),
  fill = TRUE,
  blank.lines.skip = TRUE
)
path <- system.file('taxa_map.csv', package = 'taxonomyCleanr')
path <- substr(path, 1, nchar(path) - 13)

# Trim white space ------------------------------------------------------------

testthat::test_that('Removes white spaces.', {

  # Leading white space

  expect_equal(
    trim_taxa(
      x = ' Genus'
      ),
    'Genus'
    )

  # Trailing white space

  expect_equal(
    trim_taxa(
      x = 'Genus '
      ),
    'Genus'
    )

  # Leading & trailing white space in vector

  expect_equal(
    trim_taxa(
      x = c(
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
    trim_taxa(
      x = c(
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
    trim_taxa(
      x = c(
        'Genus_species',
        'Genus_species_',
        '_Genus_species_'
        )
      ),
      c(
        'Genus species',
        'Genus species',
        'Genus species'
        )
    )

})

# testthat::test_that('Input taxa_map.txt', {
#
#   expect_true(
#     all(
#       class(trim_taxa(path = path)) %in%
#         c("data.frame", "data.table")
#     )
#   )
#   expect_equal(colnames(trim_taxa(path = path)),
#                c('taxa_raw', 'taxa_trimmed', 'taxa_replacement', 'taxa_removed',
#                  'taxa_clean', 'rank', 'authority', 'authority_id', 'score',
#                  'difference'))
# })


