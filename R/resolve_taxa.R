#' Resolve taxa
#'
#' @description
#'     Resolve taxa to preferred authorities and get associated ID's.
#'
#' @usage
#'     resolve_taxa(path, data.sources)
#'
#' @param path
#'     A character string specifying the path to taxa_map.csv. This table
#'     tracks relationships between your raw and cleaned data and is operated
#'     on by this function. Create this file with `initialize_taxa_map`.
#' @param data.sources
#'     An ordered numeric vector of ID's corresponding to data sources (i.e.
#'     taxonomic authorities) you'd like to query, in the order of decreasing
#'     preference. Run `view_authorities` to get valid data source options
#'     and ID's.
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

# resolve_taxa <- function(path, data.sources){
#
#   # Check arguments ---------------------------------------------------------
#
#   if (missing(path)){
#     stop('Input argument "path" is missing!')
#   }
#   if (missing(data.sources)){
#     stop('Input argument "data.sources" is missing!')
#   }
#
#   validate_path(path)
#
#   use_i <- file.exists(
#     paste0(
#       path,
#       '/taxa_map.csv'
#     )
#   )
#   if (!isTRUE(use_i)){
#     stop('taxa_map.csv is missing! Create it with initialize_taxa_map.R.')
#   }
#
#   use_i <- as.character(data.sources) %in% c('1','3','9','11','165')
#   if (sum(use_i) != length(use_i)){
#     stop('Input argument "data.sources" contains unsupported data source IDs!')
#
#   }
#
#   # Read taxa_map.csv -------------------------------------------------------
#
#   taxa_map <- suppressMessages(
#     as.data.frame(
#       read_csv(
#         paste0(
#           path,
#           '/taxa_map.csv'
#         )
#       )
#     )
#   )
#
#   for (i in 1:nrow(taxa_map)){
#
#     # Get taxon from taxa_map.csv
#
#     taxon <- taxa_map[i, 'taxa_raw']
#
#     if (!is.na(taxa_map[i, 'taxa_trimmed'])){
#       taxon <- taxa_map[i, 'taxa_trimmed']
#     }
#     if (!is.na(taxa_map[i, 'taxa_replacement'])){
#       taxon <- taxa_map[i, 'taxa_replacement']
#     }
#     if (!is.na(taxa_map[i, 'taxa_removed'])){
#       taxon <- 'unresolvable_taxa'
#     }
#
#     resolve_taxa_sub <- function(x, data.sources){
#
#       output <- data.frame(
#         taxa_clean = rep(NA_character_, length(data.sources)),
#         rank = rep(NA_character_, length(data.sources)),
#         authority = rep(NA_character_, length(data.sources)),
#         authority_id = rep(NA_character_, length(data.sources)),
#         score = rep(NA_character_, length(data.sources)),
#         stringsAsFactors = F
#       )
#       j <- 1
#
#       while (j != (length(data.sources)+1)){
#
#         # Resolve name, authority, and score
#
#         out_auth <- get_authority(
#           taxon = x,
#           data.source = as.character(data.sources[j])
#         )
#
#         # Resolve ID, and rank
#
#         out_id <- get_id(
#           taxon = out_auth['resolved_name'],
#           authority = out_auth['authority']
#         )
#
#         # Parse results into output data frame
#
#         output[j, 'taxa_clean'] <- out_auth['resolved_name']
#         output[j, 'rank'] <- out_id['taxon_rank']
#         output[j, 'authority'] <- out_auth['authority']
#         output[j, 'authority_id'] <- out_id['taxon_id']
#         output[j, 'score'] <- out_auth['score']
#
#         j <- j + 1
#
#       }
#
#       # Get best match
#
#       if (sum(is.na(output[ , 'authority_id'])) == nrow(output)){
#         if (sum(is.na(output[ , 'authority'])) != nrow(output)){
#           output <- output[!is.na(output[ , 'authority']), ]
#           output <- output[1, ]
#         } else {
#           output <- output[1, ]
#         }
#       }
#
#       # Return
#
#       list(
#         output[1, 'taxa_clean'],
#         output[1, 'rank'],
#         output[1, 'authority'],
#         output[1, 'authority_id'],
#         output[1, 'score']
#         )
#
#     }
#
#     # Update taxa_map.csv
#
#     if (length(query) != 0){
#       taxa_map[i, 'taxa_clean'] <- query[1, 'matched_name2']
#       taxa_map[i, 'authority'] <- query[1, 'data_source_title']
#       taxa_map[i, 'score'] <- query[1, 'score']
#     }
#   }
#
#   # Document provenance -----------------------------------------------------
#
#   # Write to file
#
#   write_taxa_map(
#     x = taxa_map,
#     path = path
#   )
#
#
# }
#
#
#
#
#
#
# get_authority <- function(taxon, data.source){
#
#   # Resolve taxa to authority -------------------------------------------------
#
#   message(
#     paste0(
#       'Getting authority for "',
#       taxon,
#       '"'
#     )
#   )
#
#   # Call Global Names Resolver (GNR)
#
#   query <- suppressWarnings(
#     as.data.frame(
#       gnr_resolve(
#         paste0(
#           taxon,
#           '*'
#           ),
#         resolve_once = T,
#         canonical = T,
#         best_match_only = T,
#         preferred_data_sources = as.character(
#           data.source
#           )
#         )
#       )
#     )
#
#   # Return output -------------------------------------------------------------
#
#   if (nrow(query) == 0){
#     list(
#       'resolved_name' =  NA_character_,
#       'authority' = NA_character_,
#       'score' = NA_character_)
#   } else {
#     list(
#       'resolved_name' =  query[1, 'matched_name2'],
#       'authority' = query[1, 'data_source_title'],
#       'score' = query[1, 'score'])
#   }
#
# }
#
#
#
#
#
# get_id <- function(taxon, authority){
#
#   # Get ID and rank from taxon and authority ----------------------------------
#
#   # Get authority and query for ID and rank
#
#   # # Catalogue of Life
#   # if (!is.na(use_i) & isTRUE(use_i)){
#   #   response <- get_ids_(
#   #     taxon,
#   #     'col'
#   #   )
#   #   if (nrow(response[[1]][[1]]) > 0){
#   #     response <- as.data.frame(response$col)
#   #     #response <- response[complete.cases(response), ]
#   #     use_i <- response[ , 2] == taxon
#   #     response <- response[use_i, ]
#   #     if (nrow(response) > 0){
#   #       taxa_map[i, 'authority_id'] <- as.character(response[1, 1])
#   #       taxa_map[i, 'rank'] <- response[1, 3]
#   #     }
#   #   }
#   # }
#
#   # ITIS
#   if (!is.na(authority) & (authority == 'ITIS')){
#     response <- as.data.frame(
#       itis_terms(
#         taxon
#       )
#     )
#     if (nrow(response) > 0){
#       use_i <- response[ , 'scientificName'] == taxon
#       response <- response[use_i, ]
#       if (nrow(response) > 0){
#         taxon_id <- as.character(response[1, 'tsn'])
#         taxon_rank <- itis_taxrank(as.numeric(taxon_id))
#       } else {
#         taxon_id <- NA_character_
#         taxon_rank <- NA_character_
#       }
#     } else {
#       taxon_id <- NA_character_
#       taxon_rank <- NA_character_
#     }
#   }
#
#   # # World Register of Marine Species
#   # # use_i <- taxa_map[i, 'authority'] == 'World Register of Marine Species'
#   # if (!is.na(use_i) & isTRUE(use_i)){
#   #   response <- get_wormsid_(
#   #     taxon,
#   #     searchtype = 'scientific',
#   #     accepted = F,
#   #     ask = F,
#   #     messages = F
#   #   )
#   #   if (!is.null(response[[1]])){
#   #     response <- as.data.frame(response[[1]])
#   #     #response <- response[complete.cases(response), ]
#   #     use_i <- response[ , 2] == taxon
#   #     response <- response[use_i, ]
#   #     if (nrow(response) > 0){
#   #       taxa_map[i, 'authority_id'] <- as.character(response[1, 1])
#   #       response <- classification(as.character(response[1, 1]), db = 'worms')
#   #       response <- as.data.frame(response[[1]])
#   #       taxa_map[i, 'rank'] <- response[nrow(response), 2]
#   #     }
#   #   }
#   # }
#
#   # # GBIF Backbone Taxonomy
#   # # use_i <- taxa_map[i, 'authority'] == 'GBIF Backbone Taxonomy'
#   # if (!is.na(use_i) & isTRUE(use_i)){
#   #   response <- get_ids_(
#   #     taxon,
#   #     'gbif'
#   #   )
#   #   if (nrow(response[[1]][[1]]) > 0){
#   #     response <- as.data.frame(response[[1]][[1]])
#   #     #response <- response[complete.cases(response), ]
#   #     use_i <- response[ , 2] == taxon
#   #     response <- response[use_i, ]
#   #     if (nrow(response) > 0){
#   #       taxa_map[i, 'authority_id'] <- as.character(response[1, 1])
#   #       taxa_map[i, 'rank'] <- response[1, 3]
#   #     }
#   #   }
#   # }
#   #
#   # # Tropicos - Missouri Botanical Garden
#   # # use_i <- taxa_map[i, 'authority'] == 'Tropicos - Missouri Botanical Garden'
#   # if (!is.na(use_i) & isTRUE(use_i)){
#   #   response <- get_ids_(
#   #     taxon,
#   #     'tropicos'
#   #   )
#   #   if (nrow(response[[1]][[1]]) > 0){
#   #     response <- as.data.frame(response[[1]][[1]])
#   #     use_i <- response[ , 2] == taxon
#   #     response <- response[use_i, ]
#   #     if (nrow(response) > 0){
#   #       taxa_map[i, 'authority_id'] <- as.character(response[1, 1])
#   #       response <- tax_rank(taxa_map[i, 'authority_id'], db = 'tropicos')
#   #       taxa_map[i, 'rank'] <- response[[1]]
#   #     }
#   #   }
#   # }
#
#   # Return --------------------------------------------------------------------
#
#   if (!exists('taxon_id')){
#     taxon_id <- NA_character_
#   }
#   if (!exists('taxon_rank')){
#     taxon_rank <- NA_character_
#   }
#
#   list('taxon_id' = taxon_id,
#        'taxon_rank' = taxon_rank)
#
# }
