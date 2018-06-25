#' Get taxonomic identifiers
#'
#' @description
#'     Get a taxonomic identifier from a taxon name and corresponding authority
#'     system listed in taxa_map.csv.
#'
#' @usage
#'     get_id(path)
#'
#' @param path
#'     A character string specifying the path to taxa_map.csv. This table
#'     tracks relationships between your raw and cleaned data and is operated
#'     on by this function.
#'
#' @return
#'     \itemize{
#'         \item{1.} An updated version of taxa_map.csv with resolved taxa
#'         identification numbers.
#'         \item{2.} A data frame of taxa_map.csv with resolved taxa
#'         identification numbers.
#'     }
#'
#' @export
#'

get_id <- function(path){

  # Check arguments ---------------------------------------------------------

  if (missing(path)){
    stop('Input argument "path" is missing!')
  }
  if (missing(preferred.data.sources)){
    stop('Input argument "preferred.data.sources" is missing!')
  }

  validate_path(path)

  use_i <- file.exists(
    paste0(
      path,
      '/taxa_map.csv'
    )
  )
  if (!isTRUE(use_i)){
    stop('taxa_map.csv is missing! Create it with initialize_taxa_map.R.')
  }

  # Read taxa_map.csv -------------------------------------------------------

  taxa_map <- suppressMessages(
    as.data.frame(
      read_csv(
        paste0(
          path,
          '/taxa_map.csv'
        )
      )
    )
  )



}
