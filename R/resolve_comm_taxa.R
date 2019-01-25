#' Resolve taxa with common names
#'
#' @description
#'     Resolve common names to preferred authorities and get associated ID's.
#'
#' @usage
#'     resolve_comm_taxa(path, data.sources, x = NULL)
#'
#' @param path
#'     A character string specifying the path to taxa_map.csv. This table
#'     tracks relationships between your raw and cleaned data and is operated
#'     on by this function. Create this file with `create_taxa_map`.
#' @param data.sources
#'     An ordered numeric vector of ID's corresponding to data sources (i.e.
#'     taxonomic authorities) to query, in the order of decreasing
#'     preference. Run `view_taxa_authorities` to see data source that support
#'     `resolve_comm`.
#' @param x
#'     (character) A vector of taxa names.
#'
#' @details
#'     Common names are resolved to data sources in order of listed preference.
#'     If an authority and ID match can not be made, then the next preferred data
#'     source will be queried, and so on.
#'
#' @return
#'     \itemize{
#'         \item{1.} An updated version of taxa_map.csv containing authorities
#'         and corresponding IDs.
#'         \item{2.} A data frame of taxa_map.csv with resolved authorities and
#'         IDs.
#'     }
#'
#' @export
#'

resolve_comm_taxa <- function(path, data.sources, x = NULL){

  # Check arguments ---------------------------------------------------------

  if (!is.null(x) & !missing(path)){
    stop('Both "path" and "x" arguments are not allowed. Select one or the other.')
  }

  if (is.null(x)){
    if (missing(path)){
      stop('Input argument "path" is missing!')
    }
    use_i <- file.exists(
      paste0(
        path,
        '/taxa_map.csv'
      )
    )
    if (!isTRUE(use_i)){
      stop('taxa_map.csv is missing! Create it with initialize_taxa_map.R.')
    }
  }

  if (missing(data.sources)){
    stop('Input argument "data.sources" is missing!')
  }

  use_i <- as.character(data.sources) %in% c('3')
  if (sum(use_i) != length(use_i)){
    stop('Input argument "data.sources" contains unsupported data source IDs!')
  }

  # Read taxa_map.csv -------------------------------------------------------

  if (!missing(path)){

    taxa_map <- suppressMessages(
      as.data.frame(
        readr::read_csv(
          paste0(
            path,
            '/taxa_map.csv'
          )
        )
      )
    )

  } else {



  }

  # Create taxa list ----------------------------------------------------------

  if (!missing(path)){

    taxa_list <- data.frame(
      index = seq(nrow(taxa_map)),
      taxa = rep(NA, nrow(taxa_map)),
      stringsAsFactors = F
    )

    taxa_list[ , 'taxa'] <- taxa_map[ , 'taxa_raw']

    use_i <- !is.na(taxa_map[ , 'taxa_trimmed'])
    taxa_list[use_i, 'taxa'] <- taxa_map[use_i, 'taxa_trimmed']

    use_i <- !is.na(taxa_map[ , 'taxa_replacement'])
    taxa_list[use_i, 'taxa'] <- taxa_map[use_i, 'taxa_replacement']

    use_i <- is.na(taxa_map[ , 'taxa_clean'])
    taxa_list[!use_i, 'taxa'] <- NA

    use_i <- !is.na(taxa_map[ , 'taxa_removed'])
    taxa_list <- taxa_list[!use_i, ]

    use_i <- is.na(taxa_list[ , 'taxa'])
    taxa_list <- taxa_list[!use_i, ]

  } else {

    taxa_list <- data.frame(
      index = seq(length(x)),
      taxa = rep(NA, length(x)),
      stringsAsFactors = F
    )

    taxa_list[ , 'taxa'] <- x

  }

  # Optimize match ------------------------------------------------------------

  query <- lapply(
    taxa_list[ , 'taxa'],
    optimize_match_common,
    data.sources = data.sources
  )

  # Update taxa_map.csv -----------------------------------------------------

  if (!missing(path)){

    query <- data.frame(
      matrix(
        unlist(
          query
        ),
        nrow = length(query),
        byrow = T
      ),
      stringsAsFactors = F
    )

    colnames(query) <- c(
      'taxa_clean',
      'rank',
      'authority',
      'authority_id')

    use_i <- match(colnames(query), colnames(taxa_map))

    taxa_map[taxa_list[ ,'index'], use_i] <- query

    taxa_map[ , 'rank'] <- stringr::str_to_title(taxa_map[ , 'rank'])

  } else {

    query <- data.frame(
      matrix(
        unlist(
          query
        ),
        nrow = length(query),
        byrow = T
      ),
      stringsAsFactors = F
    )

    colnames(query) <- c(
      'taxa_clean',
      'rank',
      'authority',
      'authority_id')

    taxa_map <- cbind(taxa_list, query)

  }

  # Document provenance -----------------------------------------------------

  # Write to file
  lib_path <- system.file('test_data.txt', package = 'taxonomyCleanr')
  lib_path <- substr(lib_path, 1, nchar(lib_path) - 14)
  if (!missing(path)){
    if (path != lib_path){
      write_taxa_map(x = taxa_map, path = path)
    }
  }

  # Return --------------------------------------------------------------------

  taxa_map

}









