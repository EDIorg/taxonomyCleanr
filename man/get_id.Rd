% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_id.R
\name{get_id}
\alias{get_id}
\title{Get taxonomic identifiers}
\usage{
get_id(path)
}
\arguments{
\item{path}{A character string specifying the path to taxa_map.csv. This table
tracks relationships between your raw and cleaned data and is operated
on by this function.}
}
\value{
\itemize{
        \item{1.} An updated version of taxa_map.csv with resolved taxa
        identification numbers.
        \item{2.} A data frame of taxa_map.csv with resolved taxa
        identification numbers.
    }
}
\description{
Get a taxonomic identifier from a taxon name and corresponding authority
    system listed in taxa_map.csv.
}