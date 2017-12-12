# Instructions for the taxonomyCleanr

### Overview

The process of cleaning and documenting your taxonomy data is rather straight forward (Figure 1). After some initial preparations you send your data through the `resolve_taxa` function to correct spelling errors, get taxonomic serial numbers (TSN), and taxa ranks. The outputs of this step are then passed to the `update_data` function that creates a revision of your raw data containing the resolved taxonomic data obtained in the previous step. You then run the `make_taxonomicCoverage` function to create the EML metadata tree containing all the rank specific information of your taxonomy data. The .xml output is later incorporated into the full EML metadata document you create with the [`EMLassemblyline`](https://github.com/EDIorg/EMLassemblyline) or [`ecocomDP`](https://github.com/EDIorg/ecocomDP) R packages.

![](https://github.com/EDIorg/taxonomyCleanr/blob/master/documentation/overview.png)

Figure 1: An overview of cleaning and documenting your taxonomy data with the taxonomyCleanr R package.

#### Installation

Install from the GitHub.

```
# Install and load devtools
install.packages("devtools")
library(devtools)

# Install and load taxonomyCleanr
install_github("EDIorg/taxonomyCleanr")
library(taxonomyCleanr)
```

### Step 1: Create a directory for your dataset

Create a new directory for your dataset. This is where outputs from the taxonomyCleanr will be stored. Name this directory after your dataset. Replace spaces with underscores (e.g. `name of your directory` should be `name_of_your_directory`).

### Step 2: Move your dataset to the directory

Move copies of your data tables into this directory.

Rename these files following these rules:

* replace symbols with words
* replace parentheses with underscores
* replace periods with underscores
* replace blank spaces with underscores

e.g. `name.of.(your) d@t@.file` should be `name_of_your_data_file`


### Step 3: Format table and column names

The input data to `taxonomyCleanr` must be a table composed of columns containing variables (row 1) and rows containing observations (rows 2, 3, 4, ...). Column names must follow these rules:

* replace symbols with words
* replace parentheses with underscores
* replace periods with underscores
* replace blank spaces with underscores

e.g. `land.cover.use (%)` should be `percent_land_cover_use`

### Step 4: Resolve to a taxonomic authority

Currently `taxonomyCleanr` resolves against the [Integrated Taxonomic Information System (ITIS)](https://www.itis.gov/). Additional authority options will be available soon.

Correct spelling errors, get taxonomic serial numbers (TSN), and obtain taxa ranks for your data. There are 3 methods for for doing this (Figure 2):

![](https://github.com/EDIorg/taxonomyCleanr/blob/master/documentation/resolve_taxa.png)
Figure 2: The 3 methods by which you may resolve your taxonomy data to an authority.

1. **Manual** Use this option if you are not in a position to pass judgement on the taxonomic data. This is a good option if you are a data manager helping a data provider clean their taxonomy data. However, this may be good option for you if you can pass judgement on the taxonomic data (see notes on the interactive method below). The output of manual mode is the taxon_choices.txt file which is a tab delimited table containing the unique taxa of the raw data with corresponding options to select from. After someone has passed through this table selected the correct matches, this file is converted to taxon_map.txt with the `choices2map` function. taxon_map.txt contains the relationships between your raw taxa data and your resolved taxa data.
2. **Interactive** Use this option if you are in a position to pass judgement on the correct identification of the taxa contained in the dataset you are cleaning. When `resolve_taxa` encounters ambiguity with a taxon you will be prompted to select the correct taxon from a list. Your selections made during this interactive session with the RStudio Console window will be recorded to the taxon_map.txt file containing the relationships between your raw taxa data and your resolved taxa data. This option has a few issues you should be aware of:
    + You can not stop and save your work part way through the name resolution process and resume at a later time. You will have to start over from the beginning, which may be cumbersome for large taxa lists.
    + If you want to revisit the options for a single taxon, you will have to revisit and pass judgement on all the other taxon that don't have issues.
    + There is no way to reverse a decision made during the interactive mode. Once you select a taxon and press enter, there is no way to change your input.
3. **Automatic** Use this option if you are not in a position to pass judgement on the taxonomic data, and don't have a data provider to select any options that may arise if there are multiple options for a taxon. This option resolves the fewest number of input taxa to an authority but is sometimes the best option.

The `resolve_taxa` function requires a few arguments:
1. **path** A path of the directory containing the data table containing taxonomic information.
2. **data.file** Name of the input data table containing the taxonomic data.
3. **taxon.col** Name of the column containing the taxonomic names including species binomials, rank specific names, and or common names.
4. **method** Method for resolving your taxonomic data against an authority. There are 3 options (see above for descriptions):
    + manual
    + interactive
    + automatic

```
# View documentation for resolve_taxa
?resolve_taxa

# Resolve taxa using the manual method
resolve_taxa(path = "/Users/csmith/Desktop/taxonomy_dataset",
              data.file = "plant_survey.csv",
              taxon.col = "Species",
              method = "manual")

```

Your working directory now contains the tab delimited taxon_choices.txt file. Open this with a spreadsheet editor. This file contains the columns:
1. **selection** A column for marking which matches you want to make between your raw taxon name and the authority match.
2. **user_supplied_name** Containing the unique taxa from your raw dataset. Each taxon is listed once if there is only one authority match. The name listed in this column will be repeated for each authority match that is available for you to select from.
3. **authority_match** List of possible matches between the user supplied raw taxon data and the authority match.
4. **name_usage** An indication of whether the authority match is accepted, not accepted or valid.
5. **authority_name** Name of the authority queried. As of now only ITIS is supported.
6. **authority_taxon_id** The taxonomic serial number provided by the taxonomic authority.
Now select which matches to make between your user supplied taxon names and the corresponding authority match. Select one match for each unique user supplied name by entering `x` in the *selection* column and on the line you want for the match. You should use matches that are *accepted* over matches that are *valid* or *not accepted*. NOTE: 
    + An `x` has been added to rows where there is no ambiguity in what the user supplied taxon is (you don't need to add an `x` here).
    + When no authority match could be made you will see empty values in the *authority_match*, *name_usage*, *authority_name*, and *authority_taxon_id* columns. You may want to conduct a manual search of ITIS to see if you can find a match. If found, simply add this information to the taxon_choices.txt file. If you can't find a match then leave the file contents as is. There is no harm in leaving this information in the file.
    + A blank line has been added between each group of potential authority matches to a single user supplied taxon. This helps with the readability of the files content.
    
Once you've completed the manual match selection process, you will need to create the taxon_map.txt file. Do this using the `choices2map` function. This function requires one argument:

1. **path** A path of the directory containing the taxon_choices.txt file.

```
# View documentation for this function
?choices2map

# Run the choices2map function to convert taxon_choices.txt to taxon_map.txt
choices2map(path = "/Users/csmith/Desktop/taxonomy_dataset")

```
This function outputs the taxon_map.txt containing the relationships between your raw taxonomic data, the authority matched taxa, and corresponding TSNs, and taxon ranks. Open this tab delimited file in a spreadsheet editor. The fields of taxon_map.txt are:
1. **user_supplied_name** Containing the unique taxa from your raw dataset.
2. **authority_match** Containing the authority recognized match.
3. **authority_name** Name of the authority from which the match came from.
4. **authority_taxon_id** The taxonomic serial number provided by the taxonomic authority. If this field is blank you may want to look up the authority match in ITIS and see if you can find the TSN for this taxon.
5. **taxon_rank** Rank value of the authority match. If this field is blank you may want to look up the authority match in ITIS and see if you can find the taxon rank for this taxon.

## Step 5: Update your raw data table

Once you are satisfied with the mapping from your raw taxa to the authority resolved taxa then you may create a revision of your data table with the `update_data` function. This function uses the information in taxon_map.txt to update your raw data (Figure 3).

![](https://github.com/EDIorg/taxonomyCleanr/blob/master/documentation/update_data.png)
Figure 3: Create a revision of the raw data table using the update_data function, which calls on the relationships contained in taxon_map.txt to create the revised table and the taxon.txt table.

The `update_data` function requires a few arguments:
1. **path** A path of the directory containing the raw data table.
2. **data.file** Name of the data table containing the taxonomic data.
3. **taxon.col** Name of the column containing the taxonomic names including species binomials, rank specific names, and or common names.

```
# View documentation for this function
?update_data

# Run update_data to create a revision of your raw data table
update_data(path = "/Users/csmith/Desktop/taxonomy_dataset",
            data.file = "plant_survey.csv",
            taxon.col = "Species")
            
```

Output from this function is a revised version of your raw data appended with a time stamp of when the revision occured. 

## Step 3: Create metadata
![](https://github.com/EDIorg/taxonomyCleanr/blob/master/documentation/make_eml.png)








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
