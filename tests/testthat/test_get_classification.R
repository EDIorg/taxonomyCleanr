context('Get taxa classifications')
library(taxonomyCleanr)

# Initialize test data --------------------------------------------------------

data <- data.table::fread(
  system.file('/taxa_map_resolve_sci_taxa/taxa_map.csv', package = 'taxonomyCleanr'),
  fill = TRUE,
  blank.lines.skip = TRUE)

data <- data[!is.na(data$authority), ]
data <- data[!data$rank == 'Common', ]
data <- data[data$authority == 'ITIS', ]

path <- system.file('test_data.txt', package = 'taxonomyCleanr')
path <- substr(path, 1, nchar(path) - 14)

taxclass <- get_classification(
  taxa.clean = data$taxa_clean[1],
  authority = data$authority[1],
  authority.id = as.numeric(data$authority_id[1]))

# Test output attributes ------------------------------------------------------

testthat::test_that('Return list', {
  expect_equal(
    class(get_classification(
      taxa.clean = data$taxa_clean[1],
      authority = data$authority[1],
      authority.id = as.numeric(data$authority_id[1]))),
    'list')
})


# Supported authorities -------------------------------------------------------

testthat::test_that("ITIS", {

  # ITIS

  taxcov <- get_classification(
    taxa.clean = "Oncorhynchus tshawytscha",
    authority = "ITIS",
    authority.id = "161980")

  expect_equal(
    taxcov[[1]][[length(taxcov[[1]])]]$taxonRankValue,
    "Oncorhynchus tshawytscha")

  expect_true(
    "Chinook salmon" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$commonName))

  expect_true(
    "https://itis.gov" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$provider))

  expect_true(
    "161980" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$taxonId))

  # Integrated Taxonomic Information System

  taxcov <- get_classification(
    taxa.clean = "Oncorhynchus tshawytscha",
    authority = "Integrated Taxonomic Information System",
    authority.id = "161980")

  expect_equal(
    taxcov[[1]][[length(taxcov[[1]])]]$taxonRankValue,
    "Oncorhynchus tshawytscha")

  expect_true(
    "Chinook salmon" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$commonName))

  expect_true(
    "https://itis.gov" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$provider))

  expect_true(
    "161980" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$taxonId))

  # https://www.itis.gov/

  taxcov <- get_classification(
    taxa.clean = "Oncorhynchus tshawytscha",
    authority = "https://www.itis.gov/",
    authority.id = "161980")

  expect_equal(
    taxcov[[1]][[length(taxcov[[1]])]]$taxonRankValue,
    "Oncorhynchus tshawytscha")

  expect_true(
    "Chinook salmon" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$commonName))

  expect_true(
    "https://itis.gov" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$provider))

  expect_true(
    "161980" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$taxonId))

  # itis

  taxcov <- get_classification(
    taxa.clean = "Oncorhynchus tshawytscha",
    authority = "itis",
    authority.id = "161980")

  expect_equal(
    taxcov[[1]][[length(taxcov[[1]])]]$taxonRankValue,
    "Oncorhynchus tshawytscha")

  expect_true(
    "Chinook salmon" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$commonName))

  expect_true(
    "https://itis.gov" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$provider))

  expect_true(
    "161980" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$taxonId))

})




testthat::test_that("WORMS", {

  # WORMS

  taxcov <- get_classification(
    taxa.clean = "Oncorhynchus tshawytscha",
    authority = "WORMS",
    authority.id = "158075")

  expect_equal(
    taxcov[[1]][[length(taxcov[[1]])]]$taxonRankValue,
    "Oncorhynchus tshawytscha")

  expect_true(
    "Chinook salmon" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$commonName))

  expect_true(
    "http://marinespecies.org" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$provider))

  expect_true(
    "158075" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$taxonId))

  # World Register of Marine Species

  taxcov <- get_classification(
    taxa.clean = "Oncorhynchus tshawytscha",
    authority = "World Register of Marine Species",
    authority.id = "158075")

  expect_equal(
    taxcov[[1]][[length(taxcov[[1]])]]$taxonRankValue,
    "Oncorhynchus tshawytscha")

  expect_true(
    "Chinook salmon" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$commonName))

  expect_true(
    "http://marinespecies.org" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$provider))

  expect_true(
    "158075" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$taxonId))

  # http://www.marinespecies.org

  taxcov <- get_classification(
    taxa.clean = "Oncorhynchus tshawytscha",
    authority = "http://www.marinespecies.org/",
    authority.id = "158075")

  expect_equal(
    taxcov[[1]][[length(taxcov[[1]])]]$taxonRankValue,
    "Oncorhynchus tshawytscha")

  expect_true(
    "Chinook salmon" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$commonName))

  expect_true(
    "http://marinespecies.org" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$provider))

  expect_true(
    "158075" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$taxonId))

  # worms

  taxcov <- get_classification(
    taxa.clean = "Oncorhynchus tshawytscha",
    authority = "worms",
    authority.id = "158075")

  expect_equal(
    taxcov[[1]][[length(taxcov[[1]])]]$taxonRankValue,
    "Oncorhynchus tshawytscha")

  expect_true(
    "Chinook salmon" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$commonName))

  expect_true(
    "http://marinespecies.org" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$provider))

  expect_true(
    "158075" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$taxonId))

})




