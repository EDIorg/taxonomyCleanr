#' Resolve common names to an authority
#'
#' @description
#'     Resolve taxa to preferred authorities and get associated IDs.
#'
#' @param x
#'     (character) A vector of taxa names.
#' @param data.sources
#'     (numeric) An ordered vector of authority IDs to be queried (
#'     \code{view_taxa_authorities()} lists currently supported authorities).
#'     Taxa are resolved to authorities in the order listed. If an authority
#'     and ID match cannot be made, then the next will be queried.
#' @param path
#'     (character) Path to directory containing taxa_map.csv. This tracks
#'     provenance throughout the data cleaning process. Create this file with
#'     \code{create_taxa_map()}.
#'
#' @return
#'     (data frame; taxa_map.csv) If using \code{x}, then a data frame
#'     containing the input taxa, accepted taxa name, rank, authority,
#'     authority ID, and score are returned. If using \code{path}, then an
#'     updated version of taxa_map.csv will be returned to \code{path} and
#'     a data frame of taxa_map.csv to the R environment.
#'
#' @examples
#' \dontrun{
#'   # Input a list of taxa
#'
#'   r <- resolve_comm_taxa(
#'     x = c("Monterey cypress", "King salmon", "Kentucky bluegrass"),
#'     data.sources = 3)
#'   r
#'
#'   # Input taxa_map.csv
#'
#'   data <- data.table::fread(file = system.file('example_data.txt', package = 'taxonomyCleanr'))
#'   tm <- create_taxa_map(path = tempdir(), x = data, col = "Species")
#'   r <- resolve_comm_taxa(data.sources = 3, path = tempdir())
#'   tm <- read_taxa_map(path = tempdir())
#' }
#'
#' @export
#'

