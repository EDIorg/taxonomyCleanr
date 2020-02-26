#' Resolve taxa with scientific names
#'
#' @description
#'     Resolve taxa to preferred authorities and get associated ID's. Run
#'     `view_taxa_authorities` to see supported authorities.
#'
#' @usage
#'     resolve_sci_taxa(x = NULL, data.sources, path = NULL)
#'
#' @param x
#'     (character) A vector of taxa names.
#' @param data.sources
#'     An ordered numeric vector of ID's corresponding to data sources (i.e.
#'     taxonomic authorities) you'd like to query, in the order of decreasing
#'     preference. Run `view_taxa_authorities` to see data sources supported by
#'     `resolve_sci_taxa`.
#' @param path
#'     A character string specifying the path to taxa_map.csv. This table
#'     tracks relationships between your raw and cleaned data and is operated
#'     on by this function. Create this file with `create_taxa_map`.
#'
#' @details
#'     A taxa are resolved to data sources in order of listed preference. If
#'     an authority and ID match can not be made, then the next preferred data
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

resolve_sci_taxa <- function(x = NULL, data.sources, path = NULL){

  # Check arguments ---------------------------------------------------------

  if (!is.null(x) & !is.null(path)){
    stop('Both "path" and "x" arguments are not allowed. Select one or the other.')
  }

  if (is.null(x)){

    if (is.null(path)){
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

  authorities <- view_taxa_authorities()
  authorities <- authorities[authorities$resolve_sci_taxa == 'supported', ]
  use_i <- as.character(data.sources) %in% as.character(authorities$id)
  if (sum(use_i) != length(use_i)){
    stop('Input argument "data.sources" contains unsupported data source IDs!')
  }

  # Read taxa_map.csv -------------------------------------------------------

  if (!is.null(path)){
    taxa_map <- read_taxa_map(path)
  } else {

  }

  # Create taxa list ----------------------------------------------------------

  if (!is.null(path)){

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

    use_i <- !is.na(taxa_map[ , 'taxa_removed'])
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
    optimize_match,
    data.sources = data.sources
  )

  # Update taxa_map.csv -----------------------------------------------------

  if (!is.null(path)){

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
      'authority_id',
      'score')

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
      'authority_id',
      'score')

    taxa_map <- cbind(taxa_list, query)

  }

  # Document provenance -----------------------------------------------------

  if (!is.null(path)){

    # Write to file
    lib_path <- system.file('/taxa_map_resolve_sci_taxa/taxa_map.csv',
                            package = 'taxonomyCleanr')
    lib_path <- substr(lib_path, 1, nchar(lib_path) - 13)
    if (!missing(path)){
      if (path != lib_path){
        write_taxa_map(x = taxa_map, path = path)
      }
    }

  }

  # Return --------------------------------------------------------------------

  taxa_map

}









#' Get taxonomic authority
#'
#' @description
#'     Use fuzzy searching in the Global Names Resolver to correct spelling
#'     and locate appropriate authorities.
#'
#' @usage
#'     get_authority(taxon, data.source)
#'
#' @param taxon
#'     A character string representation of the taxon to search on.
#' @param data.source
#'     A numeric ID corresponding to the data source (i.e. taxonomic authority)
#'     you'd like to query. Run `view_authorities` to get valid data source
#'     options and ID's.
#'
#' @return
#'     \itemize{
#'         \item{resolved_name} Resolved taxon name.
#'         \item{authority} Name of the authority searched.
#'         \item{score} Relative match score provided by the authority.
#'     }
#'
#' @export
#'

get_authority <- function(taxon, data.source){

  # Resolve taxa to authority -------------------------------------------------

  gnr_list <- as.data.frame(
    taxize::gnr_datasources()
  )
  use_i <- gnr_list[ , 'id'] == data.source

  message(
    paste0(
      'Searching ',
      gnr_list[use_i, 'title'],
      ' for "',
      taxon,
      '"'
    )
  )

  # Call Global Names Resolver (GNR)

  query <- suppressWarnings(
    as.data.frame(
      taxize::gnr_resolve(
        paste0(
          taxon,
          '*'
          ),
        resolve_once = T,
        canonical = T,
        best_match_only = T,
        preferred_data_sources = as.character(
          data.source
          )
        )
      )
    )

  # Return output -------------------------------------------------------------

  if (nrow(query) == 0){
    list(
      'resolved_name' =  NA_character_,
      'authority' = NA_character_,
      'score' = NA_character_)
  } else {
    if (query[1, 'matched_name2'] == ""){
      query[1, 'matched_name2'] <- NA_character_
    }
    if (query[1, 'data_source_title'] == ""){
      query[1, 'data_source_title'] <- NA_character_
    }
    if (query[1, 'score'] == "NaN"){
      query[1, 'score'] <- NA_character_
    }

    # Return

    list(
      'resolved_name' =  query[1, 'matched_name2'],
      'authority' = query[1, 'data_source_title'],
      'score' = query[1, 'score'])
  }

}







#' Get taxonomic identifiers
#'
#' @description
#'     Get a taxonomic identifier for a taxon name and corresponding authority.
#'
#' @usage
#'     get_id(taxon, authority)
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

