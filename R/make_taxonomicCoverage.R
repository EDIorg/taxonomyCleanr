#' Make the taxonomicCoverage EML element
#'
#' @description
#'     Make the taxonomicCoverage EML element from information contained in
#'     the file taxon.txt.
#'
#' @usage
#'     make_taxonomicCoverage(path = "")
#'
#' @param path
#'     A path of the directory containing the file taxon.txt, which
#'     is created by the function `update_data`.
#'
#' @return
#'     The taxonomicCoverage EML element written to the file
#'     taxonomicCoverage.xml in the directory specified by path.
#'     When creating EML for your dataset using the EMLassemblyline
#'     (https://github.com/EDIorg/EMLassemblyline), this file is read
#'     and the contents incorporated into the EML for this dataset.
#'
#' @export
#'


make_taxonomicCoverage <- function(path){

  # message('Checking arguments.')
  #
  # if (missing(path)){
  #   stop('Input argument "path" is missing! Specify the path to your dataset working directory.')
  # }
  #
  # # Validate path
  #
  # validate_path(path)
  #
  # # Read in taxon.txt
  #
  # if (!file.exists(paste(path, "/", "taxon.txt", sep = ""))){
  #   stop('taxon.txt does not exist! Please create this file or remove the time stamp from the version you would like to use with your data.')
  # }
  #
  # taxon <- utils::read.table(paste(path, "/", "taxon.txt", sep = ""),
  #                     header = T,
  #                     sep = "\t",
  #                     as.is = T,
  #                     na.strings = "NA")
  #
  # # Create EML taxonomicCoverage element --------------------------------------
  #
  # ids <- taxon$authority_taxon_id[stats::complete.cases(taxon$authority_taxon_id)]
  #
  # classifications <- classification(x = ids, db = "itis")
  #
  # # build up taxonomic system (can there be more than one?)
  #
  # message('Making <taxonomicCoverage>')
  #
  # ranks <- classifications[[1]]$rank
  # df <- matrix(NA, nrow = length(classifications), ncol = length(ranks))
  # df <- as.data.frame(df)
  # colnames(df) <- ranks
  # df <- data.frame(lapply(df, as.character), stringsAsFactors = F)
  # suppressWarnings(for (i in 1:length(classifications)){
  #   use_i <- match(ranks, classifications[[i]]$rank)
  #   if (sum(is.na(use_i)) > 0){
  #     use_i2 <- is.na(use_i)
  #     use_i <- use_i[!use_i2]
  #
  #     if (max(use_i, na.rm = T) > length(ranks)){
  #       use_i4 <- use_i > length(ranks)
  #       use_i <- use_i[!use_i4]
  #       df[i, use_i] <- classifications[[i]]$name[use_i]
  #     } else {
  #       use_i2 <- is.na(use_i)
  #       use_i <- use_i[!use_i2]
  #       df[i, use_i] <- classifications[[i]]$name[use_i]
  #     }
  #
  #   } else {
  #     df[i, use_i] <- classifications[[i]]$name[use_i]
  #   }
  # })
  #
  # taxon_coverage <- set_taxonomicCoverage(df)
  #
  # # Write to file
  #
  # message('Writing taxonomicCoverage.xml')
  #
  # write_eml(eml = taxon_coverage,
  #           file = paste(path, "/", "taxonomicCoverage.xml", sep = ""))
  #
  # message('Done.')

}


