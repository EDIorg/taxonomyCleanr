#' Trim taxa strings
#'
#' @description
#'     Trim excess text from raw taxa strings. Doing this before querying an
#'     authority for a match may reduce the frequency of mismatches.
#'
#' @usage
#'     trim_raw_taxon_str(x, col)
#'
#' @param x
#'     A data frame containing the vector of taxa names to be cleaned.
#' @param col
#'     A character string specifying the column in x containing taxa names to
#'     be cleaned.
#'
#' @details
#'     List of conditions `trim_taxa_str` addresses:
#'     \itemize{
#'         \item{'White spaces, trailing and leading'} White spaces are common.
#'         \item{'Species abbreviations trailing a genus value'} E.g. "Sp.",
#'         "Spp.", "Cf.", "Cf...", etc.
#'     }
#'
#' @return
#'     A character string, or vector of strings, with excess characters
#'     trimmed. See details for trimming conditions.
#'
#' @export
#'


trim_taxa_str <- function(x, col){


# Check arguments ---------------------------------------------------------

  if (missing(x)){
    stop('Input argument "x" is missing!')
  }
  if (class(x) != 'data.frame'){
    stop('Input argument "x" must be a data frame!')
  }
  if (missing(col)){
    stop('Input argument "col" is missing!')
  }

  # Trim white space ----------------------------------------------------------

  x[ , col] <- str_trim(
    x[ , col],
    'both'
    )

  # Remove common species abbreviations at the genus level --------------------

  x[ , col] <- str_remove(
    x[ , col],
    paste0(
      '[:space:]+(?i)[s|c]+(\\.*[f|p]*\\.)+$',
      '|[:space:]+(?i)[s|c]+([f|p]*\\.)+$',
      '|[:space:]+(?i)[s|c]+([f|p]*)+$',
      '|[:space:]+(?i)[s|c]+(\\.*[f|p]*)+$')
  )

  # Return --------------------------------------------------------------------

  x

}
