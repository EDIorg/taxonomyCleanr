# Instructions for the taxonomyCleanr

### Overview

The process of cleaning your taxonomy data and generating the associated metadata is rather straight forward (Figure 1). First, you send your data through the `resolve_taxa` function to correct spelling errors, get taxonomic serial numbers (TSNs) and taxonomic ranks. Second, you run `update_data` to create a revision of your raw data containing the cleaned taxa. Third, run `make_taxonomicCoverage` to create the taxonomicCoverage EML metadata node. The resultant taxonomicCoverage.xml file can be later incorporated into the full EML metadata for your data using the [`EMLassemblyline`](https://github.com/EDIorg/EMLassemblyline) or [`ecocomDP`](https://github.com/EDIorg/ecocomDP) R packages.

![](https://github.com/EDIorg/taxonomyCleanr/blob/master/documentation/overview.png)

Figure 1: An overview of the taxa cleaning and metadata creation process.

### Installation

Install the `taxonomyCleanr` from the GitHub.

```
# Install and load devtools
install.packages("devtools")
library(devtools)

# Install and load taxonomyCleanr
install_github("EDIorg/taxonomyCleanr")
library(taxonomyCleanr)
```

### Step 1: Prepare dataset for the taxonomyCleanr

#### Create a directory for the dataset

Create a new directory for your dataset. This is where outputs from the `taxonomyCleanr` will be stored and referenced by functions of the `taxonomyCleanr`. Name this directory after your dataset. Replace spaces with underscores (e.g. `name of your directory` should be `name_of_your_directory`).

#### Move the dataset into the directory

Move copies of your data tables into this directory.

Rename these files following these rules:

* replace symbols with words
* replace parentheses with underscores
* replace periods with underscores
* replace blank spaces with underscores

e.g. `name.of.(your) d@t@.file` should be `name_of_your_data_file`

#### Format names of the data table and columns

Data input to the `taxonomyCleanr` must be a table composed of columns with variables (first row) and rows containing observations (subsequent rows). Column names must follow these rules:

* replace symbols with words
* replace parentheses with underscores
* replace periods with underscores
* replace blank spaces with underscores

e.g. `land.cover.use (%)` should be `percent_land_cover_use`

#### Format taxonomy data

Your taxonomy data must be contained within a single column and may contain a mix of:
* Species binomials
* Rank specific names
* Common names

### Step 2: Resolve data to a taxonomic authority

The `taxonomyCleanr` resolves against the [Integrated Taxonomic Information System (ITIS)](https://www.itis.gov/). Additional authority options will be made available soon.

Correct spelling errors, get taxonomic serial numbers (TSNs), and obtain taxa ranks. There are 3 methods for accomplishing this (Figure 2).

![](https://github.com/EDIorg/taxonomyCleanr/blob/master/documentation/resolve_taxa.png)
Figure 2: The 3 methods by which you can resolve your taxonomy data to an authority.

#### Methods:

1. **Manual** Use this option if you are not able to pass judgement on the taxa. This is a good option if you are a data manager helping a data provider clean their taxa. However, this is also a good option if you can pass judgement on the taxonomic data (see notes on short comings of the interactive method below). The output of the manual method is the taxon_choices.csv file, a comma delimited table containing the raw taxa list with corresponding authority resolved options to select from. After the manual selection process has completed, taxon_choices.csv is converted to taxon_map.csv using `choices2map`. taxon_map.csv contains the relationships between your raw taxa and your authority resolved taxa.
2. **Interactive** Use this option if you are able to pass judgement on the correct identification of the taxa contained in the dataset you are cleaning. When `resolve_taxa` encounters multiple authority options for a taxon you will be prompted to select which option to use. Selections made during this interactive session will be recorded to the taxon_map.csv file containing the relationships between your raw taxa and your authority resolved taxa. This option has a few issues to be aware of:
    + You cannot stop and save your work part way through the name resolution process and resume later. You will have to start over from the beginning, which may be cumbersome for large taxa lists.
    + If you want to revisit the options for a single taxon, you will have to revisit and pass judgement on all the other taxon that don't have issues.
    + There is no way to reverse a decision made during the interactive session. Once you select a taxon and press enter, there is no way to change your input.
3. **Automatic** Use this option if you are able to pass judgement on the taxa, and don't have a data provider to work with in selecting from multiple options when they arise. This option resolves the fewest number of taxa to an authority but is sometimes the only option.

The `resolve_taxa` function requires a few arguments:
* **path** A path of the directory containing the taxonomy data.
* **data.file** Name of the data table containing the taxonomy data.
* **taxon.col** Name of the column in data.file containing the taxa.
* **method** Method for resolving your taxa to an authority. There are 3 options (see above for descriptions):
    + manual
    + interactive
    + automatic

#### Resolving taxa using the "manual" method:

```
# View documentation for resolve_taxa
?resolve_taxa

# Resolve taxa using the manual method
resolve_taxa(path = "/Users/csmith/Desktop/taxonomy_dataset",
              data.file = "plant_survey.csv",
              taxon.col = "Species",
              method = "manual")

```

This function call will output the comma delimited taxon_choices.csv file to your dataset directory. Open this with a spreadsheet editor. This file contains the columns:
* **selection** A column for marking which matches you want to make between your raw taxa and the list of authority matches.
* **user_supplied_name** Contains the unique taxa from your raw data table. Each taxon is listed once if there is only one authority match. Each taxon is repeated if there is more than one authority match.
* **authority_match** Contains the possible authority matches for taxa listed in the user_supplied_name column. There may be more than one authority match for each of your user supplied names.
* **name_usage** Indicates whether the authority match is accepted, not accepted or valid for your user supplied name.
* **authority_name** Contains the authority name from which the authority match was derived from. Only ITIS is currently supported.
* **authority_taxon_id** The taxonomic serial number provided by the taxonomic authority for an authority match to your user supplied name.

Now select which matches to make for your taxa. Select one match for each unique user supplied name by entering `x` in the *selection* column and on the line of the match. You should use matches that are *accepted* over matches that are *valid* or *not accepted*. NOTE: 
    + An `x` has been added to rows where there are no options for selecting a different match.
    + When no authority match could be made, you will see empty values in the *authority_match*, *name_usage*, *authority_name*, and *authority_taxon_id* columns. You may want to conduct a manual search of ITIS to see if you can find a match and then add the associated information to the *authority_name* and *authority_taxon_id* columns of the taxon_choices.csv file (*authority_match* and *name_usage* information is not required). If you can't find a match, then leave the contents as is. There is no harm in leaving this information in the file.
    + A blank line has been added between each user supplied taxa that has multiple authority matches. This improves the readability of taxon_choices.csv.
    
Once you've completed the manual selection process, you will need to create the taxon_map.csv file. Use `choices2map` to do this. `choices2map` requires one argument:
* **path** A path of the directory containing the taxon_choices.csv file.

```
# View documentation for this function
?choices2map

# Run choices2map to convert taxon_choices.csv to taxon_map.csv
choices2map(path = "/Users/csmith/Desktop/taxonomy_dataset")

```
`choices2map` outputs taxon_map.csv containing the relationships between your raw taxa list, the authority matched taxa, and corresponding TSNs, and taxon ranks. Open this comma delimited file in a spreadsheet editor. The columns of taxon_map.csv are:
* **user_supplied_name** Containing the unique taxa from your raw dataset.
* **matched_name** Containing the authority match. If this field is blank you may want to look up the user_supplied_name in ITIS to see if you can find a match. If you do then enter the name in this column.
* **data_source_title** Name of the authority from which the match was made. If this field is blank you may want to look up the authority match in ITIS. If you find a match enter "ITIS" in this column.
* **authority_taxon_id** The TSN provided by the taxonomic authority. If this field is blank you may want to look up the authority match in ITIS and see if you can find the TSN for this taxon.
* **taxon_rank** Rank value of the authority match. If this field is blank you may want to look up the authority match in ITIS and see if you can find the associated taxon rank.

## Step 3: Update your raw data

Once satisfied with the mapping from your raw taxa list to an authority, you should create a revision of your data with the updated taxa information using `update_data` (Figure 3).

![](https://github.com/EDIorg/taxonomyCleanr/blob/master/documentation/update_data.png)
Figure 3: Update your raw data table with `update_data`, which calls on the relationships contained in taxon_map.csv to create the revised table and the taxon.txt table.

The `update_data` function requires a few arguments:
* **path** A path of the directory containing your raw data table and taxon_map.csv file.
* **data.file** Name of the file containing the taxonomy data.
* **taxon.col** Name of the column containing the taxonomic names including species binomials, rank specific names, and or common names.

```
# View documentation for this function
?update_data

# Run update_data to create a revision of the raw data table
update_data(path = "/Users/csmith/Desktop/taxonomy_dataset",
            data.file = "plant_survey.csv",
            taxon.col = "Species")
            
```

`update_data` outputs a revised version of your raw data appended with a time stamp of when the revision occurred, and outputs a table named taxon.txt with a time stamp. These files are output into the dataset working directory.

The revised data file contains these additional columns:
* **taxon.col** The column of your raw data table containing the taxa names. Where a new authority resolved name was found this information has replaced the original contents. When no new authority resolved taxa name was found, then the original content remains unaltered.
* **taxon_rank** The rank of the authority resolved taxa.
* **taxon_authority_system** The taxonomic authority system used to resolve the taxa.
* **taxon_authority_id** The TSN of the taxon from the corresponding authority.

taxon.txt is used to create the taxonomicCoverage EML element for your metadata and is essentially the [taxon table](https://github.com/EDIorg/ecocomDP/blob/master/documentation/model/ecocomDP.png) of the [ecocomDP project](https://github.com/EDIorg/ecocomDP). taxon.txt contains these columns:
* **taxon_id** A column that may be used as a key between taxa listed in taxon.txt and the revised data table. You have to make the relationship between your data table and the taxon_id column of taxon.txt. It is not automatically done for you.
* **taxon_rank** Taxonomic rank of the listed taxa.
* **taxon_name** A list of all the unique taxa present in your revised data table.
* **authority_system** Name of the taxonomic authority system assigning the TSN.
* **authority_taxon_id** The TSN of the taxon from the corresponding authority system.

## Step 4: Create the taxonomicCoverage metadata element

Now that you've cleaned up your taxonomic data it is time to make metadata for it (Figure 4). Adding your newly cleaned taxonomy data to the metadata of your dataset will improve the discovery of your data.

![](https://github.com/EDIorg/taxonomyCleanr/blob/master/documentation/make_eml.png)
Figure 4: Make the taxonomicCoverage EML element for your dataset's taxa.

Create the taxonomicCoverage EML element by *removing the date-time stamp appended to your taxon.txt file* during the `update_data` step, and by calling on the `make_taxonomicCoverage` function. `make_taxonomicCoverage` requires one argument:
* **path** A path of the directory containing the file *taxon.txt*.

```
# View documentation for this function
?make_taxonomicCoverage

# Create the taxonomicCoverage EML element for your data
make_taxonomicCoverage(path = "/Users/csmith/Desktop/taxonomy_dataset")

```

Output to your working directory is the file taxonomicCoverage.xml which contains the taxonomic information in the EML format. The information of this file is incorporated into the EML for your dataset using the [`EMLassemblyline`](https://github.com/EDIorg/EMLassemblyline).

## Step 5: Create EML metadata for your entire dataset and upload to EDI's respository

Create EML metadata for your dataset using the [`EMLassemblyline`](https://github.com/EDIorg/EMLassemblyline).

Once you've created the EML metadata for your dataset you can upload your data and metadata to the [Environmental Data Initiative repository](https://portal.edirepository.org/nis/home.jsp). Contact EDI to obtain a user account for the data portal at info@environmentaldatainitiative.org.
