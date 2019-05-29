context('Create taxonomicCoverage EML')
library(taxonomyCleanr)
library(EML)

# Parameterize ----------------------------------------------------------------

data <- utils::read.table(
  system.file('taxa_map.csv', package = 'taxonomyCleanr'),
  header = TRUE,
  sep = ',',
  as.is = TRUE)
path <- system.file('test_data.txt', package = 'taxonomyCleanr')
path <- substr(path, 1, nchar(path) - 14)
taxcov <- EML::read_eml(
  system.file('taxonomicCoverage.xml', package = 'taxonomyCleanr'))

# Write to path ---------------------------------------------------------------

testthat::test_that('Write to path', {

  # write.file = TRUE requires a valid path
  expect_error(
    suppressMessages(
      make_taxonomicCoverage(
        taxa.clean = data$taxa_clean,
        authority = data$authority,
        authority.id = data$authority_id,
        write.file = TRUE)))

  # Make function call
  output <- suppressMessages(
    make_taxonomicCoverage(
      taxa.clean = data$taxa_clean,
      authority = data$authority,
      authority.id = data$authority_id,
      path = tempdir(),
      write.file = TRUE))

  # File type is .xml
  expect_true(
    'taxonomicCoverage.xml' %in% list.files(tempdir()))

  # Reading taxonomicCoverage.xml creates an object of class 'emld' 'list'
  expect_true(
    all(class(EML::read_eml(paste0(tempdir(), '/taxonomicCoverage.xml'))) %in%
      c('emld', 'list')))

})

# Output object ---------------------------------------------------------------

testthat::test_that('Output object', {

  # Output object class is a list
  expect_equal(
    suppressMessages(
      class(make_taxonomicCoverage(
        taxa.clean = data$taxa_clean,
        authority = data$authority,
        authority.id = data$authority_id,
        write.file = FALSE))),
      'list')

})
