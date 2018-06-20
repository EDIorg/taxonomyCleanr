context('Replace taxon name with user specified input')
library(taxonomyCleanr)

# Trim white space ------------------------------------------------------------

testthat::test_that('replace_taxon replaces a target taxon name', {

  expect_equal(

    replace_taxon(
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
      input = 'taxa 2',
      output = 'taxa 1'
    ),

    data.frame(
      location = c(
        'loc 1',
        'loc 2',
        'loc 3'),
      taxa = c(
        'taxa 1',
        'taxa 1',
        'taxa 3'
        ),
      stringsAsFactors = F
      )
  )

})

