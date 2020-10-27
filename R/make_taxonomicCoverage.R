#' Make taxonomicCoverage EML
#'
#' @description
#'     Create the hierarchical rank specific EML for taxa that have been
#'     resolved to an authority system (e.g. ITIS).
#'
#' @param taxa.clean
#'     (character) Taxa names as they appear in your dataset, or as they appear
#'     in an authority system. Best practice is to align the names in your
#'     dataset with those of the authority system.
#' @param rank
#'     (character) An optional argument to use when \code{taxa.clean} can't be
#'     resolved to an authority. If no rank is specified in these cases, then
#'     the rank will receive a value of NA.
#' @param authority
#'     (character) Authority to which the taxa have been resolved. Valid inputs
#'     are created by \code{resolve_sci_taxa()}.
#' @param authority.id
#'     (character) Authority specific identifiers for the resolved taxa.
#' @param path
#'     (character) Path to where taxonomicCoverage.xml will be written, and or
#'     to where taxa_map.csv is located.
#' @param write.file
#'     (logical) Whether taxonomicCoverage.xml should be written to file.
#'     Default is \code{TRUE}.
#'
#' @return
#'     A list of taxonomicClassification as an 'emld' 'list' object (required for
#'     use in the \code{EML} library), and written to taxonomicCoverage.xml if
#'     \code{write.file = TRUE}.
#'
#' @examples
#' # Create taxonomicCoverage from taxa_map.csv ----------------------------------
#'
#' # Copy taxa_map.csv from the taxonomyCleanr library to tempdir()
#' file.copy(
#'   from = system.file('/taxa_map_resolve_sci_taxa/taxa_map.csv', package = 'taxonomyCleanr'),
#'   to = tempdir()
#' )
#'
#' # Create taxonomicCoverage
#' output <- make_taxonomicCoverage(
#'   path = tempdir(),
#' )
#'
#' # Verify taxonomicCoverage.xml has been written to file
#' file.exists(paste0(tempdir(), '/taxonomicCoverage.xml'))
#'
#' # Create taxonomicCoverage from argument inputs -------------------------------
#'
#' # Create taxonomicCoverage
#' output <- make_taxonomicCoverage(
#'   taxa.clean = c('Crepis tectorum', 'Euphorbia glyptosperma'),
#'   authority = c('ITIS', 'ITIS'),
#'   authority.id = c('37212', '28074'),
#'   path = tempdir(),
#' )
#'
#' # Verify taxonomicCoverage.xml has been written to file
#' file.exists(paste0(tempdir(), '/taxonomicCoverage.xml'))
#'
#' @export
#'
make_taxonomicCoverage <- function(
  taxa.clean,
  rank = NULL,
  authority,
  authority.id,
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
    EDIutils::validate_path(path)
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

  # Create taxonomicCoverage --------------------------------------------------

  # This method supports EML annotation and more than one common name per taxon
  # rank and thus requires a nested list structure not currently supported by
  # EML::set_taxonomicCoverage().

  # Retrieve taxonomic hierarchy and common names when possible
  classifications <- get_classification(
    taxa.clean = taxa.clean,
    authority = authority,
    authority.id = authority.id,
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
