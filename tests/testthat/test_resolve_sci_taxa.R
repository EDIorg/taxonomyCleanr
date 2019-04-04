context('Resolve scientific taxa')
library(taxonomyCleanr)

# Parameterize ----------------------------------------------------------------

data <- utils::read.table(
  system.file('taxa_map.csv', package = 'taxonomyCleanr'),
  header = TRUE,
  sep = ',',
  as.is = TRUE
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

  output <- colnames(
    resolve_sci_taxa(
      x = 'Oncorhynchus tshawytscha',
      data.sources = 3
    )
  )

  expect_equal(
    all(
      output %in%
        c('index', 'taxa', 'taxa_clean', 'rank', 'authority',
          'authority_id', 'score')
    ),
    TRUE
  )

  output <- resolve_sci_taxa(
    x = 'Oncorhynchus tshawytscha',
    data.sources = 3
  )

  expect_equal(
    class(output),
    'data.frame'
  )

  output <- colnames(
    resolve_sci_taxa(
      path = path,
      data.sources = 3
    )
  )

  expect_equal(
    all(output %in%
          c('taxa_raw', 'taxa_trimmed', 'taxa_replacement', 'taxa_removed',
            'taxa_clean', 'rank', 'authority', 'authority_id', 'score',
            'difference')
    ),
    TRUE
  )

  expect_equal(
    class(resolve_sci_taxa(path = path, data.sources = 3)),
    'data.frame'
  )

  # COL

  output <- colnames(
    resolve_sci_taxa(
      x = 'Oncorhynchus tshawytscha',
      data.sources = 1
    )
  )

  expect_equal(
    all(
      output %in%
        c('index', 'taxa', 'taxa_clean', 'rank', 'authority',
          'authority_id', 'score')
    ),
    TRUE
  )

  expect_equal(
    class(
      resolve_sci_taxa(
        x = 'Oncorhynchus tshawytscha',
        data.sources = 1
      )
    ),
    'data.frame'
  )

  output <- colnames(
    resolve_sci_taxa(
      path = path,
      data.sources = 1
    )
  )

  expect_equal(
    all(
      output %in%
        c('taxa_raw', 'taxa_trimmed', 'taxa_replacement', 'taxa_removed',
          'taxa_clean', 'rank', 'authority', 'authority_id', 'score',
          'difference')
    ),
    TRUE
  )

  expect_equal(
    class(
      resolve_sci_taxa(
        path = path,
        data.sources = 1)
    ),
    'data.frame'
  )

  # WORMS

  output <- colnames(
    resolve_sci_taxa(
      x = 'Oncorhynchus tshawytscha',
      data.sources = 9
    )
  )

  expect_equal(
    all(
      output %in%
        c('index', 'taxa', 'taxa_clean', 'rank', 'authority',
          'authority_id', 'score')
    ),
    TRUE
  )

  expect_equal(
    class(
      resolve_sci_taxa(
        x = 'Oncorhynchus tshawytscha',
        data.sources = 9
      )
    ),
    'data.frame'
  )

  output <- colnames(
    resolve_sci_taxa(
      path = path,
      data.sources = 9
    )
  )

  expect_equal(all(
    output %in%
      c('taxa_raw', 'taxa_trimmed', 'taxa_replacement', 'taxa_removed',
        'taxa_clean', 'rank', 'authority', 'authority_id', 'score',
        'difference')
    ),
    TRUE
  )

  expect_equal(
    class(
      resolve_sci_taxa(
        path = path,
        data.sources = 9
      )
    ),
    'data.frame'
  )

  # GBIF

  output <- colnames(
    resolve_sci_taxa(
      x = 'Oncorhynchus tshawytscha',
      data.sources = 11
    )
  )

  expect_equal(
    all(
      output %in% c('index', 'taxa', 'taxa_clean', 'rank', 'authority',
                    'authority_id', 'score')
    ),
    TRUE
  )

  expect_equal(
    class(
      resolve_sci_taxa(
        x = 'Oncorhynchus tshawytscha',
        data.sources = 11
      )
    ),
    'data.frame'
  )

  output <- colnames(
    resolve_sci_taxa(
      path = path,
      data.sources = 11
    )
  )

  expect_equal(
    all(
      output %in%
        c('taxa_raw', 'taxa_trimmed', 'taxa_replacement', 'taxa_removed',
          'taxa_clean', 'rank', 'authority', 'authority_id', 'score',
          'difference')
    ),
    TRUE
  )

  expect_equal(
    class(
      resolve_sci_taxa(
        path = path,
        data.sources = 11
      )
    ),
    'data.frame'
  )

  # Tropicos

  output <- colnames(
    resolve_sci_taxa(
      x = 'Oncorhynchus tshawytscha',
      data.sources = 165
    )
  )

  expect_equal(
    all(
      output %in%
        c('index', 'taxa', 'taxa_clean', 'rank', 'authority',
          'authority_id', 'score')
    ),
    TRUE
  )

  expect_equal(
    class(
      resolve_sci_taxa(
        x = 'Oncorhynchus tshawytscha',
        data.sources = 165
      )
    ),
    'data.frame'
  )

  output <- colnames(
    resolve_sci_taxa(
      path = path,
      data.sources = 165
    )
  )

  expect_equal(
    all(
      output %in%
        c('taxa_raw', 'taxa_trimmed', 'taxa_replacement', 'taxa_removed',
          'taxa_clean', 'rank', 'authority', 'authority_id', 'score',
          'difference')
    ),
    TRUE
  )

  expect_equal(
    class(
      resolve_sci_taxa(
        path = path,
        data.sources = 165
      )
    ),
    'data.frame'
  )

})
