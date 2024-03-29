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
#' @keywords internal
#'
write_taxa_map <- function(x, path){

  # Check arguments ---------------------------------------------------------

  if (missing(x)){
    stop('Input argument "x" is missing!')
  }
  if (missing(path)){
    stop('Input argument "path" is missing!')
  }
  validate_path(path)

  x <- as.data.frame(x)

  # Error if file is open ---------------------------------------------------

  use_i <- suppressWarnings(
    "try-error" %in% class(
      try(
        data.table::fwrite(
          x = x,
          file = paste0(path, '/taxa_map.csv'), sep = ","
        ),
        silent = TRUE
      )
    )
  )

  # if (isTRUE(use_i)){
  #   stop(
  #     paste0(
  #       path,
  #       '/',
  #       fname,
  #       '\n is in use by another program. Please close it and try again.'
  #     )
  #   )
  # }

}








#' Validate path
#'
#' @description
#'     Use \code{dir.exists} to determine whether the input path is valid and
#'     returns an error message if not.
#'
#' @usage validate_path(path)
#'
#' @param path
#'     A character string specifying a path to the dataset working directory.
#'
#' @return
#'     A warning message if the path leads to a non-existant directory.
#'
#' @keywords internal
#'
validate_path <- function(path){

  # Validate path -------------------------------------------------------------

  if (!dir.exists(path)){
    stop('The directory specified by the argument "path" does not exist! Please enter the correct path for your dataset working directory.')
  }

}