testthat::test_that("GBIF", {

  # GBIF

  taxcov <- get_classification(
    taxa.clean = "Oncorhynchus tshawytscha",
    authority = "GBIF",
    authority.id = "5204024")

  expect_equal(
    taxcov[[1]][[length(taxcov[[1]])]]$taxonRankValue,
    "Oncorhynchus tshawytscha")

  expect_true(
    "https://gbif.org" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$provider))

  expect_true(
    "5204024" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$taxonId))

  # GBIF Backbone Taxonomy

  taxcov <- get_classification(
    taxa.clean = "Oncorhynchus tshawytscha",
    authority = "GBIF Backbone Taxonomy",
    authority.id = "5204024")

  expect_equal(
    taxcov[[1]][[length(taxcov[[1]])]]$taxonRankValue,
    "Oncorhynchus tshawytscha")

  expect_true(
    "https://gbif.org" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$provider))

  expect_true(
    "5204024" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$taxonId))

  # https://gbif.org

  taxcov <- get_classification(
    taxa.clean = "Oncorhynchus tshawytscha",
    authority = "https://gbif.org",
    authority.id = "5204024")

  expect_equal(
    taxcov[[1]][[length(taxcov[[1]])]]$taxonRankValue,
    "Oncorhynchus tshawytscha")

  expect_true(
    "https://gbif.org" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$provider))

  expect_true(
    "5204024" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$taxonId))

  # gbif

  taxcov <- get_classification(
    taxa.clean = "Oncorhynchus tshawytscha",
    authority = "gbif",
    authority.id = "5204024")

  expect_equal(
    taxcov[[1]][[length(taxcov[[1]])]]$taxonRankValue,
    "Oncorhynchus tshawytscha")

  expect_true(
    "https://gbif.org" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$provider))

  expect_true(
    "5204024" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$taxonId))

})




# Unsupported authorities -----------------------------------------------------

testthat::test_that("Unresolvable authority and ID pairs are listed as is", {

  taxcov <- get_classification(
    taxa.clean = "Oncorhynchus tshawytscha",
    authority = "WORMS",
    authority.id = "not-a-valid-id")

  expect_equal(
    taxcov[[1]][[length(taxcov[[1]])]]$taxonRankValue,
    "Oncorhynchus tshawytscha")

  expect_true(
    "worms" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$provider))

  expect_true(
    "not-a-valid-id" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$taxonId))

})




testthat::test_that("Unsupported authorities are listed as is", {

  taxcov <- get_classification(
    taxa.clean = "Some species",
    authority = "THE authority",
    authority.id = "an-id")

  expect_equal(
    taxcov[[1]][[length(taxcov[[1]])]]$taxonRankValue,
    "Some species")

  expect_true(
    "THE authority" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$provider))

  expect_true(
    "an-id" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$taxonId))

})




testthat::test_that("Ranks of unsupported authorities are listed as is", {

  taxcov <- get_classification(
    taxa.clean = "Some species",
    authority = "THE authority",
    authority.id = "an-id",
    rank = "Species")

  expect_equal(
    taxcov[[1]][[length(taxcov[[1]])]]$taxonRankName,
    "Species")

  expect_equal(
    taxcov[[1]][[length(taxcov[[1]])]]$taxonRankValue,
    "Some species")

  expect_true(
    "THE authority" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$provider))

  expect_true(
    "an-id" %in%
      unlist(taxcov[[1]][[length(taxcov[[1]])]]$taxonId$taxonId))

})
