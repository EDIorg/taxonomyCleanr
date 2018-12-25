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
  expect_equal(colnames(resolve_sci_taxa(x = 'Oncorhynchus tshawytscha',
                                         data.sources = 3)),
               c('index', 'taxa', 'taxa_clean', 'rank', 'authority',
                 'authority_id', 'score'))
  expect_equal(class(resolve_sci_taxa(x = 'Oncorhynchus tshawytscha',
                                      data.sources = 3)),
               'data.frame')
  expect_equal(colnames(resolve_sci_taxa(path = path, data.sources = 3)),
               c('taxa_raw', 'taxa_trimmed', 'taxa_replacement', 'taxa_removed',
                 'taxa_clean', 'rank', 'authority', 'authority_id', 'score',
                 'difference'))
  expect_equal(class(resolve_sci_taxa(path = path, data.sources = 3)),
               'data.frame')

  # COL
  expect_equal(colnames(resolve_sci_taxa(x = 'Oncorhynchus tshawytscha',
                                         data.sources = 1)),
               c('index', 'taxa', 'taxa_clean', 'rank', 'authority',
                 'authority_id', 'score'))
  expect_equal(class(resolve_sci_taxa(x = 'Oncorhynchus tshawytscha',
                                      data.sources = 1)),
               'data.frame')
  expect_equal(colnames(resolve_sci_taxa(path = path, data.sources = 1)),
               c('taxa_raw', 'taxa_trimmed', 'taxa_replacement', 'taxa_removed',
                 'taxa_clean', 'rank', 'authority', 'authority_id', 'score',
                 'difference'))
  expect_equal(class(resolve_sci_taxa(path = path, data.sources = 1)),
               'data.frame')

  # WORMS
  expect_equal(colnames(resolve_sci_taxa(x = 'Oncorhynchus tshawytscha',
                                         data.sources = 9)),
               c('index', 'taxa', 'taxa_clean', 'rank', 'authority',
                 'authority_id', 'score'))
  expect_equal(class(resolve_sci_taxa(x = 'Oncorhynchus tshawytscha',
                                      data.sources = 9)),
               'data.frame')
  expect_equal(colnames(resolve_sci_taxa(path = path, data.sources = 9)),
               c('taxa_raw', 'taxa_trimmed', 'taxa_replacement', 'taxa_removed',
                 'taxa_clean', 'rank', 'authority', 'authority_id', 'score',
                 'difference'))
  expect_equal(class(resolve_sci_taxa(path = path, data.sources = 9)),
               'data.frame')

  # GBIF
  expect_equal(colnames(resolve_sci_taxa(x = 'Oncorhynchus tshawytscha',
                                         data.sources = 11)),
               c('index', 'taxa', 'taxa_clean', 'rank', 'authority',
                 'authority_id', 'score'))
  expect_equal(class(resolve_sci_taxa(x = 'Oncorhynchus tshawytscha',
                                      data.sources = 11)),
               'data.frame')
  expect_equal(colnames(resolve_sci_taxa(path = path, data.sources = 11)),
               c('taxa_raw', 'taxa_trimmed', 'taxa_replacement', 'taxa_removed',
                 'taxa_clean', 'rank', 'authority', 'authority_id', 'score',
                 'difference'))
  expect_equal(class(resolve_sci_taxa(path = path, data.sources = 11)),
               'data.frame')

  # Tropicos
  expect_equal(colnames(resolve_sci_taxa(x = 'Oncorhynchus tshawytscha',
                                         data.sources = 165)),
               c('index', 'taxa', 'taxa_clean', 'rank', 'authority',
                 'authority_id', 'score'))
  expect_equal(class(resolve_sci_taxa(x = 'Oncorhynchus tshawytscha',
                                      data.sources = 165)),
               'data.frame')
  expect_equal(colnames(resolve_sci_taxa(path = path, data.sources = 165)),
               c('taxa_raw', 'taxa_trimmed', 'taxa_replacement', 'taxa_removed',
                 'taxa_clean', 'rank', 'authority', 'authority_id', 'score',
                 'difference'))
  expect_equal(class(resolve_sci_taxa(path = path, data.sources = 165)),
               'data.frame')

})
