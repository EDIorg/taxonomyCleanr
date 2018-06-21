context('Initialize the taxa table to document cleaning operations')
library(taxonomyCleanr)

# df <- data.frame(
#   taxa = c(
#     'taxa 1',
#     'taxa 2',
#     'taxa 3',
#     'taxa 3'
#     ),
#   count = c(
#     2,
#     4,
#     5,
#     4
#     ),
#   stringsAsFactors = F
#   )

data <- read_tsv(
  paste0(
    path.package(
      "taxonomyCleanr"
    ),
    "/test_data.txt"
  )
)

data <- as.data.frame(data)

dim_data <- c(
  length(
    unique(
      data$Species
      )
    ),
  ncol(
    data
    )
  )


# List unique taxa --------------------------------------------------------

testthat::test_that('List uniqe taxa', {

  expect_equal(
    dim(
      initialize_taxa_table(
        x = data,
        col = 'Species'
        )
      ),
    dim_data
    )
  })

