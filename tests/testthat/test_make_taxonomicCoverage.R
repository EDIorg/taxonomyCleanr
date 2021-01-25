context('Create taxonomicCoverage EML')
library(taxonomyCleanr)
library(EML)

# Parameterize ----------------------------------------------------------------

# Remove any test files existing in tempdir()
unlink(
  c(paste0(tempdir(), "/taxa_map.csv"),
    paste0(tempdir(), "/taxonomicCoverage.xml")),
  recursive = TRUE,
  force = TRUE)

# Use a random subset of the data
data <- data.table::fread(
  file = system.file(
    '/taxa_map_resolve_sci_taxa/taxa_map.csv',
    package = 'taxonomyCleanr'),
  fill = TRUE,
  blank.lines.skip = TRUE)
data <- data[sample(nrow(data), nrow(data)/2), ]

# Arguments -------------------------------------------------------------------

testthat::test_that('Arguments', {

  # write.file = TRUE requires a valid path

  expect_error(
    suppressMessages(
      make_taxonomicCoverage(
        taxa.clean = data$taxa_clean,
        authority = data$authority,
        authority.id = data$authority_id,
        write.file = TRUE)))

})

# Input is a list of names ----------------------------------------------------

testthat::test_that('Input is a list of names', {

  # Supported authorities

  r <- make_taxonomicCoverage(
    taxa.clean = "Oncorhynchus tshawytscha",
    authority = "WORMS",
    authority.id = "161980",
    path = tempdir(),
    write.file = TRUE)

  expect_true('taxonomicCoverage.xml' %in% list.files(tempdir()))
  expect_true(length(r$taxonomicClassification) == 1)

  unlink(
    paste0(tempdir(), "/taxonomicCoverage.xml"),
    recursive = TRUE,
    force = TRUE)

  # Unsupported authorities

  r <- make_taxonomicCoverage(
    taxa.clean = "Oncorhynchus tshawytscha",
    authority = "THE authority",
    authority.id = "some-id",
    path = tempdir(),
    write.file = TRUE)

  expect_true('taxonomicCoverage.xml' %in% list.files(tempdir()))
  expect_true(length(r$taxonomicClassification) == 1)

  unlink(
    paste0(tempdir(), "/taxonomicCoverage.xml"),
    recursive = TRUE,
    force = TRUE)

})

# Input is taxa_map -----------------------------------------------------------

testthat::test_that('Input is taxa_map', {

  file.copy(
    system.file(
      '/taxa_map_resolve_sci_taxa/taxa_map.csv',
      package = 'taxonomyCleanr'),
    tempdir())

  data <- read_taxa_map(tempdir())

  r <- suppressMessages(
    make_taxonomicCoverage(
      path = tempdir(),
      write.file = TRUE))

  expect_true('taxonomicCoverage.xml' %in% list.files(tempdir()))
  expect_true(length(r$taxonomicClassification) == nrow(data))

  unlink(
    c(paste0(tempdir(), "/taxa_map.csv"),
      paste0(tempdir(), "/taxonomicCoverage.xml")),
    recursive = TRUE,
    force = TRUE)

})

