#' Make taxonomicCoverage EML
#'
#' @description
#'     Create the hierarchical rank specific EML for taxa that have been
#'     resolved to an authority system (e.g. ITIS).
#'
#' @usage
#'     make_taxonomicCoverage(
#'       taxa.clean,
#'       authority,
#'       authority.id,
#'       path,
#'       write.file = TRUE
#'     )
#'
#' @param taxa.clean
#'     (character) Taxa names as they appear in your dataset, or as they appear
#'     in an authority system. Best practice is to align the names in your
#'     dataset with those of the authority system.
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
#'     The taxonomicCoverage as an 'emld' 'list' object (required for use in
#'     the \code{EML} library), and written to taxonomicCoverage.xml if
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
#' # View taxonomicCoverage list object
#' output
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
#' # View taxonomicCoverage list object
#' output
#'
#' # Verify taxonomicCoverage.xml has been written to file
#' file.exists(paste0(tempdir(), '/taxonomicCoverage.xml')
#'
#' @export
#'

make_taxonomicCoverage <- function(
  taxa.clean,
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

  if (!missing(path)){
    if (file.exists(paste0(path, '/taxa_map.csv'))){
      taxa_map <- utils::read.table(
        paste0(path, '/taxa_map.csv'),
        header = T,
        sep = ',',
        stringsAsFactors = F
      )
      taxa.clean <- taxa_map$taxa_clean
      authority <- taxa_map$authority
      authority.id <- taxa_map$authority_id
    }
  }

  # Retrieve taxonomic clasifications -----------------------------------------

  message('Retrieving classifications')

  # Retrieve taxonomic classifications.

  data <- unname(
    get_classification(
      taxa.clean = taxa.clean,
      authority = authority,
      authority.id = authority.id,
      path = path
    )
  )

  # Create taxonomicCoverage --------------------------------------------------

  # Create taxonomicCoverage (as a list object) from data containing varying
  # rank levels.

  taxonomicCoverage <- unlist(
    lapply(
      data,
      function(x){
        if (('name' %in% colnames(x)) & ('rank' %in% colnames(x))){
          df <- x[ , match(c('name', 'rank'), colnames(x))]
          df <- as.data.frame(t(data.frame(df$name)))
          colnames(df) <- x$rank
          list(taxonomicClassification = EML::set_taxonomicCoverage(df)$taxonomicClassification[[1]])
        }
      }
    ),
    recursive = FALSE
  )

  # Write to file -------------------------------------------------------------

  if (isTRUE(write.file)){
    message('Writing taxonomicCoverage.xml')
    EML::write_eml(
      eml = taxonomicCoverage,
      file = paste0(path, '/taxonomicCoverage.xml')
    )
  }

  # Return object -------------------------------------------------------------

  message('Done.')
  taxonomicCoverage

}
