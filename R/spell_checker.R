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
#' @param pattern
#'     A character string, or vector of character strings, representing the
#'     taxa pattern to be searched.
#' @param pds
#'     A vector of character strings representing authorities to query as specified in GNI
#'     resolver
#'
#' @return
#'     A data frame with the search term, returned value, GNI identification
#'     number
#'
#' @export
#'


spell_checker <- function(x, pattern, pds){

  data_out <- data.frame(
    search_term = character(length(pattern)),
    result = character(length(pattern)),
    source = character(length(pattern)),
    score = character(length(pattern)),
    stringsAsFactors = F
  )

  for (i in 1:length(pattern)){
    query <- gnr_resolve(
      x[i],
      preferred_data_sources = pds,
      best_match_only = T)

    # query <- gni_search(
    #   search_term = pattern[i]
    # )

    if (length(query) == 0){
      data_out[i, 1] <- x[i]
      data_out[i, 2] <- NA_character_
      data_out[i, 3] <- NA_character_
    } else {
      data_out[i, 1] <- x[i]
      data_out[i, 2] <- query$matched_name[1]
      data_out[i, 3] <- query$data_source_title[1]
      data_out[i, 4] <- query$score[1]
    }
  }

  data_out

}
