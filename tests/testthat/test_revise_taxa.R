context('Revise raw data')
library(taxonomyCleanr)

# Parameterize ----------------------------------------------------------------

# data <- utils::read.table(
#   system.file('taxa_map.csv', package = 'taxonomyCleanr'),
#   header = TRUE,
#   sep = ',',
#   as.is = TRUE
# )
# data <- data[!is.na(data$authority), ]
# data <- data[data$rank == 'Common', ]
# data <- data[data$authority == 'ITIS', ]
#
path <- system.file('test_data.txt', package = 'taxonomyCleanr')
path <- substr(path, 1, nchar(path) - 14)

# Tests -----------------------------------------------------------------------

# testthat::test_that('Expect errors', {
#
#   expect_error(revise_taxa(x = data))
#   expect_error(revise_taxa(path = path))
#   expect_error(revise_taxa(x = data, col = 'Species'))
#   expect_error(revise_taxa(x = data, col = 'Species', sep = ','))
#
# })

# testthat::test_that('Output table is standardized', {
#
#   #revise_taxa(path = path, data.sources = 3)
#   #revise_taxa(x = 'Yellow Perch', data.sources = 3)
#
# })
