context('Resolve scientific taxa')
library(taxonomyCleanr)

# Parameterize ----------------------------------------------------------------

data <- data.table::fread(
  file = system.file('/taxa_map_resolve_sci_taxa/taxa_map.csv', package = 'taxonomyCleanr'),
  fill = TRUE,
  blank.lines.skip = TRUE
)
data <- data[!is.na(data$authority), ]
data <- data[data$rank != 'Common', ]
data <- data[1:3, ]

path <- system.file('/taxa_map_resolve_sci_taxa/taxa_map.csv', package = 'taxonomyCleanr')
path <- substr(path, 1, nchar(path) - 13)

# Tests -----------------------------------------------------------------------

testthat::test_that('Expect errors', {

  expect_error(resolve_sci_taxa(data.sources = 3))
  expect_error(resolve_sci_taxa(x = 'Yellow Perch'))
  expect_error(resolve_sci_taxa(path = path))

})

testthat::test_that('Output table is standardized', {

  # ITIS

  output <- resolve_sci_taxa(
    x = 'Oncorhynchus tshawytscha',
    data.sources = 3
  )

  expect_equal(
    all(
      colnames(output) %in%
        c('index', 'taxa', 'taxa_clean', 'rank', 'authority',
          'authority_id', 'score')
    ),
    TRUE
  )

  expect_equal(
    class(output),
    'data.frame'
  )

  # output <- resolve_sci_taxa(
  #   path = path,
  #   data.sources = 3
  # )
  #
  # expect_equal(
  #   all(colnames(output) %in%
  #         c('taxa_raw', 'taxa_trimmed', 'taxa_replacement', 'taxa_removed',
  #           'taxa_clean', 'rank', 'authority', 'authority_id', 'score',
  #           'difference')
  #   ),
  #   TRUE
  # )

  # COL

  output <- resolve_sci_taxa(
    x = 'Oncorhynchus tshawytscha',
    data.sources = 1
  )

  expect_equal(
    all(
      colnames(output) %in%
        c('index', 'taxa', 'taxa_clean', 'rank', 'authority',
          'authority_id', 'score')
    ),
    TRUE
  )

  expect_equal(
    class(
      output
    ),
    'data.frame'
  )

  # output <- resolve_sci_taxa(
  #   path = path,
  #   data.sources = 1
  # )
  #
  # expect_equal(
  #   all(
  #     colnames(output) %in%
  #       c('taxa_raw', 'taxa_trimmed', 'taxa_replacement', 'taxa_removed',
  #         'taxa_clean', 'rank', 'authority', 'authority_id', 'score',
  #         'difference')
  #   ),
  #   TRUE
  # )
  #
  # expect_equal(
  #   class(output),
  #   'data.frame'
  # )

  # WORMS

  output <- resolve_sci_taxa(
    x = 'Oncorhynchus tshawytscha',
    data.sources = 9
  )

  expect_equal(
    all(
      colnames(output) %in%
        c('index', 'taxa', 'taxa_clean', 'rank', 'authority',
          'authority_id', 'score')
    ),
    TRUE
  )

  expect_equal(
    class(output),
    'data.frame'
  )

  # output <- resolve_sci_taxa(
  #   path = path,
  #   data.sources = 9
  # )
  #
  # expect_equal(all(
  #   colnames(output) %in%
  #     c('taxa_raw', 'taxa_trimmed', 'taxa_replacement', 'taxa_removed',
  #       'taxa_clean', 'rank', 'authority', 'authority_id', 'score',
  #       'difference')
  #   ),
  #   TRUE
  # )
  #
  # expect_equal(
  #   class(
  #     output
  #   ),
  #   'data.frame'
  # )

  # GBIF

  output <- resolve_sci_taxa(
    x = 'Oncorhynchus tshawytscha',
    data.sources = 11
  )

  expect_equal(
    all(
      colnames(output) %in% c('index', 'taxa', 'taxa_clean', 'rank', 'authority',
                    'authority_id', 'score')
    ),
    TRUE
  )

  expect_equal(
    class(output),
    'data.frame'
  )

  # output <- resolve_sci_taxa(
  #   path = path,
  #   data.sources = 11
  # )
  #
  # expect_equal(
  #   all(
  #     colnames(output) %in%
  #       c('taxa_raw', 'taxa_trimmed', 'taxa_replacement', 'taxa_removed',
  #         'taxa_clean', 'rank', 'authority', 'authority_id', 'score',
  #         'difference')
  #   ),
  #   TRUE
  # )
  #
  # expect_equal(
  #   class(output),
  #   'data.frame'
  # )

  # Tropicos

  output <- resolve_sci_taxa(
    x = 'Oncorhynchus tshawytscha',
    data.sources = 165
  )

  expect_equal(
    all(
      colnames(output) %in%
        c('index', 'taxa', 'taxa_clean', 'rank', 'authority',
          'authority_id', 'score')
    ),
    TRUE
  )

  expect_equal(
    class(output),
    'data.frame'
  )

  # output <- resolve_sci_taxa(
  #   path = path,
  #   data.sources = 165
  # )
  #
  # expect_equal(
  #   all(
  #     colnames(output) %in%
  #       c('taxa_raw', 'taxa_trimmed', 'taxa_replacement', 'taxa_removed',
  #         'taxa_clean', 'rank', 'authority', 'authority_id', 'score',
  #         'difference')
  #   ),
  #   TRUE
  # )
  #
  # expect_equal(
  #   class(output),
  #   'data.frame'
  # )

})
