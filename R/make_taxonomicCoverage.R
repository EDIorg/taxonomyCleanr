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
#'
#' @return
#'     The taxonomicCoverage EML as an XML object, and or written to the file
#'     taxonomicCoverage.xml in the directory specified by path.
#'
#' @export
#'

make_taxonomicCoverage <- function(taxa.clean, authority, authority.id, path = NULL){

  data <- unname(get_classification(taxa.clean = taxa.clean, authority = authority,
                                    authority.id = authority.id, path = path))

  dataframe_2_taxclass <- function(x){
    if (('name' %in% colnames(x)) & ('rank' %in% colnames(x))){
      df <- dplyr::select(x, name, rank)
      df <- as.data.frame(t(data.frame(df$name)))
      colnames(df) <- x$rank
      taxcov <- EML::set_taxonomicCoverage(df)
      taxcov@taxonomicClassification[[1]]
    }
  }

  taxclass <- lapply(data, dataframe_2_taxclass)
  taxcov <- methods::new('taxonomicCoverage')
  taxcov@taxonomicClassification <- methods::as(taxclass,
                                       'ListOftaxonomicClassification')

  if (!is.null(path)){
    EML::write_eml(eml = taxcov,
                   file = paste0(path, "/", "taxonomicCoverage.xml"))
  }

  taxcov

}
