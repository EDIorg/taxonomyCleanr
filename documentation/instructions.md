# Instructions for the taxonomyCleanr

### Overview

The process of cleaning your taxa requires little to no taxonomic expertise. After a cursory inspection and manual correction of any egregious taxa instances, send your taxa list to a resolver function that searches through a set of user specified taxonomic authorities for matches while accommodating minor spelling variance. When matches are found the correct taxa spelling, authority system, taxonomic identification number, and taxonomic rank are reported and logged to taxa_map.csv. This file relates the resolved taxonomic information back to the original raw taxa list that you provided, and additionally keeps track of the cleaning process so you can remember what changes you made to the raw data. When taxa can't be resolved, their taxonomic information is left blank, indicating that further manual investigation is needed. When manual investigation turns up taxonomic information, the investigator can add it to taxa_map.csv. Once you've carried the cleaning process as far as you can, send your raw taxa list and taxa_map.csv to `update_data` to revise the taxonomic data of your dataset.

Below is a demonstration of the `taxonomyCleanr` using example data that comes with the package install. Give it a try!

* [Install taxonomyCleanr](#installation)
* [Load data](#load-data)
* [Create taxa_map.csv](#create-taxa-map)
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

### Create taxa map
Create the taxa table that will map the resolved taxa back to the raw taxa in the original data table, and which will be populated with information about the taxa cleaning process.

```
# Create taxa_map.csv
my_path <- '/Users/csmith/Documents/'
taxa_map <- initialize_taxa_map(path = my_path, x = data, col = 'Species')

# See column definitions for taxa_map.csv
?initialize_taxa_map
```

### View taxa
View unique occurences and counts of taxa to help identify misspelled taxon and non-sensical taxon.

```
# View unique taxa
output <- view_unique(x = data, col = 'Species', path = my_path)
```

Notice some of the listed taxa have conflicting spellings (e.g. "Achillea millefolium(lanulosa)" and "Achillea millefolium(lanulosaaaa)
"), and some of the taxa are clearly not taxa (e.g. "-9999" and "Miscellaneous litter").

### Trim taxa
Trim excess text from taxa names. Doing this before querying a taxonomic authority reduces the frequency of mismatches.

```
# See what excess text is trimmed.
?trim_taxon

# Trim excess text
output <- trim_taxon(path = my_path)
```

Open taxa_map.csv. Notice `trim_taxon` operated on several of the taxa listed in the taxa_raw column and logged the resultant trimmed taxa names in the taxa_trimmed column. Additionally, notice that the trimmed taxa show up when running `view_unique`:

```
# View the updated taxa list.
output <- view_unique(x = data, col = 'Species', path = my_path)
```

### Replace taxa
Several taxa are clearly wrong. Replace these with suitable substitutes.

```
# View documentation for replace taxa
?replace_taxa

# Replace taxa
output <- replace_taxon(path = my_path, input = 'Achillea millefolium(lanulosa)', output = 'Achillea millefolium')
output <- replace_taxon(path = my_path, input = 'Achillea millefolium(lanulosaaaa)', output = 'Achillea millefolium')
output <- replace_taxon(path = my_path, input = 'Achillea millefolium(lanulosabb)', output = 'Achillea millefolium')
output <- replace_taxon(path = my_path, input = 'Achillea millefolium(lanulosacc)', output = 'Achillea millefolium')
```

Open taxa_map.csv. Notice `replace_taxon` operated on the specified taxa. Also, notice that the replaced taxa show up when running `view_unique`:

```
# View the updated taxa list.
output <- view_unique(x = data, col = 'Species', path = my_path)
```

### Remove taxa
Some taxa should be removed from the list because they are not taxa.

```
# View documentation for remove_taxa
?remove_taxa

# Remove target taxa
output <- remove_taxon(path = my_path, input = '-9999')
output <- remove_taxon(path = my_path, input = 'Unsorted biomass')
output <- remove_taxon(path = my_path, input = 'Miscellaneous litter')

# View the updated taxa list.
output <- view_unique(x = data, col = 'Species', path = my_path)
```

### Resolve taxa (scientific)
Now that the taxa list is looking some what reasonable, we can try resolving the taxa to an authority system. First the authority systems we wish to use should be identified.

```
# View the list of supported authorities for the resolve_taxa function
view_authorities()

# View documentation for the resolve_taxa function
?resolve_taxa

# Resolve taxa using ITIS and WORMS
output <- resolve_taxa(path = my_path, data.sources = c(3,9))
```
Taxa that could be resolved are listed in taxa_map.csv under the columns taxa_clean, rank, authority, and authority_id. Some of the taxa couldn't be resolved so these columns contain NA. For taxa that can't be resolved, it may be worth while performing a manual search of the queried authorities (in this case ITIS and WORMS) or to retry `resolve_taxa` with a different set of authorities, or to manually search a new authority and enter the discovered information to taxa_map.csv manually.

### Resolve taxa (common)
Some of the taxa that can't be resolved have common names. To resolve taxa with common names use `resolve_common`.

```
# View the list of supported authorities for the resolve_common function
view_authorities()

# View documentation for the resolve_taxa function
?resolve_common

# Resolve taxa using ITIS and Encyclopedia of Life
output <- resolve_common(path = my_path, data.sources = c(3,12))
```
Some of the taxa that couldn't be resolved with `resolve_taxa` were sucessfully resolved with `resolve_common`. Not all taxa were resolved. Additional attention will have to be spent on these by either you, or the person that created these data.

### Update data
Now that the taxa have been cleaned as best they can, it's time to create a copy of the raw table and update it with the resolved information.

```
# View the documentation for update_data
?update_data
output <- update_data(path = my_path, x = data, col = 'Species', sep = '\t')
```

An updated version of the raw data table has been written to the directory specified by path.

