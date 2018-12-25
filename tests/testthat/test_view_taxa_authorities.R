context('View taxonomic authorities')
library(taxonomyCleanr)

# Trim white space ------------------------------------------------------------

testthat::test_that('View available authorities', {

  expect_equal(class(view_taxa_authorities()),
               'data.frame')

  expect_equal(colnames(view_taxa_authorities()),
               c('id', 'authority', 'resolve_sci_taxa', 'resolve_comm_taxa'))

})
