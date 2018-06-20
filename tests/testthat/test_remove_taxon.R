context('Remove taxon name and associated record')
library(taxonomyCleanr)

# Trim white space ------------------------------------------------------------

testthat::test_that('remove_taxon removes a target taxon', {

  expect_equal(

    dim(remove_taxon(
      x = data.frame(
        location = c(
          'loc 1',
          'loc 2',
          'loc 3'),
        taxa = c(
          'taxa 1',
          'taxa 2',
          'taxa 3'
        ),
        stringsAsFactors = F
      ),
      taxa.col = 'taxa',
      input = 'taxa 2'
    )),

    c(2, 2)

    )

})

