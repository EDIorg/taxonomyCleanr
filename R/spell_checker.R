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
#'     A data frame with the search term, returned value, GNI identification
#'     number
#'
#' @export
#'


spell_checker <- function(x, preferred.data.sources){

  data_out <- data.frame(
    search_term = character(length(x)),
    result = character(length(x)),
    source = character(length(x)),
    id = character(length(x)),
    score = character(length(x)),
    stringsAsFactors = F
  )

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
      data_out[i, 'source'] <- NA_character_
      data_out[i, 'id'] <- NA_character_
      data_out[i, 'score'] <- NA_character_
    } else {
      data_out[i, 'search_term'] <- x[i]
      data_out[i, 'result'] <- query$matched_name2[1]
      data_out[i, 'source'] <- query$data_source_title[1]
      data_out[i, 'id'] <- NA_character_
      data_out[i, 'score'] <- query$score[1]
    }
  }

  data_out

}
