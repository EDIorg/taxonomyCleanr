#' Check taxa spelling
#'
#' @description
#'     Check taxa spelling against the Global Names Index (GNI) and get GNI of
#'     corresponding output.
#'
#' @usage
#'     spell_checker(x, pattern)
#'
#' @param x
#'     A character string, or vector of character strings, representing taxa
#'     names.
#' @param preferred.data.sources
#'     An ordered numeric vector of ID's corresponding to data sources (i.e.
#'     taxonomic authorities) you'd like to query, in the order of decreasing
#'     preference. Run `gnr_datasources()` to get valid data source options
#'     and ID's.
#'
#' @return
#'     A data frame with the input taxon (search_term), corresponding match
#'     from the Global Names Resolver (result), an indicator of whether
#'     search_term and result differ (difference), the data source resolved
#'     against (source), the data source ID for the resolved taxon (id), and
#'     the match score (score).
#'
#' @export
#'


spell_checker <- function(x, preferred.data.sources){


# Check arguments ---------------------------------------------------------

  if (missing(x)){
    stop('Input argument "x" is missing!')
  }
  if (class(x) != 'character'){
    stop('Input argument "x" must be a character string or vector of character strings!')
  }
  if (missing(preferred.data.sources)){
    stop('Input argument "preferred.data.sources" is missing!')
  }

# Initialize output data frame --------------------------------------------

  data_out <- data.frame(
    search_term = character(length(x)),
    result = character(length(x)),
    difference = character(length(x)),
    source = character(length(x)),
    id = character(length(x)),
    score = character(length(x)),
    stringsAsFactors = F
  )


# Call Global Names Resolver (GNR) ----------------------------------------

  for (i in 1:length(x)){

    query <- suppressWarnings(
      gnr_resolve(
        paste0(
          x[i],
          '*'
          ),
        resolve_once = T,
        canonical = T,
        best_match_only = T,
        preferred_data_sources = as.character(
          preferred.data.sources
          )
        )
      )

    if (length(query) == 0){
      data_out[i, 'search_term'] <- x[i]
      data_out[i, 'result'] <- NA_character_
      data_out[i, 'difference'] <- NA_character_
      data_out[i, 'source'] <- NA_character_
      data_out[i, 'id'] <- NA_character_
      data_out[i, 'score'] <- NA_character_
    } else {
      data_out[i, 'search_term'] <- x[i]
      data_out[i, 'result'] <- query$matched_name2[1]
      if (x[i] == query$matched_name2[1]){
        data_out[i, 'difference'] <- 'no'
      } else {
        data_out[i, 'difference'] <- 'yes'
      }
      data_out[i, 'source'] <- query$data_source_title[1]
      data_out[i, 'id'] <- NA_character_
      data_out[i, 'score'] <- query$score[1]
    }
  }

# Return output -----------------------------------------------------------

  data_out

}
