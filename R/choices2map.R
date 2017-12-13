#' Convert taxon_choices.txt to taxon_map.txt
#'
#' @description
#'     This function converts the file taxon_choices.txt (created with the
#'     manual method of \code{resolve_taxa}, and later completed by the user)
#'     to the file taxon_map.txt (used to update the taxa listed in the raw
#'     data table).
#'
#' @usage
#'     choices2map(path = "")
#'
#' @param path
#'     A path of the directory containing \emph{taxon_choices.txt}.
#'
#' @return
#'     A tab delimited file in the dataset working directory titled
#'     \emph{taxon_map.txt} containing the relationships between your input
#'     taxon data and the resolved names. This file is used by
#'     \code{update_data} to update the taxonomic data of your data table.
#'
#' @export
#'

choices2map <- function(path){

  # Check arguments and parameterize ------------------------------------------

  message('Checking arguments.')

  if (missing(path)){
    stop('Input argument "path" is missing! Specify the path to your dataset working directory.')
  }

  # Validate path

  validate_path(path)

  # Read in data file -----------------------------------------------------------

  if (!file.exists(paste(path, "/", "taxon_choices.txt", sep = ""))){
    stop("taxon_choices.txt doen't exist. Please create it.")
  }


  message("Reading taxon_choices.txt.")

  taxon_choices <- read.table(paste(path, "/", "taxon_choices.txt", sep = ""),
                        header = T,
                        sep = "\t",
                        as.is = T,
                        na.strings = "NA")

  # Extract marked rows -------------------------------------------------------

  use_i <- taxon_choices$selection != ""

  the_choosen_ones <- taxon_choices[use_i, ]

  # Add taxon_rank to all_resolved_names (only supported for ITIS right now) ----

  message('Identifying taxonomic ranks.')

  the_choosen_ones$taxon_rank <- character(nrow(the_choosen_ones))
  use_i <- is.na(the_choosen_ones$authority_taxon_id)
  the_choosen_ones$authority_taxon_id[use_i] <- ""

  for (i in 1:length(the_choosen_ones$authority_match)){
    info <- the_choosen_ones$authority_taxon_id[i]
    if (!info == ""){
      info <- itis_taxrank(query = as.numeric(info))
      the_choosen_ones$taxon_rank[i] <- info
    }
  }


  # Create taxon.txt ----------------------------------------------------------

  taxon_map <- data.frame(user_supplied_name = the_choosen_ones$user_supplied_name,
                          matched_name = the_choosen_ones$authority_match,
                          data_source_title = the_choosen_ones$authority_name,
                          authority_taxon_id = the_choosen_ones$authority_taxon_id,
                          taxon_rank = the_choosen_ones$taxon_rank,
                          stringsAsFactors = F)


  message('Writing taxon_map.txt.')

  write.table(taxon_map,
              file = paste(path,
                           "/",
                           "taxon_map.txt",
                           sep = ""),
              col.names = T,
              row.names = F,
              sep = "\t",
              eol = "\r\n",
              quote = F)

  message('Done.')

}