resolve_comm_taxa <- function(x = NULL, data.sources, path = NULL){

  # Check arguments ---------------------------------------------------------

  if (!is.null(x) & !is.null(path)) {
    stop('Both "path" and "x" arguments are not allowed. Select one or the other.')
  }

  if (is.null(x)) {
    if (is.null(path)) {
      stop('Input argument "path" is missing!')
    }
    use_i <- file.exists(
      paste0(
        path,
        '/taxa_map.csv'
      )
    )
    if (!isTRUE(use_i)) {
      stop('taxa_map.csv is missing! Create it with initialize_taxa_map.R.')
    }
  }

  if (missing(data.sources)) {
    stop('Input argument "data.sources" is missing!')
  }

  authorities <- view_taxa_authorities()
  authorities <- authorities[authorities$resolve_comm_taxa == 'supported', ]
  use_i <- as.character(data.sources) %in% as.character(authorities$id)
  if (sum(use_i) != length(use_i)){
    stop('Input argument "data.sources" contains unsupported data source IDs!')
  }

  # Read taxa_map.csv -------------------------------------------------------

  if (!is.null(path)) {
    taxa_map <- read_taxa_map(path)
  }

  # Create taxa list ----------------------------------------------------------

  if (!is.null(path)) {

    taxa_list <- data.frame(
      index = seq(nrow(taxa_map)),
      taxa = rep(NA_character_, nrow(taxa_map)),
      stringsAsFactors = F)
    taxa_list$taxa <- taxa_map$taxa_raw
    use_i <- !is.na(taxa_map$taxa_trimmed)
    taxa_list$taxa[use_i] <- taxa_map$taxa_trimmed[use_i]
    use_i <- !is.na(taxa_map$taxa_replacement)
    taxa_list$taxa[use_i] <- taxa_map$taxa_replacement[use_i]
    use_i <- is.na(taxa_map$taxa_clean)
    taxa_list$taxa[!use_i] <- NA
    use_i <- is.na(taxa_map$authority_id) & is.na(taxa_map$taxa_removed)
    taxa_list <- taxa_list[use_i, ]

  } else {

    taxa_list <- data.frame(
      index = seq(length(x)),
      taxa = rep(NA_character_, length(x)),
      stringsAsFactors = F)
    taxa_list$taxa <- x

  }

  # Optimize match ------------------------------------------------------------

  r <- lapply(
    unique(taxa_list$taxa),
    optimize_match_common,
    data.sources = data.sources)

  # Update taxa_map.csv -------------------------------------------------------

  if (!is.null(path)) {

    r <- data.frame(
      matrix(
        unlist(r),
        nrow = length(r),
        byrow = T),
      stringsAsFactors = F)
    colnames(r) <- c(
      'taxa_clean',
      'rank',
      'authority',
      'authority_id')
    r$taxa <- unique(taxa_list$taxa)
    rj <- dplyr::full_join(r, taxa_list, by = "taxa")
    taxa_map[rj$index, c("taxa_clean", "rank", "authority", "authority_id", "score")] <-
      dplyr::select(rj, -taxa, -index)
    taxa_map$rank <- stringr::str_to_title(taxa_map$rank)

  } else {

    r <- data.frame(
      matrix(
        unlist(r),
        nrow = length(r),
        byrow = T),
      stringsAsFactors = F)
    colnames(r) <- c(
      'taxa_clean',
      'rank',
      'authority',
      'authority_id')
    taxa_map <- cbind(taxa_list, r)

  }

  # Document provenance -----------------------------------------------------

  if (!is.null(path)){
    lib_path <- dirname(
      system.file('/taxa_map_resolve_sci_taxa/taxa_map.csv',
                  package = 'taxonomyCleanr'))
    if (!missing(path)){
      if (path != lib_path){
        write_taxa_map(x = taxa_map, path = path)
      }
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
#' @keywords internal
#'
get_id_common <- function(taxon, authority){

  taxon_id <- NA_character_
  taxon_rank <- NA_character_
  taxon_authority <- NA_character_
  taxon_clean <- NA_character_

  # Match authority -----------------------------------------------------------

  gnr_list <- load_gna_data_sources()
  use_i <- authority == gnr_list[ , 'id']
  authority <- gnr_list[use_i, 'title']

  # Get ID and rank from taxon and authority ----------------------------------

  # Get authority and query for ID and rank

  # # ITIS
  if ((!is.na(authority)) & (authority == 'ITIS')){
    response <- as.data.frame(
      taxize::get_tsn_(
        sci_com = taxon,
        searchtype = 'common',
        ask = FALSE))
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

  # # Encyclopedia of life
  # if ((!is.na(authority)) & (authority == 'EOL')){
  #       response <- suppressMessages(as.data.frame(
  #         taxize::eol_search(
  #           terms = taxon,
  #           exact = T
  #           )
  #         ))
  #   if (nrow(response) > 0){
  #     if (nrow(response) > 0){
  #       taxon_id <- as.character(response[1, 'pageid'])
  #       taxon_rank <- 'common'
  #       taxon_authority <- authority
  #       taxon_clean <- taxon
  #     } else {
  #       taxon_id <- NA_character_
  #       taxon_rank <- NA_character_
  #       taxon_authority <- NA_character_
  #       taxon_clean <- NA_character_
  #     }
  #   } else {
  #     taxon_id <- NA_character_
  #     taxon_rank <- NA_character_
  #     taxon_authority <- NA_character_
  #     taxon_clean <- NA_character_
  #   }
  # }

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
#' @keywords internal
#'
optimize_match_common <- function(x, data.sources){

  output <- data.frame(
    taxa_clean = rep(NA_character_, length(data.sources)),
    rank = rep(NA_character_, length(data.sources)),
    authority = rep(NA_character_, length(data.sources)),
    authority_id = rep(NA_character_, length(data.sources)),
    stringsAsFactors = F)

  j <- 1

  while (j != (length(data.sources)+1)){

    # Resolve ID, and rank

    out_id <- try(
      suppressWarnings(
        get_id_common(
          taxon = x,
          authority = data.sources[j])),
      silent = TRUE)

    if (class(out_id) == "try-error") {
      out_id <- list(
        'taxon_id' = NA_character_,
        'taxon_rank' = NA_character_,
        'taxon_authority' = NA_character_,
        'taxon_clean' = NA_character_)
    }

    # Parse results into output data frame

    output[j, 'taxa_clean'] <- out_id[['taxon_clean']]
    output[j, 'rank'] <- out_id[['taxon_rank']]
    output[j, 'authority'] <- out_id[['taxon_authority']]
    output[j, 'authority_id'] <- out_id[['taxon_id']]

    # Stop if a successful match has been made to save redundant effort

    if (!is.na(output[j, 'authority_id'])) {
      j <- length(data.sources) + 1
    } else {
      j <- j + 1
    }

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

