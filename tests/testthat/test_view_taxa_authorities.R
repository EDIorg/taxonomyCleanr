context('View taxonomic authorities')
library(taxonomyCleanr)

# Trim white space ------------------------------------------------------------

testthat::test_that('View available authorities', {

  authorities <- view_taxa_authorities()

  expect_equal(
    class(authorities),
    'data.frame'
  )

  expect_equal(
    all(
      colnames(authorities) %in%
        c('id', 'authority', 'resolve_sci_taxa', 'resolve_comm_taxa')),
    TRUE
  )

})
