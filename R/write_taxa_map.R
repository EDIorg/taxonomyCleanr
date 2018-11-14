#' Write taxa map
#'
#' @description
#'     Writes information created in the `taxonomyCleanr` workflow to
#'     taxa_map.csv. An error is issued if the file is open by another
#'     application.
#'
#' @usage
#'     write_taxa_map(x, path)
#'
#' @param x
#'     A data frame representation of taxa_map.csv. Data frame contents will
#'     be written to file.
#' @param path
#'     A character string specifying the path of where taxa_map.csv
#'     should be written or is written.
#'
#' @return
#'     The taxa_map.csv file, or an updated version of this file to path.
#'
#' @seealso
#'     initialize_taxa_table
#'
#' @export
#'

write_taxa_map <- function(x, path){

  # Check arguments ---------------------------------------------------------

  if (missing(x)){
    stop('Input argument "x" is missing!')
  }
  if (missing(path)){
    stop('Input argument "path" is missing!')
  }
  EDIutils::validate_path(path)

  # Error if file is open ---------------------------------------------------

  use_i <- suppressWarnings(
    "try-error" %in% class(
      try(readr::write_csv(
        x = x,
        path = paste0(
          path,
          '/taxa_map.csv'
        )
      ),
          silent = TRUE
      )
    )
  )

  if (isTRUE(use_i)){
    stop(
      paste0(
        path,
        '/',
        fname,
        '\n is in use by another program. Please close it and try again.'
      )
    )
  }

}
