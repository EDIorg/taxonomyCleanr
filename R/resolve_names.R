#' Resolve taxa names
#'
#' @description
#'     Resolve input taxonomoic names against an authority and output a table
#'     that maps your raw taxon data to the resolved names. This map is later
#'     used by \code{update_data} to revise the taxon listed in your data.
#'
#' @usage
#'     resolve_names(path = "", data.file = "", taxon.col = "", mode = "")
#'
#' @param path
#'     A path of the directory containing the data table containing taxonomic
#'     information.
#' @param data.file
#'     Name of the input data table containing taxonomic data.
#' @param taxon.col
#'     Name of the column containing the taxonomic names including species
#'     binomials and common names.
#' @param method
#'     Method for resolving your taxonomic data against an authority. There
#'     are 2 options:
#'     \itemize{
#'         \item{manual} NOT YET SUPPORTED: Outputs a table with all possible
#'         accepted options from which you manually select.
#'         \item{automatic} Output table with one-to-one matches where the resolved
#'         name is the first accepted match for a taxon.
#'         \item{interactive} You are prompted to select from a list of options
#'         when a one-to-one match can't be found.
#'     }
#'
#' @return
#'     A tab delimited file in the dataset working directory titled
#'     \emph{taxon_map.txt} containing the relationships between your input
#'     taxon data and the resolved names. This file is used by
#'     \code{update_data} to update the taxonomic data of your data table.
#'
#'     A tab delimited file in the dataset working directory titled
#'     \emph{taxon.txt}. This file is used to create the taxonomicCoverage
#'     element of the EML for your dataset.
#'
#' @export
#'


