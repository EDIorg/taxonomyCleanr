#' Get taxa classification hierarchy
#'
#' @description
#'     Get the classification hierarchy of taxa.
#'
#' @usage
#'     get_classification(taxa.clean, authority, authority.id, path = NULL)
#'
#' @param taxa.clean
#'     (character) Name of taxa resolved to an authority.
#' @param authority
#'     (character) Vector of authorities corresponding to taxonomic IDs listed
#'     in the "authority.id" argument below. Get data.sources and IDs with
#'     `resolve_sci_taxa`.
#' @param authority.id
#'     (character) Vector taxonomic IDs corresponding to an authority.
#' @param path
#'     A character string specifying the path to taxa_map.csv. This table
#'     tracks relationships between your raw and cleaned data and is operated
#'     on by this function. Create this file with `create_taxa_map`.
#'
#' @return
#'     (list of data frames) If \code{include.common} is FALSE, then a list of
#'     data frames is returned.
#'     (list of lists) If \code{include.common} is TRUE, then a list of named
#'     lists is returned. This structure accomodates cases where a scientific
#'     name and rank has more than one common name.
#'
#' @export
#'
get_classification <- function(taxa.clean,
                               authority,
                               authority.id,
                               path = NULL) {

  # Parameterize --------------------------------------------------------------

  cw <- data.frame(
    human.readable = c(
      'Catalogue of Life',
      'ITIS',
      'World Register of Marine Species',
      'GBIF Backbone Taxonomy',
      'Tropicos - Missouri Botanical Garden'),
    machine.readable = c(
      'col',
      'itis',
      'worms',
      'gbif',
      'tropicos'),
    stringsAsFactors = F)

  # Defaulting to a vaild option allows taxize::classification() to procede
  # without error. The true authority is added after taxize::classification()
  # runs.
  use_i <- match(authority, cw$human.readable)
  missing_authorities <- which(is.na(use_i))
  use_i[is.na(use_i)] <- 2

  # Validate inputs -----------------------------------------------------------

  # Alert users when taxonomic classifications cannot be expanded
  if (any(!(cw$machine.readable[use_i] %in% c("itis", "worms")))) {
    warning(
      "Full taxonomic hierarchies can only be retrieved for ITIS and ",
      "WORMS.", call. = FALSE)
  }

  # Get all available ranks and names -----------------------------------------

  message("Retrieving hierarchy")

  output <- suppressMessages(
    unname(
      mapply(
        taxize::classification,
        sci_id = as.character(authority.id),
        db = cw$machine.readable[use_i])))

  # Repair instances that could not be resolved otherwise these unresolvable
  # taxa will be dropped from the return object.

  unresolvable_taxa <- which(
    unlist(
      lapply(
        output,
        function(x) {
          !is.data.frame(x)
        })))

  if (length(unresolvable_taxa != 0)) {
    for (i in unresolvable_taxa) {
      output[[i]] <- data.frame(
        name = taxa.clean[i],
        rank = "unknown",
        id = NA_character_)
    }
  }

  # Get all common names and restructure for annotation -----------------------

  # Add the authority system identifier and common names (there may be more
  # than one) to each name + rank pair. This will be used by
  # make_taxonomicCoverage() to annotate the output EML metadata.

  message("Retrieving common names")

  # Add missing authorities removed for taxize::classification() above
  authorities <- cw$machine.readable[use_i]
  authorities[missing_authorities] <- "unknown"

  # Iterate through each taxon's hierarchy
  output <- mapply(
    FUN = function(taxon_hierarchy, authority) {

      restructured_taxon_hierarchy <- apply(
        taxon_hierarchy,
        1,
        function(row) {

          # Set Authority system identifier (i.e. provider)
          if (authority == "itis") {
            provider <- "https://itis.gov"
          } else if (authority == "worms") {
            provider <- "http://marinespecies.org"
          } else if (authority == "gbif") {
            provider <- "https://gbif.org"
          }  else {
            provider <- NA_character_
          }

          # Get common name(s). Only English language is supported (currently).
          if (authority == "itis") {
            names_common <- tryCatch({
              r <- ritis::common_names(row[["id"]])
              suppressWarnings(
                r$commonName[r$language == "English"])
            }, error = function(e) {
              NULL
            })
          } else if (authority == "worms") {
            names_common <- tryCatch({
              r <- worrms::wm_common_id(as.numeric(row[["id"]]))
              suppressWarnings(
                r$vernacular[r$language == "English"])
            }, error = function(e) {
              NULL
            })
          } else {
            names_common <- NULL
          }

          # Restructure
          taxonomic_classification <- list(
            taxonRankName = row[["rank"]],
            taxonRankValue = row[["name"]],
            commonName = as.list(names_common),
            taxonId = list(
              provider = provider,
              taxonId = trimws(row[["id"]])))

          return(taxonomic_classification)

        })
      return(restructured_taxon_hierarchy)

    },
    taxon_hierarchy = output,
    authority = authorities,
    SIMPLIFY = FALSE)

  return(unname(output))

}
