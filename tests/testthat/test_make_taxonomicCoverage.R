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

  # Call with list of taxa

  r <- suppressMessages(
    make_taxonomicCoverage(
      taxa.clean = data$taxa_raw,
      authority = data$authority,
      authority.id = data$authority_id,
      path = tempdir(),
      write.file = TRUE))

  expect_true('taxonomicCoverage.xml' %in% list.files(tempdir()))
  expect_true(length(r$taxonomicClassification) == nrow(data))

  # Unresolved taxa are included in the output

  if (any(is.na(data$taxa_clean))) {
    unresolvable_taxa <- which(is.na(data$taxa_clean))
    for (i in unresolvable_taxa) {
      expect_true(r$taxonomicClassification[[i]]$taxonRankName == "unknown")
      expect_true(r$taxonomicClassification[[i]]$taxonRankValue ==
                    data[unresolvable_taxa, "taxa_raw"])
      expect_true(
        is.na(r$taxonomicClassification[[i]]$taxonId$provider))
      expect_true(
        is.na(r$taxonomicClassification[[i]]$taxonId$taxonId))
      expect_true(
        length(r$taxonomicClassification[[i]]$commonName) == 0)
    }
  }

  # Resolved taxa have expected content. Only checking the first level.

  resolvable_taxa <- which(!is.na(data$taxa_clean))
  for (i in resolvable_taxa) {
    expect_true(is.character(r$taxonomicClassification[[i]]$taxonRankName))
    expect_true(is.character(r$taxonomicClassification[[i]]$taxonRankValue))
    expect_true(is.character(r$taxonomicClassification[[i]]$taxonId$provider))
    expect_true(is.character(r$taxonomicClassification[[i]]$taxonId$taxonId))
    expect_true(is.character(r$taxonomicClassification[[i]]$commonName[[1]]))
  }

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

  # Unresolved taxa are included in the output

  if (any(is.na(data$taxa_clean))) {
    unresolvable_taxa <- which(is.na(data$taxa_clean))
    for (i in unresolvable_taxa) {
      expect_true(r$taxonomicClassification[[i]]$taxonRankName == "unknown")
      expect_true(r$taxonomicClassification[[i]]$taxonRankValue ==
                    data[unresolvable_taxa, "taxa_raw"])
      expect_true(
        is.na(r$taxonomicClassification[[i]]$taxonId$provider))
      expect_true(
        is.na(r$taxonomicClassification[[i]]$taxonId$taxonId))
      expect_true(
        length(r$taxonomicClassification[[i]]$commonName) == 0)
    }
  }

  # Resolved taxa have expected content. Only checking the first level.

  resolvable_taxa <- which(!is.na(data$taxa_clean))
  for (i in resolvable_taxa) {
    expect_true(is.character(r$taxonomicClassification[[i]]$taxonRankName))
    expect_true(is.character(r$taxonomicClassification[[i]]$taxonRankValue))
    expect_true(is.character(r$taxonomicClassification[[i]]$taxonId$provider))
    expect_true(is.character(r$taxonomicClassification[[i]]$taxonId$taxonId))
    expect_true(is.character(r$taxonomicClassification[[i]]$commonName[[1]]))
  }

  # Clean up

  unlink(
    c(paste0(tempdir(), "/taxa_map.csv"),
      paste0(tempdir(), "/taxonomicCoverage.xml")),
    recursive = TRUE,
    force = TRUE)

})

