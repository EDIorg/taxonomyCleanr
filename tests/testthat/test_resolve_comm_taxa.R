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

  expect_equal(colnames(resolve_comm_taxa(x = 'Yellow Perch', data.sources = 3)),
               c('index', 'taxa', 'taxa_clean', 'rank', 'authority', 'authority_id'))
  expect_equal(class(resolve_comm_taxa(x = 'Yellow Perch', data.sources = 3)),
               'data.frame')

  # resolve_comm_taxa(path = path, data.sources = 3)

})
