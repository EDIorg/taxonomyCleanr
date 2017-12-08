#' Make the taxonomicCoverage EML element
#'
#' @description
#'     Make the taxonomicCoverage EML element from information contained in
#'     the file \emph{taxon_map.txt}.
#'
#' @usage
#'     make_taxonomicCoverage(path = "")
#'
#' @param path
#'     A path of the directory containing the file \emph{taxon_map.txt}, which
#'     is created by the function \code{resolve_names}.
#'
#' @return
#'     The taxonomicCoverage EML element written to the file
#'     \emph{taxonomicCoverage.xml} in the directory specified by \emph{path}.
#'     When creating EML for your dataset using the \code{EMLassemblyline}
#'     (\href{https://github.com/EDIorg/EMLassemblyline}), this file is read
#'     and the contents incorporated into the EML for this dataset.
#'
#'     A tab delimited file in the dataset working directory titled
#'     \emph{taxon.txt} containing the unique taxon of your dataset and the
#'     corresponding taxonomic authority information. This table's format
#'     matches that of the \emph{taxon} table of the \emph{ecocomDP} project
#'     (\href{https://github.com/EDIorg/ecocomDP}).
#'
#' @export
#'


make_taxonomicCoverage <- function(path){

  # Read in taxon_map

  taxon <- read.table(paste(path, "/", "taxon_map.txt", sep = ""),
                      header = T,
                      sep = "\t",
                      as.is = T,
                      na.strings = "NA")

  # Create table for EML taxonomicCoverage element ----------------------------

  use_i <- is.na(taxon$authority_taxon_id)

  taxon_table <- data.frame(taxon_id = seq(dim(taxon)[1]),
                            taxon_rank = taxon$taxon_rank,
                            taxon_name = taxon$matched_name,
                            authority_system = taxon$data_source_title,
                            authority_taxon_id = taxon$authority_taxon_id,
                            stringsAsFactors = F)

  write.table(taxon_table,
              file = paste(path,
                           "/",
                           "taxon.txt",
                           sep = ""),
              col.names = T,
              row.names = F,
              sep = "\t",
              eol = "\r\n",
              quote = F)

  # --------------------------------------------

  # Bryce's code
  # xml_taxa<-set_taxonomicCoverage(taxon$matched_name,expand=TRUE,db='itis')

  ids <- taxon$authority_taxon_id[complete.cases(taxon$authority_taxon_id)]

  classifications <- classification(x = ids, db = "itis")

  # build up taxonomic system (can there be more than one?)

  ranks <- classifications[[1]]$rank
  df <- matrix(NA, nrow = length(classifications), ncol = length(ranks))
  df <- as.data.frame(df)
  colnames(df) <- ranks
  df <- data.frame(lapply(df, as.character), stringsAsFactors = F)
  for (i in 1:length(classifications)){
    use_i <- match(ranks, classifications[[i]]$rank)
    if (sum(is.na(use_i)) > 0){
      use_i2 <- is.na(use_i)
      use_i <- use_i[!use_i2]

      if (max(use_i, na.rm = T) > length(ranks)){
        use_i4 <- use_i > length(ranks)
        use_i <- use_i[!use_i4]
        df[i, use_i] <- classifications[[i]]$name[use_i]
      } else {
        use_i2 <- is.na(use_i)
        use_i <- use_i[!use_i2]
        df[i, use_i] <- classifications[[i]]$name[use_i]
      }

    } else {
      df[i, use_i] <- classifications[[i]]$name[use_i]
    }
  }

  taxon_coverage <- set_taxonomicCoverage(df)

  # Write to file

  write_eml(eml = taxon_coverage,
            file = paste(path, "/", "taxonomicCoverage.xml", sep = ""))


}


