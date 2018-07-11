#' Initialize taxa map
#'
#' @description
#'     Initialize the taxa table that will map the resolved taxa back to the
#'     raw taxa in the original data table, and which will be populated with
#'     provenance information about the taxa cleaning process.
#'
#' @usage
#'     initialize_taxa_map(path, x, col)
#'
#' @param path
#'     A character string specifying the path to which the taxa table will be
#'     written.
#' @param x
#'     A data frame containing the vector of taxa names to be cleaned.
#' @param col
#'     A character string specifying the column in x containing taxa names to
#'     be cleaned.
#'
#' @return
#'     A .csv file named (taxa_map.csv) written to path containing the fields:
#'     \itemize{
#'         \item{'taxa_raw'} Unique taxa names listed in x.
#'         \item{'taxa_trimmed'} The contents of taxa_raw, but with white space
#'         and common abbreviations (e.g. "Spp.", "C.f.") trimmed.
#'         \item{'taxa_replacement'} The taxa name used as a replacement for
#'         taxa_raw, and as implemented through `replace_taxon`.
#'         \item{'taxa_removed'} A logical value indicating whether the
#'         corresponding taxa_raw should be removed, and as implemented via
#'         `remove_taxon`.
#'         \item{'taxa_clean'} Cleaned taxa names that have been resolved to a
#'         taxonomic authority.
#'         \item{'rank'} Taxonomic rank for resolved taxon.
#'         \item{'authority'} Taxonomic authorities against which taxa_clean
#'         was resolved.
#'         \item{'authority_id'} Unique identification numbers within each
#'         authority.
#'         \item{'score'} A numeric score, supplied by the authority,
#'         indicating the strength of match between taxa_raw and taxa_clean.
#'         \item{'difference'} A logical value indicating whether the contents
#'         resolved_taxa differ from raw_taxa.
#'     }
#'
#' @export
#'

initialize_taxa_map <- function(path, x, col){

# Check arguments ---------------------------------------------------------

  if (missing(path)){
    warning('Input argument "path" is missing. Include a path if you want results written to file.')
  }
  if (missing(x)){
    stop('Input argument "x" is missing!')
  }
  if (class(x) != 'data.frame'){
    stop('Input argument "x" must be a data frame!')
  }
  if (missing(col)){
    stop('Input argument "col" is missing!')
  }

# Initialize taxon cleaning table -----------------------------------------

  use_i <- length(
    unique(
      x[ , col]
    )
  )

  data_out <- data.frame(
    taxa_raw = rep(NA_character_, use_i),
    taxa_trimmed = rep(NA_character_, use_i),
    taxa_replacement = rep(NA_character_, use_i),
    taxa_removed = rep(NA_character_, use_i),
    taxa_clean = rep(NA_character_, use_i),
    rank = rep(NA_character_, use_i),
    authority = rep(NA_character_, use_i),
    authority_id = rep(NA_character_, use_i),
    score = rep(NA_character_, use_i),
    difference = rep(NA_character_, use_i),
    stringsAsFactors = F
  )

# Populate taxa_raw -------------------------------------------------------

  data_out[ , 'taxa_raw'] <- unique(
    x[ , col]
    )

# Write taxon cleaning table to file --------------------------------------

  write_taxa_map(
    x = data_out,
    path = path
  )

  data_out

}
