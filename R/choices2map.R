#' Convert taxon_choices.csv to taxon_map.csv
#'
#' @description
#'     This function converts the file taxon_choices.csv (created with the
#'     manual method of \code{resolve_taxa}, and later completed by the user)
#'     to the file taxon_map.csv (used to update the taxa listed in the raw
#'     data table).
#'
#' @usage
#'     choices2map(path = "")
#'
#' @param path
#'     A path of the directory containing \emph{taxon_choices.csv}.
#'
#' @return
#'     A comma delimited file in the dataset working directory titled
#'     \emph{taxon_map.csv} containing the relationships between your input
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

  if (!file.exists(paste(path, "/", "taxon_choices.csv", sep = ""))){
    stop("taxon_choices.csv doen't exist. Please create it.")
  }


  message("Reading taxon_choices.csv.")

  taxon_choices <- read.table(paste(path, "/", "taxon_choices.csv", sep = ""),
                        header = T,
                        sep = ",",
                        as.is = T,
                        na.strings = "NA")

  # Extract marked rows -------------------------------------------------------

  use_i <- taxon_choices$selection != ""

  if (sum(is.na(use_i)) == dim(taxon_choices)[1]){
    stop("No selections were made in the taxon_choices.csv file. Please select which raw taxa and authority resolved taxa pairings you'd like to use.")
  }

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


  # Create taxon.csv ----------------------------------------------------------

  taxon_map <- data.frame(user_supplied_name = the_choosen_ones$user_supplied_name,
                          matched_name = the_choosen_ones$authority_match,
                          data_source_title = the_choosen_ones$authority_name,
                          authority_taxon_id = the_choosen_ones$authority_taxon_id,
                          taxon_rank = the_choosen_ones$taxon_rank,
                          stringsAsFactors = F)


  message('Writing taxon_map.csv.')

  write.table(taxon_map,
              file = paste(path,
                           "/",
                           "taxon_map.csv",
                           sep = ""),
              col.names = T,
              row.names = F,
              sep = ",",
              quote = F)

  message('Done.')

}

