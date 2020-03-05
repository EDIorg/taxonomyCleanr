context('Validate arguments')

library(taxonomyCleanr)

# resolve_sci_taxa() ----------------------------------------------------------

testthat::test_that('resolve_sci_taxa()', {

  expect_error(
    validate_arguments(
      fun.name = "resolve_sci_taxa",
      fun.args = list(data.sources = 3)))

  expect_error(
    validate_arguments(
      fun.name = "resolve_sci_taxa",
      fun.args = list(x = 'Yellow Perch')))

  expect_error(
    validate_arguments(
      fun.name = "resolve_sci_taxa",
      fun.args = list(x = 'Yellow Perch', data.sources = -1)))

})
