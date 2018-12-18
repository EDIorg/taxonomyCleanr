context('Create taxonomicCoverage EML')
library(taxonomyCleanr)
library(EML)

# Initialize test data --------------------------------------------------------

data <- utils::read.table(
  system.file('taxa_map.csv', package = 'taxonomyCleanr'),
  header = TRUE,
  sep = ',',
  as.is = TRUE
)
data <- data[!is.na(data$authority), ]
data <- data[!data$rank == 'Common', ]
data <- data[data$authority == 'ITIS', ]

path <- system.file('test_data.txt', package = 'taxonomyCleanr')
path <- substr(path, 1, nchar(path) - 14)

taxcov <- read_eml(system.file('taxonomicCoverage.xml',
                               package = 'taxonomyCleanr'))

# Tests -----------------------------------------------------------------------

testthat::test_that('Classification should be taxonomicCoverage', {
  expect_equal(class(make_taxonomicCoverage(taxa.clean = data$taxa_clean[1],
                                      authority = data$authority[1],
                                      authority.id = data$authority_id[1]))[1],
               class(taxcov)[1])
})

