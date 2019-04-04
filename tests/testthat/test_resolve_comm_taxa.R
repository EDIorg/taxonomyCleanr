context('Resolve common taxa')
library(taxonomyCleanr)

# Parameterize ----------------------------------------------------------------

data <- utils::read.table(
  system.file('taxa_map.csv', package = 'taxonomyCleanr'),
  header = TRUE,
  sep = ',',
  as.is = TRUE
)
data <- data[!is.na(data$authority), ]
data <- data[data$rank == 'Common', ]
data <- data[data$authority == 'ITIS', ]

path <- system.file('test_data.txt', package = 'taxonomyCleanr')
path <- substr(path, 1, nchar(path) - 14)

# Tests -----------------------------------------------------------------------

testthat::test_that('Expect errors', {

  expect_error(resolve_comm_taxa(data.sources = 3))
  expect_error(resolve_comm_taxa(x = 'Yellow Perch'))
  expect_error(resolve_comm_taxa(path = path))

})

testthat::test_that('Output table is standardized', {

  # ITIS

  output <- colnames(
    resolve_comm_taxa(
      x = 'Yellow Perch',
      data.sources = 3
    )
  )

  expect_equal(
    all(
      output %in%
        c('index', 'taxa', 'taxa_clean', 'rank', 'authority','authority_id')
    ),
    TRUE
  )

  output <- resolve_comm_taxa(
    x = 'Yellow Perch',
    data.sources = 3
  )

  expect_equal(
    class(output),
    'data.frame'
  )

  output <- colnames(
    resolve_comm_taxa(
      data.sources = 3,
      path = path
    )
  )

  expect_equal(
    all(
      output %in%
        c('taxa_raw', 'taxa_trimmed', 'taxa_replacement', 'taxa_removed',
          'taxa_clean', 'rank', 'authority', 'authority_id', 'score',
          'difference'
        )
    ),
    TRUE
  )

})
