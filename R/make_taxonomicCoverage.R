#' Make taxonomicCoverage EML node
#'
#' @param taxa.clean
#'     (character) Taxa names as they appear in your dataset
#' @param authority
#'     (character) Authority \code{taxa.clean} have been resolved to. Supported authorities include: "ITIS", "WORMS", "GBIF". For unsupported authorities, list the home page URL. For unresolved taxa use \code{NA}.
#' @param authority.id
#'     (character) ID of \code{taxa.clean} within the \code{authority}, otherwise \code{NA}
#' @param rank
#'     (character) Rank (e.g. "Genus", "Species") of \code{taxa.clean}, otherwise \code{NA}. This is useful when \code{taxa.clean} can't be resolved to an \code{authority} and the rank must be manually defined.
#' @param path
#'     (character) Path of the directory to which taxonomicCoverage.xml will be written. Can also be the path of the directory containing taxa_map.csv, if using as inputs to this function.
#' @param write.file
#'     (logical) Whether taxonomicCoverage.xml should be written to file. Default is \code{TRUE}.
#'
#' @return
#' \item{emld list}{The taxonomicClassification EML node for use in constructing EML metadata with the EML R library.}
#' \item{taxonomicCoverage.xml}{If \code{write.file = TRUE}.}
#'
#' @details This function uses \code{get_classification()} to expand taxa, resolved to supported authorities, into full taxonomic classification. Each level of classification is accompanied by an annotation (listing the \code{authority} and \code{authority.id}) and common names (only when \code{authority} is ITIS or WORMS). Taxa resolved to unsupported authorities, or not resolved at all, will be listed as is defined in the \code{taxa.clean}, \code{authority}, and \code{authority.id} arguments.
#'
#' @note The name of this function is a bit misleading. The return value is actually a list of taxonomicClassification nodes, which occur immediately below taxonomicCoverage (i.e. ../taxonomicCoverage/taxonomicClassification).
#'
#' @examples
#' \dontrun{
#'
#' # Set working directory
#' setwd("/Users/me/Documents/data_packages/pkg_260")
#'
#' # For taxa resolved to a supported authority
#' taxcov <- make_taxonomicCoverage(
#'   taxa.clean = c("Oncorhynchus tshawytscha", "Oncorhynchus nerka"),
#'   authority = c("WORMS", "WORMS"),
#'   authority.id = c("158075", "254569"),
#'   path = ".")
#'
#' # For taxa resolved to an unsupported authority
#' taxcov <- make_taxonomicCoverage(
#'   taxa.clean = c("Taxon-1", "Taxon-2"),
#'   authority = c("https://some-authority.org", "https://some-authority.org"),
#'   authority.id = c("123", "456"),
#'   path = ".")
#'
#' # For taxa not resolved to an authority
#' taxcov <- make_taxonomicCoverage(
#'   taxa.clean = c("Taxon-1", "Taxon-2"),
#'   path = ".")
#'
#' }
#'
#' @export
#'
make_taxonomicCoverage <- function(
  taxa.clean,
  authority = NA,
  authority.id = NA,
  rank = NA,
  path,
  write.file = TRUE){

  message('Creating <taxonomicCoverage>')

  # FIXME: Not all taxonomic authority systems are supported by this function.
  # Testing and reporting of supported authorities in the function
  # documentation is needed. Additionally, the valid inputs to authority and
  # authority ID need to be definied in the function documentation so users can
  # manually supply this information if necessary.

  # Validate arguments --------------------------------------------------------

  # A path is required when writing to file
  if (missing(path) & isTRUE(write.file)){
    stop('Input argument "path" is required when writing data to file.')
  }

  # The path must be valid
  if (!missing(path)){
    validate_path(path)
  }

  # Load data -----------------------------------------------------------------

  # Load data from taxa_map.csv (if it exists).
  if (!missing(path)) {
    if (file.exists(paste0(path, '/taxa_map.csv'))) {
      taxa_map <- read_taxa_map(path)
      taxa_map$taxa_clean[is.na(taxa_map$taxa_clean)] <-
        taxa_map$taxa_raw[is.na(taxa_map$taxa_clean)]
      taxa.clean <- taxa_map$taxa_clean
      authority <- taxa_map$authority
      authority.id <- taxa_map$authority_id
    }
  }

  # Remove any blank or missing taxa otherwise get_classification() will throw
  # errors

  missing_names <- is.na(taxa.clean) | taxa.clean == ""
  taxa.clean <- taxa.clean[!missing_names]
  authority <- authority[!missing_names]
  authority.id <- authority.id[!missing_names]
  rank <- rank[!missing_names]

  # Create taxonomicCoverage --------------------------------------------------

  # This method supports EML annotation and more than one common name per taxon
  # rank and thus requires a nested list structure not currently supported by
  # EML::set_taxonomicCoverage().

  # Retrieve taxonomic hierarchy and common names when possible

  classifications <- get_classification(
    taxa.clean = taxa.clean,
    authority = authority,
    authority.id = authority.id,
    rank = rank,
    path = path)

  # Recursively convert classifications into the nested structure expected by
  # EML::write_eml().
  taxonomic_coverage <- set_taxonomic_coverage(classifications)

  # Write to file -------------------------------------------------------------

  if (isTRUE(write.file)){
    message('Writing taxonomicCoverage.xml')
    emld::eml_version("eml-2.2.0")
    EML::write_eml(
      eml = taxonomic_coverage,
      file = paste0(path, '/taxonomicCoverage.xml'))
  }

  # Return object -------------------------------------------------------------

  message('Done.')
  return(taxonomic_coverage)

}







#' Create the taxonomicCoverage EML node
#'
#' @param sci_names
#'     (list) Object returned by \code{taxonomyCleanr::get_classification()}.
#'
#' @return
#' \item{list}{If \code{write.file = FALSE} an emld list object is returned
#' for use with the EML R Package.}
#' \item{.xml file}{If \code{write.file = TRUE} a .xml file is written to
#' \code{path}}.
#'
set_taxonomic_coverage <- function(sci_names) {

  pop <- function(taxa) {
    if (length(taxa) > 1) {
      list(
        taxonRankName = taxa[[1]]$taxonRankName,
        taxonRankValue = taxa[[1]]$taxonRankValue,
        taxonId = taxa[[1]]$taxonId,
        commonName = taxa[[1]]$commonName,
        taxonomicClassification = pop(taxa[-1]))
    } else {
      list(
        taxonRankName = taxa[[1]]$taxonRankName,
        taxonRankValue = taxa[[1]]$taxonRankValue,
        taxonId = taxa[[1]]$taxonId,
        commonName = taxa[[1]]$commonName)
    }
  }

  taxa <- lapply(
    sci_names,
    function(sci_name) {
      pop(sci_name)
    })

  return(list(taxonomicClassification = taxa))

}