get_id <- function(taxon, authority){

  taxon_id <- NA_character_
  taxon_rank <- NA_character_

  # Get ID and rank from taxon and authority ----------------------------------

  # Get authority and query for ID and rank

  # Catalogue of Life
  if ((!is.na(authority)) & (authority == 'Catalogue of Life')){
    response <- taxize::get_ids_(
      taxon,
      'col'
    )
    if (nrow(response[[1]][[1]]) > 0){
      response <- as.data.frame(response$col)
      use_i <- response[ , 2] == taxon
      response <- response[use_i, ]
      if (nrow(response) > 0){
        taxon_id <- as.character(response[1, 1])
        taxon_rank <- response[1, 3]
      } else {
        taxon_id <- NA_character_
        taxon_rank <- NA_character_
      }
    } else {
      taxon_id <- NA_character_
      taxon_rank <- NA_character_
    }
  }

  # ITIS
  if ((!is.na(authority)) & (authority == 'ITIS')){
    response <- as.data.frame(
      taxize::itis_terms(
        taxon
      )
    )
    if (nrow(response) > 0){
      use_i <- response[ , 'scientificName'] == taxon
      response <- response[use_i, ]
      if (nrow(response) > 0){
        taxon_id <- as.character(response[1, 'tsn'])
        taxon_rank <- taxize::itis_taxrank(as.numeric(taxon_id))
      } else {
        taxon_id <- NA_character_
        taxon_rank <- NA_character_
      }
    } else {
      taxon_id <- NA_character_
      taxon_rank <- NA_character_
    }
  }

  # World Register of Marine Species
  if ((!is.na(authority)) & (authority == 'World Register of Marine Species')){
    response <- taxize::get_wormsid_(
      taxon,
      searchtype = 'scientific',
      accepted = F,
      ask = F,
      messages = F
    )
    if (!is.null(response[[1]])){
      response <- as.data.frame(response[[1]])
      use_i <- response[ , 2] == taxon
      response <- response[use_i, ]
      if (nrow(response) > 0){
        taxon_id <- as.character(response[ , 'AphiaID'])
        response <- taxize::classification(taxon_id, db = 'worms')
        response <- as.data.frame(response[[1]])
        taxon_rank <- response[nrow(response), 2]
      } else {
        taxon_id <- NA_character_
        taxon_rank <- NA_character_
      }
    } else {
      taxon_id <- NA_character_
      taxon_rank <- NA_character_
    }
  }

  # GBIF Backbone Taxonomy
  if ((!is.na(authority)) & (authority == 'GBIF Backbone Taxonomy')){
    response <- taxize::get_ids_(
      taxon,
      'gbif'
    )
    if (nrow(response[[1]][[1]]) > 0){
      response <- as.data.frame(response[[1]][[1]])
      use_i <- response[ , 6] == taxon
      response <- response[use_i, ]
      if (nrow(response) > 0){
        taxon_id <- as.character(response[1, 'usagekey'])
        response <- taxize::classification(taxon_id, db = 'gbif')
        response <- as.data.frame(response[[1]])
        taxon_rank <- response[nrow(response), 2]
      } else {
        taxon_id <- NA_character_
        taxon_rank <- NA_character_
      }
    } else {
      taxon_id <- NA_character_
      taxon_rank <- NA_character_
    }
  }

  # Tropicos - Missouri Botanical Garden
  if ((!is.na(authority)) & (authority == 'Tropicos - Missouri Botanical Garden')){
    response <- taxize::get_ids_(
      taxon,
      'tropicos'
    )
    if (nrow(response[[1]][[1]]) > 0){
      response <- as.data.frame(response[[1]][[1]])
      use_i <- response[ , 2] == taxon
      response <- response[use_i, ]
      if (nrow(response) > 0){
        taxon_id <- as.character(response[1, 'nameid'])
        response <- taxize::tax_rank(taxon_id, db = 'tropicos')
        taxon_rank <- response[[1]]
      } else {
        taxon_id <- NA_character_
        taxon_rank <- NA_character_
      }
    } else {
      taxon_id <- NA_character_
      taxon_rank <- NA_character_
    }
  }

  # Return --------------------------------------------------------------------

  if (!exists('taxon_id')){
    taxon_id <- NA_character_
  }
  if (!exists('taxon_rank')){
    taxon_rank <- NA_character_
  }
  if (is.null(taxon_id)){
    taxon_id <- NA_character_
  }
  if (is.null(taxon_rank)){
    taxon_rank <- NA_character_
  }

  list('taxon_id' = taxon_id,
       'taxon_rank' = taxon_rank)

}










#' Optimize match
#'
#' @description
#'     Optimize the taxon match to an authority based on completeness of
#'     returned information. A complete return contains both an authority
#'     name and an authority ID for a taxon.
#'
#' @usage
#'     optimize_match(x, data.sources)
#'
#' @param x
#'     (character) A character string specifying the taxon.
#' @param data.sources
#'     (numeric) A numeric vector of values specifying the authorities to search across.
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

optimize_match <- function(x, data.sources){

  output <- data.frame(
    taxa_clean = rep(NA_character_, length(data.sources)),
    rank = rep(NA_character_, length(data.sources)),
    authority = rep(NA_character_, length(data.sources)),
    authority_id = rep(NA_character_, length(data.sources)),
    score = rep(NA_character_, length(data.sources)),
    stringsAsFactors = F
  )
  j <- 1

  while (j != (length(data.sources)+1)){

    # Resolve name, authority, and score

    out_auth <- get_authority(
      taxon = x,
      data.source = as.character(data.sources[j])
    )

    # Resolve ID, and rank

    out_id <- suppressWarnings(
      get_id(
        taxon = out_auth['resolved_name'],
        authority = out_auth['authority']
        )
      )

    # Parse results into output data frame

    output[j, 'taxa_clean'] <- out_auth['resolved_name']
    output[j, 'rank'] <- out_id['taxon_rank']
    output[j, 'authority'] <- out_auth['authority']
    output[j, 'authority_id'] <- out_id['taxon_id']
    output[j, 'score'] <- out_auth['score']

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
    output[1, 'authority_id'],
    output[1, 'score']
  )

}
