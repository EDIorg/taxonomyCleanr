#' Get the taxonomic classification hierarchy for taxa resolved to supported authorities
#'
#' @param taxa.clean
#'     (character) Taxa names
#' @param authority
#'     (character) Authority \code{taxa.clean} have been resolved to, otherwise \code{NA}. Supported authorities include: "ITIS", "WORMS", "GBIF".
#' @param authority.id
#'     (character) ID of \code{taxa.clean} within the \code{authority}, otherwise \code{NA}
#' @param rank
#'     (character) Rank (e.g. "Genus", "Species") of \code{taxa.clean}, otherwise \code{NA}. This is useful when \code{taxa.clean} can't be resolved to an \code{authority} and the rank must be manually defined.
#' @param path
#'     (character) Path of the directory containing taxa_map.csv.
#'
#' @return
#'     (list) For \code{taxa.clean} resolved to a supported authority, each item in the list is a classification hierarchy (also a list), including one or more common names (only when \code{authority} is ITIS or WORMS) and authority IDs for each rank-value pair. For \code{taxa.clean} not resolved to a supported authority, each item is listed as defined in the \code{taxa.clean}, \code{authority}, and \code{authority.id} arguments.
#'
#' @details
#'     Only taxa resolved to supported authorities can be expanded into a full taxonomic classification with common names. Taxa resolved to unsupported authorities, or not resolved at all, will be listed as is defined in the \code{taxa.clean}, \code{authority}, and \code{authority.id} arguments.
#'
#'     Supported authorities are recognized by a controlled set of representations.
#'     \itemize{
#'     \item{ITIS can be: "ITIS", "itis", "Integrated Taxonomic Information System", or "https://www.itis.gov/".}
#'     \item{WORMS can be: "WORMS", "worms", "World Register of Marine Species", or "http://www.marinespecies.org/".}
#'     \item{GBIF can be: "GBIF", "gbif", "GBIF Backbone Taxonomy", or "https://gbif.org".}
#'     }
#'
#' @export
#'
get_classification <- function(taxa.clean,
                               authority = NA,
                               authority.id = NA,
                               rank = NA,
                               path = NULL) {

  # Parameterize --------------------------------------------------------------

  cw <- data.frame(
    human.readable = c(
      'Catalogue of Life',
      'ITIS',
      'Integrated Taxonomic Information System',
      'https://www.itis.gov/',
      'itis',
      'World Register of Marine Species',
      'WORMS',
      'http://www.marinespecies.org/',
      'worms',
      'GBIF Backbone Taxonomy',
      'GBIF',
      'gbif',
      'https://gbif.org',
      'Tropicos - Missouri Botanical Garden'),
    machine.readable = c(
      'col',
      'itis',
      'itis',
      'itis',
      'itis',
      'worms',
      'worms',
      'worms',
      'worms',
      'gbif',
      'gbif',
      'gbif',
      'gbif',
      'tropicos'),
    stringsAsFactors = F)

  supported <- unique.data.frame(
    data.frame(
      taxa.clean = taxa.clean[authority %in% cw$human.readable],
      authority = cw$machine.readable[
        match(authority[authority %in% cw$human.readable], cw$human.readable)],
      authority.id = authority.id[authority %in% cw$human.readable],
      rank = rank[authority %in% cw$human.readable],
      stringsAsFactors = FALSE))

  unsupported <- unique.data.frame(
    data.frame(
      taxa.clean = taxa.clean[!(authority %in% cw$human.readable)],
      authority = authority[!(authority %in% cw$human.readable)],
      authority.id = authority.id[!(authority %in% cw$human.readable)],
      rank = rank[!(authority %in% cw$human.readable)],
      stringsAsFactors = FALSE))

  # Supported authorities -----------------------------------------------------

  if (nrow(supported) != 0) {

    message("Retrieving classifications")

    classifications <- suppressMessages(
      unname(
        mapply(
          taxize::classification,
          sci_id = supported$authority.id,
          db = supported$authority)))

    # Move "false supported" to "unsupported" so taxa won't be lost from the
    # returned object. This can happen when the authority + ID pair doesn't
    # resolve due to inaccuracies

    i <- is.na(classifications)

    unsupported <- rbind(
      unsupported,
      data.frame(
        taxa.clean = supported$taxa.clean[i],
        authority = supported$authority[i],
        authority.id = supported$authority.id[i],
        rank = supported$rank[i],
        stringsAsFactors = FALSE))

    supported <- supported[!i, ]
    classifications <- classifications[!i]

    # Get all common names and restructure for annotation. Add the authority
    # system identifier and common names (there may be more than one) to each
    # name + rank pair. This will be used by make_taxonomicCoverage() to
    # annotate the output EML metadata.

    output_supported <- mapply(
      FUN = function(classification, authority) {

        restructured_classification <- apply(
          classification,
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
            # GBIF doesn't support common name fetching (currently).
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
            classification <- list(
              taxonRankName = row[["rank"]],
              taxonRankValue = row[["name"]],
              commonName = as.list(names_common),
              taxonId = list(
                provider = provider,
                taxonId = trimws(row[["id"]])))

            return(classification)

          })

        return(restructured_classification)

      },
      classification = classifications,
      authority = supported$authority,
      SIMPLIFY = FALSE)

    output_supported <- unname(output_supported)

  } else {
    output_supported <- NULL
  }

  # Unsupported authorities ---------------------------------------------------

  if (nrow(unsupported) != 0) {

    classifications <- unname(
      split(
        data.frame(
          name = unsupported$taxa.clean,
          rank = unsupported$rank,
          id = unsupported$authority.id,
          stringsAsFactors = FALSE),
        seq(nrow(unsupported))))

    # List names and ranks "as is" and restructure for annotation. Add the
    # authority system identifier to each name + rank pair. This will be used
    # by make_taxonomicCoverage() to annotate the output EML metadata.

    output_unsupported <- mapply(
      FUN = function(classification, authority) {

        restructured_classification <- apply(
          classification,
          1,
          function(row) {

            # Set Authority system identifier (i.e. provider)
            if (!is.na(authority) | ("" %in% authority)) {
              provider <- authority
            } else {
              provider <- NA_character_
            }

            # Restructure
            classification <- list(
              taxonRankName = row[["rank"]],
              taxonRankValue = row[["name"]],
              taxonId = list(
                provider = provider,
                taxonId = trimws(row[["id"]])))

            return(classification)

          })

        return(restructured_classification)

      },
      classification = classifications,
      authority = unsupported$authority,
      SIMPLIFY = FALSE)

  } else {
    output_unsupported <- NULL
  }

  # Combine -------------------------------------------------------------------

  return(c(output_supported, output_unsupported))

}

