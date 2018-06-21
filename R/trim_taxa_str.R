#' Trim taxa strings
#'
#' @description
#'     Trim excess text from raw taxa strings. Doing this before querying an
#'     authority for a match may reduce the frequency of mismatches.
#'
#' @usage
#'     trim_raw_taxon_str(x)
#'
#' @param x
#'     A character string, or vector of character strings, representing taxa
#'     names to be trimmed.
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


trim_taxa_str <- function(x){


# Check arguments ---------------------------------------------------------

  if (missing(x)){
    stop('Input argument "x" is missing!')
  }
  if (class(x) != 'character'){
    stop('Input argument "x" must be a character string or vector of character strings!')
  }

  # Trim white space ----------------------------------------------------------

  x <- str_trim(
    x,
    'both'
    )

  # Remove common species abbreviations at the genus level --------------------

  x <- str_remove(
    x,
    paste0(
      '[:space:]+(?i)[s|c]+(\\.*[f|p]*\\.)+$',
      '|[:space:]+(?i)[s|c]+([f|p]*\\.)+$',
      '|[:space:]+(?i)[s|c]+([f|p]*)+$',
      '|[:space:]+(?i)[s|c]+(\\.*[f|p]*)+$')
  )

  # Return --------------------------------------------------------------------

  x

}