#' Get taxonomic identifiers
#'
#' @description
#'     Get a taxonomic identifier for a taxon name and corresponding authority.
#'
#' @usage
#'     get_id_common(taxon, authority)
#'
#' @param taxon
#'     A character string specifying taxon to get the ID for.
#' @param authority
#'     A character string specifying the authority from which to get the ID.
#'
#' @return
#'     \itemize{
#'         \item{taxon_id} An authority ID for the taxon.
#'         \item{rank} The taxonomic rank of the taxon.
#'     }
#'
#' @export
#'

get_id_common <- function(taxon, authority){

  taxon_id <- NA_character_
  taxon_rank <- NA_character_
  taxon_authority <- NA_character_
  taxon_clean <- NA_character_

  # Match authority -----------------------------------------------------------

  gnr_ds <- taxize::gnr_datasources()
  use_i <- authority == gnr_ds[ , 'id']
  authority <- gnr_ds[use_i, 'title']

  # Get ID and rank from taxon and authority ----------------------------------

  # Get authority and query for ID and rank

  # # ITIS
  if ((!is.na(authority)) & (authority == 'ITIS')){
    response <- as.data.frame(
      taxize::get_tsn_(
        searchterm = taxon,
        searchtype = 'common',
        ask = F
      )
    )
    if (nrow(response) > 0){
      use_i <- tolower(response[ , 3]) == tolower(taxon)
      response <- response[use_i, ]
      if (nrow(response) > 0){
        taxon_id <- as.character(response[1, 1])
        taxon_rank <- 'Common'
        taxon_authority <- authority
        taxon_clean <- taxon
      } else {
        taxon_id <- NA_character_
        taxon_rank <- NA_character_
        taxon_authority <- NA_character_
        taxon_clean <- NA_character_
      }
    } else {
      taxon_id <- NA_character_
      taxon_rank <- NA_character_
      taxon_authority <- NA_character_
      taxon_clean <- NA_character_
    }
  }

  # # World Register of Marine Species
  # if ((!is.na(authority)) & (authority == 'World Register of Marine Species')){
  #   response <- as.data.frame(
  #     get_wormsid_(
  #       query = taxon,
  #       searchtype = 'common',
  #       ask = F
  #       )
  #     )
  #   if (!is.null(response[[1]])){
  #     response <- as.data.frame(response[[1]])
  #     use_i <- response[ , 2] == taxon
  #     response <- response[use_i, ]
  #     if (nrow(response) > 0){
  #       taxon_id <- as.character(response[ , 'AphiaID'])
  #       response <- taxize::classification(taxon_id, db = 'worms')
  #       response <- as.data.frame(response[[1]])
  #       taxon_rank <- response[nrow(response), 2]
  #     } else {
  #       taxon_id <- NA_character_
  #       taxon_rank <- NA_character_
  #     }
  #   } else {
  #     taxon_id <- NA_character_
  #     taxon_rank <- NA_character_
  #   }
  # }

  # # Tropicos - Missouri Botanical Garden
  # if ((!is.na(authority)) & (authority == 'Tropicos - Missouri Botanical Garden')){
  #     response <- as.data.frame(
  #       tp_search(
  #         commonname = taxon
  #       )
  #       )
  #   if (nrow(response[[1]][[1]]) > 0){
  #     response <- as.data.frame(response[[1]][[1]])
  #     use_i <- response[ , 2] == taxon
  #     response <- response[use_i, ]
  #     if (nrow(response) > 0){
  #       taxon_id <- as.character(response[1, 'nameid'])
  #       response <- taxize::tax_rank(taxon_id, db = 'tropicos')
  #       taxon_rank <- response[[1]]
  #     } else {
  #       taxon_id <- NA_character_
  #       taxon_rank <- NA_character_
  #     }
  #   } else {
  #     taxon_id <- NA_character_
  #     taxon_rank <- NA_character_
  #   }
  # }

  # Encyclopedia of life
  if ((!is.na(authority)) & (authority == 'EOL')){
        response <- suppressMessages(as.data.frame(
          taxize::eol_search(
            terms = taxon,
            exact = T
            )
          ))
    if (nrow(response) > 0){
      if (nrow(response) > 0){
        taxon_id <- as.character(response[1, 'pageid'])
        taxon_rank <- 'common'
        taxon_authority <- authority
        taxon_clean <- taxon
      } else {
        taxon_id <- NA_character_
        taxon_rank <- NA_character_
        taxon_authority <- NA_character_
        taxon_clean <- NA_character_
      }
    } else {
      taxon_id <- NA_character_
      taxon_rank <- NA_character_
      taxon_authority <- NA_character_
      taxon_clean <- NA_character_
    }
  }

  # Return --------------------------------------------------------------------

  if (!exists('taxon_id')){
    taxon_id <- NA_character_
  }
  if (!exists('taxon_rank')){
    taxon_rank <- NA_character_
  }
  if (!exists('taxon_authority')){
    taxon_id <- NA_character_
  }
  if (!exists('taxon_clean')){
    taxon_rank <- NA_character_
  }
  if (is.null(taxon_id)){
    taxon_id <- NA_character_
  }
  if (is.null(taxon_rank)){
    taxon_rank <- NA_character_
  }
  if (is.null(taxon_authority)){
    taxon_authority <- NA_character_
  }
  if (is.null(taxon_clean)){
    taxon_clean <- NA_character_
  }

  list('taxon_id' = taxon_id,
       'taxon_rank' = taxon_rank,
       'taxon_authority' = taxon_authority,
       'taxon_clean' = taxon_clean)

}










