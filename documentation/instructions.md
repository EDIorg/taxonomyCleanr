# Instructions for the taxonomyCleanr

### Overview

The process of cleaning your taxa requires little to no taxonomic expertise. After a cursory inspection and manual correction of any egregious taxa instances, send your taxa list to a resolver function that searches through a set of user specified taxonomic authorities for matches while accommodating minor spelling variance. When matches are found the correct taxa spelling, authority system, taxonomic identification number, and taxonomic rank are reported and logged to taxa_map.csv. This file relates the resolved taxonomic information back to the original raw taxa list that you provided, and additionally keeps track of the cleaning process so you can remember what changes you made to the raw data. When taxa can't be resolved, their taxonomic information is left blank, indicating that further manual investigation is needed. When manual investigation turns up taxonomic information, the investigator can add it to taxa_map.csv. Once you've carried the cleaning process as far as you can, send your raw taxa list and taxa_map.csv to `update_data` to revise the taxonomic data of your dataset.

Below is a demonstration of the `taxonomyCleanr` using example data that comes with the package install. Give it a try!

* [Install taxonomyCleanr](#installation)
* [Load data](#load-data)
* [Create taxa_map.csv](#create-taxa_map.csv)
* [View taxa](#view-taxa)
* [Trim taxa](#trim-taxa)
* [Replace taxa](#replace-taxa)
* [Remove taxa](#remove-taxa)
* [Resolve taxa (scientific)](#resolve-taxa-(scientific)) 
* [Resolve taxa (common)](#resolve-taxa-(common))
* [Update data](#update-data)
* Make EML (coming soon)


### Installation
Install from the project's GitHub.

```
# Install and load devtools
install.packages("devtools")
library(devtools)

# Install and load taxonomyCleanr
install_github("EDIorg/taxonomyCleanr")
library(taxonomyCleanr)
```

### Load data
Load your data table into RStudio as a data frame. This data frame contains a single column of character strings representing your taxa. If you have species binomials in 2 columns, you will have to combine them into one.

```
# Load test data from taxonomyCleanr R package
data <- read_tsv(paste0(path.package("taxonomyCleanr"), "/test_data.txt"))
data <- as.data.frame(data)

```

### Create taxa_map.csv
Create the taxa table that will map the resolved taxa back to the raw taxa in the original data table, and which will be populated with information about the taxa cleaning process. Arguments to `initialize_taxa_map`:

* ***path*** A character string specifying the path to which the taxa table will be written.
* ***x*** A data frame containing the vector of taxa names to be cleaned.
* ***col*** A character string specifying the column in x containing taxa names to be cleaned.

```
# Create taxa_map.csv
taxa_map <- initialize_taxa_map(path = '/Users/csmith/Documents/, x = data, col = 'Species')
```

Running this function outputs a taxa_map.csv to path containing these columns:

* ***taxa_raw*** Unique taxa names listed in x.
* ***taxa_trimmed*** The contents of taxa_raw, but with white space, common abbreviations (e.g. "Spp.", "C.f."), and underscores trimmed. Removing these strings improves the liklihood of an authority match. Column contents are outputs from `trim_taxon`.
* ***taxa_replacement*** The taxa name used as a replacement for taxa_raw. Column contents are outputs from `replace_taxon`.
* ***taxa_removed*** A logical value indicating whether the corresponding taxon listed in taxa_raw has been removed. Column contents are outputs from `remove_taxon`.
* ***taxa_clean*** Taxa names that have been resolved to a taxonomic authority. Column contents are outputs from `resolve_taxa` and `resolve_common`.
* ***rank*** Taxonomic rank for resolved taxon. Column contents are outputs from `resolve_taxa` and `resolve_common`.
* ***authority*** Taxonomic authorities against which `taxa_clean` was resolved. Column contents are outputs from `resolve_taxa` and `resolve_common`.
* ***authority_id*** Unique identification numbers within each authority. Column contents are outputs from `resolve_taxa` and `resolve_common`.
* ***score*** A numeric score, supplied by the authority, indicating the strength of match between taxa_raw and taxa_clean. Column contents are outputs from `resolve_taxa` and `resolve_common`.
* ***difference*** A logical value indicating whether the contents resolved_taxa differ from raw_taxa.

### View taxa
### Trim taxa
### Replace taxa
### Remove taxa
### Resolve taxa (scientific)
### Resolve taxa (common)
### Update data

