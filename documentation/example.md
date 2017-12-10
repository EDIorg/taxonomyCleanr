# Instructions for taxonCleanr

### Overview

The taxonCleanr will help you clean your taxonomic data.

#### Installation

Install from the GitHub.

```
# Install and load devtools
install.packages("devtools")
library(devtools)

# Install and load taxonCleanr
install_github("EDIorg/EMLassemblyline")
library(EMLassemblyline)
```


### Step 1: Create a directory for your dataset

Create a new directory for your dataset. This is where the metadata parts created in the assembly line process will be stored and available for editing should you need to change the content of your EML.

Name this directory after your dataset. Replace spaces with underscores (e.g. `name of your directory` should be `name_of_your_directory`).

### Step 2: Move your dataset to the directory

Move copies of the final versions of your data tables into this directory. These should be the final versions of the data you are ready to publish.

Rename these files following these rules:

* replace symbols with words
* replace parentheses with underscores
* replace periods with underscores
* replace blank spaces with underscores

e.g. `name.of.(your) d@t@.file` should be `name_of_your_data_file`


### Step 3: Identfy the types of data in your dataset

Currently, the assembly line only works for tabular data and is the default option.

#### table

A flat file composed of columns containing variables and rows containing observations. Column names must follow these rules:

* replace symbols with words
* replace parentheses with underscores
* replace periods with underscores
* replace blank spaces with underscores

e.g. `land.cover.use (%)` should be `percent_land_cover_use`


### Step 4: Resolve names

```
# Resolve taxonomic names
resolve_names(path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\plant_data",
              data.file = "e249_Plant_aboveground_biomass_data",
              taxon.col = "Species",
              method = "interactive")
```


### Step 5: Resolve names

```
# Update data
update_data(path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\plant_data",
              data.file = "e249_Plant_aboveground_biomass_data",
              taxon.col = "Species")
```

### Step 6: make taxonomicCoverage

```
# Make taxonomicCoverage EML snippet
make_taxonomicCoverage(path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\plant_data")
```
