#' Make taxonomicCoverage EML
#'
#' @description
#'     Make the hierarchical taxonomicCoverage EML node set.
#'
#' @usage
#'     make_taxonomicCoverage(taxa.clean, authority, authority.id, path = NULL)
#'
#' @param taxa.clean
#'     (character) Taxa names that have been resolved to a taxonomic authority.
#' @param authority
#'     (character) Authorities to which the taxa have been resolved. Valid
#'     inputs are created by `resolve_sci_taxa`.
#' @param authority.id
#'     (character) Taxonomic IDs corresponding the authority to which taxa
#'     have been resolved.
#' @param path
#'     (character) The path to which the taxonomicCoverage will be written, and
#'     or to where taxa_map.csv is located.
#' @param write.file
#'     (logical) Flag to indicate if the resulting EML taxonomicCoverage element
#'     should be written to file as an xml document.
#'
#' @importFrom readr read_csv
#'
#' @return
#'     The taxonomicCoverage EML as an XML object, and/or written to the file
#'     taxonomicCoverage.xml in the directory specified by path.
#'
#' @export
#'

make_taxonomicCoverage <- function(taxa.clean, authority, authority.id,
                                   path = NULL, write.file = FALSE){

  # Define data
  if (!is.null(path) & file.exists(paste0(path, '/taxa_map.csv'))){
    taxa_map <- read_csv(file = paste0(path, '/taxa_map.csv'),
                         col_names = T)
    data <- unname(get_classification(taxa.clean = taxa_map$taxa_clean,
                                      authority = taxa_map$authority,
                                      authority.id = taxa_map$authority_id,
                                      path = path))
  } else {
    data <- unname(get_classification(taxa.clean = taxa.clean,
                                      authority = authority,
                                      authority.id = authority.id,
                                      path = path))
  }

  # Create helper function to facilitate differential levels of taxonomic
  # classification
  dataframe_2_taxclass <- function(x){
    if (('name' %in% colnames(x)) & ('rank' %in% colnames(x))){
      df <- x[ , match(c('name', 'rank'), colnames(x))]
      df <- as.data.frame(t(data.frame(df$name)))
      colnames(df) <- x$rank
      taxcov <- EML::set_taxonomicCoverage(df)
    }
  }
  taxclass <- lapply(data, dataframe_2_taxclass)

  # Create EML node set
  taxcov <- EML::eml$taxonomicCoverage(taxonomicClassification = taxclass)

  # Write to file
  if (write.file == TRUE) {
    lib_path <- system.file('test_data.txt', package = 'taxonomyCleanr')
    lib_path <- substr(lib_path, 1, nchar(lib_path) - 14)
    if (!is.null(path)){
      if (path != lib_path){
        EML::write_eml(eml = taxcov,
                       file = paste0(path, "/", "taxonomicCoverage.xml"))
      }
    }
  }

  # Return output
  taxcov

}