#' Optimize match common
#'
#' @description
#'     Optimize the common taxon match to an authority based on completeness of
#'     returned information. A complete return contains both an authority
#'     name and an authority ID for a taxon.
#'
#' @usage
#'     optimize_match_common(x, data.sources)
#'
#' @param x
#'     (character) A character string specifying the taxon.
#' @param data.sources
#'     (Numeric) A numeric vector of values specifying the authorities to search across.
#'     Run `view_authorities` to get valid data source options and ID's.
#'
#' @return
#'     \itemize{
#'         \item{taxa_clean} Resolved name for input taxon.
#'         \item{rank} Rank of the input taxon.
#'         \item{authority} Best authority match for input taxon.
#'         \item{authority_id} Corresponding authority ID for the input taxon.
#'         \item{score} Authority match score for input taxon.
#'
#'     }
#'
#' @export
#'

optimize_match_common <- function(x, data.sources){

  output <- data.frame(
    taxa_clean = rep(NA_character_, length(data.sources)),
    rank = rep(NA_character_, length(data.sources)),
    authority = rep(NA_character_, length(data.sources)),
    authority_id = rep(NA_character_, length(data.sources)),
    stringsAsFactors = F
  )
  j <- 1

  while (j != (length(data.sources)+1)){

    # Resolve ID, and rank

    out_id <- suppressWarnings(
      get_id_common(
        taxon = x,
        authority = data.sources[j]
      )
    )

    # Parse results into output data frame

    output[j, 'taxa_clean'] <- out_id[['taxon_clean']]
    output[j, 'rank'] <- out_id[['taxon_rank']]
    output[j, 'authority'] <- out_id[['taxon_authority']]
    output[j, 'authority_id'] <- out_id[['taxon_id']]

    j <- j + 1

  }

  # Get best match

  if (sum(is.na(output[ , 'authority_id'])) == nrow(output)){
    if (sum(is.na(output[ , 'authority'])) != nrow(output)){
      output <- output[!is.na(output[ , 'authority']), ]
      output <- output[1, ]
    } else {
      output <- output[1, ]
    }
  } else {
    output <- output[!is.na(output[ , 'authority_id']), ]
  }

  # Return

  list(
    output[1, 'taxa_clean'],
    output[1, 'rank'],
    output[1, 'authority'],
    output[1, 'authority_id']
  )

}