resolve_names <- function(path, data.file, taxon.col, method){

  # Check arguments and parameterize ------------------------------------------

  if (missing(path)){
    stop('Input argument "path" is missing! Specify the path to your dataset working directory.')
  }
  if (missing(data.file)){
    stop('Input argument "data.file" is missing! Specify the name of your data file containing taxonomic data.')
  }
  if (missing(taxon.col)){
    stop('Input argument "taxon.col" is missing! Specify the column of your data table containing taxon names.')
  }
  if (missing(method)){
    stop('Input argument "method" is missing! Specify the method for resolving your taxonomic names.')
  }

  # Validate path

  validate_path(path)

  # Validate data.files

  data_file <- validate_file_names(path, data.file)

  # Validate method

  method.low <- tolower(method)

  if (!str_detect(method.low, "^automatic$|^interactive$|^manual$")){
    stop('Invalid value entered for the "method" argument. Please choose "automatic", "interactive", or "manual".')
  }

  # Detect operating system

  os <- detect_os()

  # Detect field delimiter

  sep <- detect_delimeter(path, data.files = data_file, os)

  # Validate taxon.col

  message(paste0("Checking ", data_file, " for valid column names."))

  data_path <- paste(path,
                     "/",
                     data_file,
                     sep = "")

  df_table <- read.table(data_path,
                         header = TRUE,
                         sep = delim_guess,
                         quote = "\"",
                         as.is = TRUE,
                         fill = T,
                         comment.char = "")

  columns <- colnames(df_table)
  columns_in <- taxon.col
  use_i <- str_detect(string = columns,
                      pattern = str_c("^", columns_in, "$", collapse = "|"))
  if (sum(use_i) == 0){
    stop(paste0('Invalid "taxon.col" entered: ', columns_in, ' Please fix this.'))
  }

  # Create taxon list from data.file ------------------------------------------

  message(paste0("Reading ", data_file, "."))

  data_L0 <- read.table(paste(path, "/", data_file, sep = ""),
                        header = T,
                        sep = sep,
                        as.is = T,
                        na.strings = "NA")

  message("Extracting unique taxon.")

  data_L0 <- unique(data_L0[[taxon.col]])

  # Resolve taxonomic names to authority --------------------------------------


  if (method == "automatic"){

    message('Resolving taxon names using the "automatic" method.')

    # Select authority and retrieve options

    # (out <- gnr_datasources())
    # message("Refer to the list of authorities to resolve taxonomic names against.")
    # answer <- readline("Enter the row number of the one you'd like to use: ")
    # ds <- as.integer(answer)
    ds <- as.integer("3") # Restrict to ITIS (for now)
    # print(paste("You selected ...", out$title[as.integer(answer)]))

    # Send to Global Names Resolver
    # Not all names may resolve because of colloquial terms and non-species terms

    message('Resolving scientific names.')

    gnr_out <- gnr_resolve(names = data_L0,
                           data_source_ids = ds,
                           resolve_once = F,
                           with_context = F,
                           canonical = T,
                           best_match_only = T)

    data_out <- subset(gnr_out,
                       select = c(user_supplied_name,
                                  matched_name2,
                                  data_source_title))

    colnames(data_out)[2] <- "matched_name"

    data_out$do_not_use <- character(dim(data_out)[1])

    # Attempt to resolve common names ---------------------------------------------
    # Identify remaining names and send through common2science name resolver.
    # Print to file for spread sheet selection (manual).

    message('Resolving common names.')

    data_sources <- data.frame(id = seq(2),
                                title = c("itis", "worms"),
                                stringsAsFactors = F)
    # print("Reference the list of sources above to resolve common names against.")
    # answer <- readline("Enter the row number of the source to query: ")
    # ds <- as.integer(answer)
    ds <- as.integer("1") # default to ITIS (for now)
    # print(paste("You selected ...", data_sources$title[ds]))

    # List taxa not resolved by GNR (these may be common names).

    use_i <- data_L0 %in% unique(gnr_out[["user_supplied_name"]])
    unidentified_taxa <- data_L0[!use_i]

    ut_out <- data.frame(user_supplied_name = character(0),
                         matched_name = character(0),
                         data_source_title = character(0),
                         do_not_use = character(0),
                         stringsAsFactors = F)
    for (i in 1:length(ds)){
      comm2sci_reply <- comm2sci(commnames = unidentified_taxa, db = data_sources$title[i])
      for (j in 1:length(comm2sci_reply)){
        usn <- names(comm2sci_reply)[j]
        if (identical(comm2sci_reply[[j]], character(0))){
          mn <- "could not be resolved"
        } else {
          mn <- comm2sci_reply[[j]]
        }
        dst <- data_sources$title[i]
        usn <- rep(usn, length(mn))
        dst <- rep(dst, length(mn))
        utr <- rep("", length(mn))
        dat_out <- data.frame(user_supplied_name = usn,
                              matched_name = mn,
                              data_source_title = dst,
                              do_not_use = utr,
                              stringsAsFactors = F)
        ut_out <- rbind(ut_out, dat_out)
      }
    }
    ut_out <- ut_out[order(ut_out$user_supplied_name), ]
    ut_out$data_source_title <- toupper(ut_out$data_source_title)

    # Prompt user to select from list of resolvable options

    ut_out2 <- data.frame(user_supplied_name = character(0),
                          matched_name = character(0),
                          data_source_title = character(0),
                          do_not_use = character(0),
                          stringsAsFactors = F)
    uni_supplied_names <- unique(ut_out$user_supplied_name)
    for (i in 1:length(uni_supplied_names)){
      use_i <- ut_out$user_supplied_name == uni_supplied_names[i]
      hold <- ut_out[use_i, ]
      ut_out2 <- rbind(ut_out2, hold)
    }
    use_i <- ut_out2$matched_name == "could not be resolved"
    ut_out2 <- ut_out2[!use_i, ]

    ut_out3 <- data.frame(user_supplied_name = character(0),
                          matched_name = character(0),
                          data_source_title = character(0),
                          do_not_use = character(0),
                          stringsAsFactors = F)
    uni_supplied_names <- unique(ut_out2$user_supplied_name)
    for (i in 1:length(uni_supplied_names)){
      use_i <- ut_out2$user_supplied_name == uni_supplied_names[i]
      hold <- ut_out2[use_i, ]
      rownames(hold) <- seq(nrow(hold))
      print(hold[use_i, 1:2])
      print("Reference the list of matches above")
      answer <- readline("Enter the row number of the correct match for your data: ")
      print(paste("You selected ...", hold$matched_name[as.integer(answer)]))
      ut_out3 <- rbind(ut_out3, hold[as.integer(answer), ])
    }
    ut_out <- ut_out3

    # Combine resolvable names (scientific and common)

    all_resolved_names <- rbind(data_out, ut_out)

    # Add authority_taxon_id to all_resolved_names (only supported for ITIS right now)
    # get_tsn only works for ITIS. Could add other db options.

    message('Identifying taxonomic serial numbers.')

    all_resolved_names$authority_taxon_id <- character(nrow(all_resolved_names))

    for (i in 1:length(all_resolved_names$matched_name)){
      info <- suppressWarnings(get_tsn(searchterm = all_resolved_names$matched_name[i],
                      searchtype = "scientific",
                      accepted = T,
                      ask = F))
      if (attr(info, "match") == "found"){
        all_resolved_names$authority_taxon_id[i] <- info[1]
      }
    }

    # Add taxon_rank to all_resolved_names (only supported for ITIS right now)

    message('Identifying taxon ranks.')

    all_resolved_names$taxon_rank <- character(nrow(all_resolved_names))

    for (i in 1:length(all_resolved_names$matched_name)){
      info <- all_resolved_names$authority_taxon_id[i]
      if (!info == ""){
        info <- itis_taxrank(query = as.numeric(info))
        all_resolved_names$taxon_rank[i] <- info
      }
    }

    # Remove donotuse column

    all_resolved_names <- all_resolved_names[ ,-4]

    # Write results to file -------------------------------------------------------

    message('Writing results to "taxon_map.txt".')

    write.table(all_resolved_names,
                file = paste(path,
                             "/",
                             "taxon_map.txt",
                             sep = ""),
                col.names = T,
                row.names = F,
                sep = "\t",
                eol = "\r\n",
                quote = F)







  } else if (method == "manual"){

    message('This method is not yet supported. Please select "automatic" or "interactive"')






  } else if (method == "interactive"){

    message('Resolving taxon names using the "interactive" method.')

    # Select authority and retrieve options

    # (out <- gnr_datasources())
    # message("Refer to the list of authorities to resolve taxonomic names against.")
    # answer <- readline("Enter the row number of the one you'd like to use: ")
    # ds <- as.integer(answer)
    ds <- as.integer("3") # Restrict to ITIS (for now)
    # print(paste("You selected ...", out$title[as.integer(answer)]))

    # Send to Global Names Resolver
    # Not all names may resolve because of colloquial terms and non-species terms

    message('Resolving scientific names.')

    gnr_out <- gnr_resolve(names = data_L0,
                           data_source_ids = ds,
                           resolve_once = F,
                           with_context = F,
                           canonical = T,
                           best_match_only = T)

    data_out <- subset(gnr_out,
                       select = c(user_supplied_name,
                                  matched_name2,
                                  data_source_title))

    colnames(data_out)[2] <- "matched_name"

    data_out$do_not_use <- character(dim(data_out)[1])

    # Attempt to resolve common names ---------------------------------------------
    # Identify remaining names and send through common2science name resolver.
    # Print to file for spread sheet selection (manual).

    message('Resolving common names.')

    data_sources <- data.frame(id = seq(2),
                               title = c("itis", "worms"),
                               stringsAsFactors = F)
    # print("Reference the list of sources above to resolve common names against.")
    # answer <- readline("Enter the row number of the source to query: ")
    # ds <- as.integer(answer)
    ds <- as.integer("1") # default to ITIS (for now)
    # print(paste("You selected ...", data_sources$title[ds]))

    # List taxa not resolved by GNR (these may be common names).

    use_i <- data_L0 %in% unique(gnr_out[["user_supplied_name"]])
    unidentified_taxa <- data_L0[!use_i]

    ut_out <- data.frame(user_supplied_name = character(0),
                         matched_name = character(0),
                         data_source_title = character(0),
                         do_not_use = character(0),
                         stringsAsFactors = F)
    for (i in 1:length(ds)){
      comm2sci_reply <- comm2sci(commnames = unidentified_taxa, db = data_sources$title[i])
      for (j in 1:length(comm2sci_reply)){
        usn <- names(comm2sci_reply)[j]
        if (identical(comm2sci_reply[[j]], character(0))){
          mn <- "could not be resolved"
        } else {
          mn <- comm2sci_reply[[j]]
        }
        dst <- data_sources$title[i]
        usn <- rep(usn, length(mn))
        dst <- rep(dst, length(mn))
        utr <- rep("", length(mn))
        dat_out <- data.frame(user_supplied_name = usn,
                              matched_name = mn,
                              data_source_title = dst,
                              do_not_use = utr,
                              stringsAsFactors = F)
        ut_out <- rbind(ut_out, dat_out)
      }
    }
    ut_out <- ut_out[order(ut_out$user_supplied_name), ]
    ut_out$data_source_title <- toupper(ut_out$data_source_title)

    # Prompt user to select from list of resolvable options

    ut_out2 <- data.frame(user_supplied_name = character(0),
                          matched_name = character(0),
                          data_source_title = character(0),
                          do_not_use = character(0),
                          stringsAsFactors = F)
    uni_supplied_names <- unique(ut_out$user_supplied_name)
    for (i in 1:length(uni_supplied_names)){
      use_i <- ut_out$user_supplied_name == uni_supplied_names[i]
      hold <- ut_out[use_i, ]
      ut_out2 <- rbind(ut_out2, hold)
    }
    use_i <- ut_out2$matched_name == "could not be resolved"
    ut_out2 <- ut_out2[!use_i, ]

    ut_out3 <- data.frame(user_supplied_name = character(0),
                          matched_name = character(0),
                          data_source_title = character(0),
                          do_not_use = character(0),
                          stringsAsFactors = F)
    uni_supplied_names <- unique(ut_out2$user_supplied_name)
    for (i in 1:length(uni_supplied_names)){
      use_i <- ut_out2$user_supplied_name == uni_supplied_names[i]
      hold <- ut_out2[use_i, ]
      rownames(hold) <- seq(nrow(hold))
      print(hold[use_i, 1:2])
      print("Reference the list of matches above")
      answer <- readline("Enter the row number of the correct match for your data: ")
      print(paste("You selected ...", hold$matched_name[as.integer(answer)]))
      ut_out3 <- rbind(ut_out3, hold[as.integer(answer), ])
    }
    ut_out <- ut_out3

    # Combine resolvable names (scientific and common)

    all_resolved_names <- rbind(data_out, ut_out)

    # Add authority_taxon_id to all_resolved_names (only supported for ITIS right now)
    # get_tsn only works for ITIS. Could add other db options.

    message('Identifying taxonomic serial numbers.')

    all_resolved_names$authority_taxon_id <- character(nrow(all_resolved_names))

    for (i in 1:length(all_resolved_names$matched_name)){
      info <- suppressWarnings(get_tsn(searchterm = all_resolved_names$matched_name[i],
                                       searchtype = "scientific",
                                       accepted = T,
                                       ask = F))
      if (attr(info, "match") == "found"){
        all_resolved_names$authority_taxon_id[i] <- info[1]
      } else {
        info <- suppressWarnings(get_tsn(searchterm = all_resolved_names$matched_name[i],
                                         searchtype = "scientific",
                                         accepted = T,
                                         ask = T))
        all_resolved_names$authority_taxon_id[i] <- info[1]
      }
    }

    # Add taxon_rank to all_resolved_names (only supported for ITIS right now)

    message('Identifying taxonomic ranks.')

    all_resolved_names$taxon_rank <- character(nrow(all_resolved_names))

    use_i <- is.na(all_resolved_names$authority_taxon_id)
    all_resolved_names$authority_taxon_id[use_i] <- ""

    for (i in 1:length(all_resolved_names$matched_name)){
      info <- all_resolved_names$authority_taxon_id[i]
      if (!info == ""){
        info <- itis_taxrank(query = as.numeric(info))
        all_resolved_names$taxon_rank[i] <- info
      }
    }

    # Remove donotuse column

    all_resolved_names <- all_resolved_names[ ,-4]

    # Write results to file -------------------------------------------------------

    message('Writing results to "taxon_map.txt".')

    write.table(all_resolved_names,
                file = paste(path,
                             "/",
                             "taxon_map.txt",
                             sep = ""),
                col.names = T,
                row.names = F,
                sep = "\t",
                eol = "\r\n",
                quote = F)

  }

}











