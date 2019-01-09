Using the taxonomyCleanr
================

### Overview

The `taxonomyCleanr` is easy to use and requires no taxonomic expertiese. Simply send your data through a series of cleaning functions (`count_taxa`, `trim_taxa`, `replace_taxa`, `remove_taxa`), send the resultant output to the resolver functions (`resolve_sci_taxa`, `resolve_comm_taxa`), and create a revision of your raw data (`revise_taxa`). Voila! Clean taxonomic data!

Below is a demonstration of this process using example data that comes installed with the `taxonomyCleanr` package.

-   [Install taxonomyCleanr](#installation)
-   [Load data](#load-data)
-   [Create taxa map](#create-taxa-map)
-   [Count taxa](#count-taxa)
-   [Trim taxa](#trim-taxa)
-   [Replace taxa](#replace-taxa)
-   [Remove taxa](#remove-taxa)
-   [Resolve scientific taxa](#resolve-scientific-taxa)
-   [Resolve common taxa](#resolve-common-taxa)
-   [Taxa map overview](#taxa-map-overview)
-   [Revise taxa](#revise-taxa)
-   [Make taxonomicCoverage EML](#make-taxonomiccoverage-eml)

### Installation

Install `taxonomyCleanr` from the project GitHub.

``` r
# Install and load devtools (required to install the taxonomyCleanr)
#install.packages('devtools')
library(devtools)
```

``` r
# Install and load taxonomyCleanr from the development branch of the project GitHub
# install_github('EDIorg/taxonomyCleanr')
library(taxonomyCleanr)
```

-   [Back to top](#overview)

### Load data

Load the taxonomic data into RStudio *as a data frame*. The taxa must be listed in a single column of character type class, not factor type class.

``` r
# Load test data installed with the taxonomyCleanr package
data <- read.table(system.file('test_data.txt', package = 'taxonomyCleanr'), header = T, sep = '\t', stringsAsFactors = F)
```

This data table has 6 columns:

-   **Year** - Year the sample was taken
-   **Sample\_Date** - Date the sample was taken
-   **Plot** - Plot number the sample was taken from
-   **Heat\_treatment** - The heat treatment applied to the plot.
-   **Species** - Taxa observed in each sample. NOTE: This column contains species binomials, common names, invalid taxonomic names, taxa names of varying hierarchical ranks, etc. This is the list of taxa we will clean up.
-   **Mass** - Mass of the organism obtained from each sample.

|  Year| Sample\_Date |  Plot| Heat\_Treatment | Species                           |    Mass|
|-----:|:-------------|-----:|:----------------|:----------------------------------|-------:|
|  2007| 8/22/07      |    29| Control         | Mosses                            |  150.53|
|  2007| 8/22/07      |    29| Control         | Unsorted biomass                  |  150.53|
|  2007| 8/24/07      |    29| High            | Achillea millefolium(lanulosa)    |    0.13|
|  2007| 8/24/07      |    29| High            | Achillea millefolium(lanulosa)    |    3.60|
|  2007| 8/24/07      |    29| High            | Achillea millefolium(lanulosa)    |    9.77|
|  2007| 8/24/07      |    29| High            | Crepis tectorum                   |    1.43|
|  2007| 8/24/07      |    29| High            | Cyperus sp.                       |    0.53|
|  2007| 8/23/07      |    29| High            | Euphorbia glyptosperma            |    0.05|
|  2007| 8/24/07      |    29| High            | Lespedeza capitata                |  139.90|
|  2007| 8/21/07      |    29| Low             | Achillea millefolium(lanulosa)    |    0.60|
|  2007| 8/21/07      |    29| Low             | Achillea millefolium(lanulosaaaa) |    1.10|
|  2007| 8/21/07      |    29| Low             | Achillea millefolium(lanulosabb)  |    4.90|
|  2007| 8/21/07      |    29| Low             | Achillea millefolium(lanulosacc)  |    0.87|
|  2007| 8/21/07      |    29| Low             | Cyperus sp.                       |    1.53|
|  2007| 8/20/07      |    29| Low             | Lepidium densiflorum              |    0.05|
|  2007| 8/21/07      |    29| Low             | Lespedeza capitata                |   54.67|
|  2007| 8/21/07      |    29| Low             | Poa pratensis                     |    0.07|
|  2007| 8/21/07      |    29| Low             | Rumex acetosella                  |    0.33|
|  2007| 8/21/07      |    29| Low             | Schizachyrium scoparium           |    0.70|
|  2007| 8/21/07      |    64| Control         | Unsorted biomass                  |  202.55|
|  2007| 8/20/07      |    64| High            | Bouteloua gracilis                |   12.20|
|  2007| 8/20/07      |    64| High            | Cyperus sp.                       |    0.23|
|  2007| 8/20/07      |    64| High            | Koeleria cristata                 |    0.87|
|  2007| 8/20/07      |    64| High            | Lespedeza capitata                |   52.83|
|  2007| 8/20/07      |    64| High            | Liatris aspera                    |    2.80|
|  2007| 8/20/07      |    64| High            | Lupinus perennis                  |   50.90|
|  2007| 8/20/07      |    64| High            | Panicum virgatum                  |    0.43|
|  2007| 8/20/07      |    64| High            | Petalostemum purpureum            |    9.03|
|  2007| 8/20/07      |    64| High            | Petalostemum villosum             |   15.13|
|  2007| 8/20/07      |    64| High            | Poa pratensis                     |    0.23|
|  2007| 8/20/07      |    64| High            | Schizachyrium scoparium           |   23.60|
|  2007| 8/20/07      |    64| High            | Solidago nemoralis                |   32.10|
|  2007| 8/20/07      |    64| High            | Sorghastrum nutans                |    5.53|
|  2007| 8/20/07      |    64| High            | Stipa spartea                     |    4.00|
|  2007| 8/24/07      |    64| Low             | Achillea millefolium(lanulosa)    |    0.83|
|  2007| 8/24/07      |    64| Low             | Andropogon gerardi                |   13.93|
|  2007| 8/24/07      |    64| Low             | Bouteloua curtipendula            |    0.20|
|  2007| 8/24/07      |    64| Low             | Bouteloua gracilis                |   27.10|
|  2007| 8/24/07      |    64| Low             | Coreopsis palmata                 |    4.40|
|  2007| 8/24/07      |    64| Low             | Koeleria cristata                 |    0.83|
|  2007| 8/24/07      |    64| Low             | Lespedeza capitata                |   44.10|
|  2007| 8/24/07      |    64| Low             | Liatris aspera                    |   14.00|
|  2007| 8/24/07      |    64| Low             | Lupinus perennis                  |   27.87|
|  2007| 8/24/07      |    64| Low             | Miscellaneous litter              |    1.87|
|  2007| 8/24/07      |    64| Low             | Petalostemum candidum             |    3.00|
|  2007| 8/24/07      |    64| Low             | Petalostemum purpureum            |    9.33|
|  2007| 8/24/07      |    64| Low             | Schizachyrium scoparium           |   10.97|
|  2007| 8/24/07      |    64| Low             | Solidago rigida                   |   39.57|
|  2007| 8/24/07      |    64| Low             | Sporobolus cryptandrus            |    0.60|
|  2007| 8/20/07      |    69| Control         | Unsorted biomass                  |   58.85|
|  2007| 8/20/07      |    69| High            | Achillea millefolium(lanulosa)    |    3.53|
|  2007| 8/20/07      |    69| High            | Agropyron repens                  |    0.37|
|  2007| 8/20/07      |    69| High            | Aristida basiramea                |    6.53|
|  2007| 8/20/07      |    69| High            | Crepis tectorum                   |    0.83|
|  2007| 8/20/07      |    69| High            | Cyperus sp.                       |    3.17|
|  2007| 8/20/07      |    69| High            | Digitaria sp.                     |    0.10|
|  2007| 8/20/07      |    69| High            | Erigeron canadensis               |    8.33|
|  2007| 8/20/07      |    69| High            | Hedeoma hispida                   |    1.30|
|  2007| 8/20/07      |    69| High            | Lepidium densiflorum              |    0.13|
|  2007| 8/20/07      |    69| High            | Lupinus perennis                  |    0.37|
|  2007| 8/20/07      |    69| High            | Miscellaneous litter              |    0.70|
|  2007| 8/20/07      |    69| High            | Physalis virginiana               |    0.43|
|  2007| 8/20/07      |    69| High            | Taraxicum officinalis             |    0.06|
|  2007| 8/24/07      |    69| Low             | Achillea millefolium(lanulosa)    |    2.97|
|  2007| 8/24/07      |    69| Low             | Agrostis scabra                   |    0.47|
|  2007| 8/24/07      |    69| Low             | Ambrosia artemisiifolia elatior   |    0.47|
|  2007| 8/24/07      |    69| Low             | Aristida basiramea                |    9.53|
|  2007| 8/24/07      |    69| Low             | Bouteloua gracilis                |    0.10|
|  2007| 8/24/07      |    69| Low             | Crepis tectorum                   |    1.33|
|  2007| 8/24/07      |    69| Low             | Cyperus sp.                       |    1.70|
|  2007| 8/24/07      |    69| Low             | Eragrostis spectabilis            |    1.63|
|  2007| 8/24/07      |    69| Low             | Erigeron canadensis               |    2.67|
|  2007| 8/24/07      |    69| Low             | Hedeoma hispida                   |    0.20|
|  2007| 8/24/07      |    69| Low             | Lespedeza capitata                |    0.10|
|  2007| 8/24/07      |    69| Low             | Miscellaneous litter              |    0.93|
|  2007| 8/24/07      |    69| Low             | Physalis virginiana               |    1.97|
|  2007| 8/24/07      |    69| Low             | Schizachyrium scoparium           |    0.23|
|  2007| 8/23/07      |    78| Control         | Amorpha canescens                 |    9.30|
|  2007| 8/21/07      |    78| Control         | Unsorted biomass                  |  216.13|
|  2007| 8/23/07      |    78| High            | Andropogon gerardi                |   22.60|
|  2007| 8/23/07      |    78| High            | Bouteloua gracilis                |    0.73|
|  2007| 8/23/07      |    78| High            | Lespedeza capitata                |    7.03|
|  2007| 8/23/07      |    78| High            | Lupinus perennis                  |   20.90|
|  2007| 8/23/07      |    78| High            | Petalostemum purpureum            |    0.30|
|  2007| 8/23/07      |    78| High            | Poa pratensis                     |    1.30|
|  2007| 8/23/07      |    78| High            | Schizachyrium scoparium           |   10.87|
|  2007| 8/23/07      |    78| High            | Solidago rigida                   |  133.00|
|  2007| 8/23/07      |    78| High            | Sorghastrum nutans                |    1.40|
|  2007| 8/28/07      |    78| Low             | Amorpha canescens                 |   47.80|
|  2007| 8/28/07      |    78| Low             | Andropogon gerardi                |   19.10|
|  2007| 8/28/07      |    78| Low             | Bouteloua gracilis                |    9.93|
|  2007| 8/28/07      |    78| Low             | Coreopsis palmata                 |    1.03|
|  2007| 8/28/07      |    78| Low             | Erigeron canadensis               |    4.17|
|  2007| 8/28/07      |    78| Low             | -9999                             |    9.53|
|  2007| 8/28/07      |    78| Low             | Liatris aspera                    |   11.03|
|  2007| 8/28/07      |    78| Low             | Lupinus perennis                  |   10.27|
|  2007| 8/28/07      |    78| Low             | Petalostemum purpureum            |    6.53|
|  2007| 8/28/07      |    78| Low             | Poa pratensis                     |    0.90|
|  2007| 8/28/07      |    78| Low             | Schizachyrium scoparium           |   10.83|
|  2007| 8/28/07      |    78| Low             | Solidago nemoralis                |    3.43|
|  2007| 8/22/07      |    29| Control         | Mosses                            |  150.53|
|  2007| 8/22/07      |    29| Control         | Yellow Perch                      |  150.53|
|  2007| 8/22/07      |    29| Control         | Rainbow smelt                     |  150.53|
|  2007| 8/22/07      |    29| Control         | Large mouth bass                  |  150.53|
|  2007| 8/28/07      |    78| Low             | Petalostemum S.p.                 |    6.53|
|  2007| 8/28/07      |    78| Low             | Poa Cf.                           |    0.90|
|  2007| 8/28/07      |    78| Low             | Schizachyrium spp.                |   10.83|
|  2007| 8/28/07      |    78| Low             | Petalostemum                      |    6.53|
|  2007| 8/28/07      |    78| Low             | Poa cf...                         |    0.90|
|  2007| 8/28/07      |    78| Low             | Schizachyrium sPp                 |   10.83|
|  2007| 8/24/07      |    64| Low             | \_Koeleria\_cristata              |    0.83|
|  2007| 8/24/07      |    64| Low             | Lespedeza\_capitata               |   44.10|
|  2007| 8/24/07      |    64| Low             | *Liatris\_aspera*                 |   14.00|
|  2007| 8/24/07      |    64| Low             |                                   |    0.83|
|  2007| 8/24/07      |    64| Low             |                                   |   44.10|
|  2007| 8/24/07      |    64| Low             | Oncorhynchus tshawytscha          |   44.10|
|  2007| 8/24/07      |    64| Low             | Oncorhynchus gorbuscha            |   44.10|
|  2007| 8/24/07      |    64| Low             | Oncorhynchus kisutch              |   44.10|

-   [Back to top](#overview)

### Create taxa map

The taxa map (taxa\_map.csv) links the raw data to the cleaned data. Each cleaning function logs changes to taxa\_map.csv thereby facilitating an understanding of how the data were changed and a means by which to update the raw data table. A thorough explanation of the maps contents will be provided after the cleaning and resolver processes have been run on these example data.

``` r
# Create the taxa map
my_path <- 'C:/Users/Colin/Documents/data'
taxa_map <- create_taxa_map(path = my_path, x = data, col = 'Species')
```

-   [Back to top](#overview)

### Count taxa

Get the unique taxa names and respective counts with `count_taxa`. This function helps identify issues that should be fixed before sending the taxa list to the resolver functions. Doing so increases the success of an authority match. Notice, some of the taxa in the test data are obviously misspelled (e.g. *Achillea millefolium(lanulosa)* and *Achillea millefolium(lanulosaaaa)* likely represent the same taxon), and some of the listed names are clearly not taxa (e.g. *-9999* and *Miscellaneous litter*).

``` r
# Get unique taxa and counts
output <- count_taxa(x = data, col = 'Species', path = my_path)
```

| Taxa                              |  Count|
|:----------------------------------|------:|
|                                   |      2|
| -9999                             |      1|
| \_Koeleria\_cristata              |      1|
| *Liatris\_aspera*                 |      1|
| Achillea millefolium(lanulosa)    |      7|
| Achillea millefolium(lanulosaaaa) |      1|
| Achillea millefolium(lanulosabb)  |      1|
| Achillea millefolium(lanulosacc)  |      1|
| Agropyron repens                  |      1|
| Agrostis scabra                   |      1|
| Ambrosia artemisiifolia elatior   |      1|
| Amorpha canescens                 |      2|
| Andropogon gerardi                |      3|
| Aristida basiramea                |      2|
| Bouteloua curtipendula            |      1|
| Bouteloua gracilis                |      5|
| Coreopsis palmata                 |      2|
| Crepis tectorum                   |      3|
| Cyperus sp.                       |      5|
| Digitaria sp.                     |      1|
| Eragrostis spectabilis            |      1|
| Erigeron canadensis               |      3|
| Euphorbia glyptosperma            |      1|
| Hedeoma hispida                   |      2|
| Koeleria cristata                 |      2|
| Large mouth bass                  |      1|
| Lepidium densiflorum              |      2|
| Lespedeza capitata                |      6|
| Lespedeza\_capitata               |      1|
| Liatris aspera                    |      3|
| Lupinus perennis                  |      5|
| Miscellaneous litter              |      3|
| Mosses                            |      2|
| Oncorhynchus gorbuscha            |      1|
| Oncorhynchus kisutch              |      1|
| Oncorhynchus tshawytscha          |      1|
| Panicum virgatum                  |      1|
| Petalostemum                      |      1|
| Petalostemum candidum             |      1|
| Petalostemum purpureum            |      4|
| Petalostemum S.p.                 |      1|
| Petalostemum villosum             |      1|
| Physalis virginiana               |      2|
| Poa Cf.                           |      1|
| Poa cf...                         |      1|
| Poa pratensis                     |      4|
| Rainbow smelt                     |      1|
| Rumex acetosella                  |      1|
| Schizachyrium scoparium           |      6|
| Schizachyrium sPp                 |      1|
| Schizachyrium spp.                |      1|
| Solidago nemoralis                |      2|
| Solidago rigida                   |      2|
| Sorghastrum nutans                |      2|
| Sporobolus cryptandrus            |      1|
| Stipa spartea                     |      1|
| Taraxicum officinalis             |      1|
| Unsorted biomass                  |      4|
| Yellow Perch                      |      1|

-   [Back to top](#overview)

### Trim taxa

Several of the taxa have variations of common suffixes found in taxonomic data (e.g. *c.f.* and *sp.*), but frequently cause issues when searching taxonomic authorities. The `trim_taxa` function removes these excess characters as well as leading and trailing white spaces and under score characters.

``` r
# Trim excess characters from the taxa list
output <- trim_taxa(path = my_path)
```

Running `count_taxa` on the raw data frame (i.e. *data*), in combination with the information logged to taxa\_map.csv from `trim_taxa`, creates a view of the updated taxa list.

``` r
# View the taxa after running trim_taxa
output <- count_taxa(x = data, col = 'Species', path = my_path)
```

| Taxa                              |  Count|
|:----------------------------------|------:|
|                                   |      2|
| -9999                             |      1|
| Achillea millefolium(lanulosa)    |      7|
| Achillea millefolium(lanulosaaaa) |      1|
| Achillea millefolium(lanulosabb)  |      1|
| Achillea millefolium(lanulosacc)  |      1|
| Agropyron repens                  |      1|
| Agrostis scabra                   |      1|
| Ambrosia artemisiifolia elatior   |      1|
| Amorpha canescens                 |      2|
| Andropogon gerardi                |      3|
| Aristida basiramea                |      2|
| Bouteloua curtipendula            |      1|
| Bouteloua gracilis                |      5|
| Coreopsis palmata                 |      2|
| Crepis tectorum                   |      3|
| Cyperus                           |      5|
| Digitaria                         |      1|
| Eragrostis spectabilis            |      1|
| Erigeron canadensis               |      3|
| Euphorbia glyptosperma            |      1|
| Hedeoma hispida                   |      2|
| Koeleria cristata                 |      3|
| Large mouth bass                  |      1|
| Lepidium densiflorum              |      2|
| Lespedeza capitata                |      7|
| Liatris aspera                    |      4|
| Lupinus perennis                  |      5|
| Miscellaneous litter              |      3|
| Mosses                            |      2|
| Oncorhynchus gorbuscha            |      1|
| Oncorhynchus kisutch              |      1|
| Oncorhynchus tshawytscha          |      1|
| Panicum virgatum                  |      1|
| Petalostemum                      |      2|
| Petalostemum candidum             |      1|
| Petalostemum purpureum            |      4|
| Petalostemum villosum             |      1|
| Physalis virginiana               |      2|
| Poa                               |      2|
| Poa pratensis                     |      4|
| Rainbow smelt                     |      1|
| Rumex acetosella                  |      1|
| Schizachyrium                     |      2|
| Schizachyrium scoparium           |      6|
| Solidago nemoralis                |      2|
| Solidago rigida                   |      2|
| Sorghastrum nutans                |      2|
| Sporobolus cryptandrus            |      1|
| Stipa spartea                     |      1|
| Taraxicum officinalis             |      1|
| Unsorted biomass                  |      4|
| Yellow Perch                      |      1|

-   [Back to top](#overview)

### Replace taxa

Some of the taxa are misspelled. Use `replace_taxa` to replace the misspelled taxa with the correct spelling, or the best guess of the correct spelling. Use `count_taxa` to verify these changes.

``` r
# Replace misspelled taxa with the correct spelling
output <- replace_taxa(path = my_path, input = 'Achillea millefolium(lanulosa)', output = 'Achillea millefolium')
output <- replace_taxa(path = my_path, input = 'Achillea millefolium(lanulosaaaa)', output = 'Achillea millefolium')
output <- replace_taxa(path = my_path, input = 'Achillea millefolium(lanulosabb)', output = 'Achillea millefolium')
output <- replace_taxa(path = my_path, input = 'Achillea millefolium(lanulosacc)', output = 'Achillea millefolium')

# Get the list of unique taxa
output <- count_taxa(x = data, col = 'Species', path = my_path)
```

| Taxa                            |  Count|
|:--------------------------------|------:|
|                                 |      2|
| -9999                           |      1|
| Achillea millefolium            |     10|
| Agropyron repens                |      1|
| Agrostis scabra                 |      1|
| Ambrosia artemisiifolia elatior |      1|
| Amorpha canescens               |      2|
| Andropogon gerardi              |      3|
| Aristida basiramea              |      2|
| Bouteloua curtipendula          |      1|
| Bouteloua gracilis              |      5|
| Coreopsis palmata               |      2|
| Crepis tectorum                 |      3|
| Cyperus                         |      5|
| Digitaria                       |      1|
| Eragrostis spectabilis          |      1|
| Erigeron canadensis             |      3|
| Euphorbia glyptosperma          |      1|
| Hedeoma hispida                 |      2|
| Koeleria cristata               |      3|
| Large mouth bass                |      1|
| Lepidium densiflorum            |      2|
| Lespedeza capitata              |      7|
| Liatris aspera                  |      4|
| Lupinus perennis                |      5|
| Miscellaneous litter            |      3|
| Mosses                          |      2|
| Oncorhynchus gorbuscha          |      1|
| Oncorhynchus kisutch            |      1|
| Oncorhynchus tshawytscha        |      1|
| Panicum virgatum                |      1|
| Petalostemum                    |      2|
| Petalostemum candidum           |      1|
| Petalostemum purpureum          |      4|
| Petalostemum villosum           |      1|
| Physalis virginiana             |      2|
| Poa                             |      2|
| Poa pratensis                   |      4|
| Rainbow smelt                   |      1|
| Rumex acetosella                |      1|
| Schizachyrium                   |      2|
| Schizachyrium scoparium         |      6|
| Solidago nemoralis              |      2|
| Solidago rigida                 |      2|
| Sorghastrum nutans              |      2|
| Sporobolus cryptandrus          |      1|
| Stipa spartea                   |      1|
| Taraxicum officinalis           |      1|
| Unsorted biomass                |      4|
| Yellow Perch                    |      1|

-   [Back to top](#overview)

### Remove taxa

Some taxa in the list are clearly not taxa, and should be removed with `remove_taxa` before attempting to resolve to an authority.

``` r
# Remove taxa
output <- remove_taxa(path = my_path, input = '')
output <- remove_taxa(path = my_path, input = '-9999')
output <- remove_taxa(path = my_path, input = 'Unsorted biomass')
output <- remove_taxa(path = my_path, input = 'Miscellaneous litter')

# Get unique taxa and counts
output <- count_taxa(x = data, col = 'Species', path = my_path)
```

| Taxa                            |  Count|
|:--------------------------------|------:|
| Achillea millefolium            |     10|
| Agropyron repens                |      1|
| Agrostis scabra                 |      1|
| Ambrosia artemisiifolia elatior |      1|
| Amorpha canescens               |      2|
| Andropogon gerardi              |      3|
| Aristida basiramea              |      2|
| Bouteloua curtipendula          |      1|
| Bouteloua gracilis              |      5|
| Coreopsis palmata               |      2|
| Crepis tectorum                 |      3|
| Cyperus                         |      5|
| Digitaria                       |      1|
| Eragrostis spectabilis          |      1|
| Erigeron canadensis             |      3|
| Euphorbia glyptosperma          |      1|
| Hedeoma hispida                 |      2|
| Koeleria cristata               |      3|
| Large mouth bass                |      1|
| Lepidium densiflorum            |      2|
| Lespedeza capitata              |      7|
| Liatris aspera                  |      4|
| Lupinus perennis                |      5|
| Mosses                          |      2|
| Oncorhynchus gorbuscha          |      1|
| Oncorhynchus kisutch            |      1|
| Oncorhynchus tshawytscha        |      1|
| Panicum virgatum                |      1|
| Petalostemum                    |      2|
| Petalostemum candidum           |      1|
| Petalostemum purpureum          |      4|
| Petalostemum villosum           |      1|
| Physalis virginiana             |      2|
| Poa                             |      2|
| Poa pratensis                   |      4|
| Rainbow smelt                   |      1|
| Rumex acetosella                |      1|
| Schizachyrium                   |      2|
| Schizachyrium scoparium         |      6|
| Solidago nemoralis              |      2|
| Solidago rigida                 |      2|
| Sorghastrum nutans              |      2|
| Sporobolus cryptandrus          |      1|
| Stipa spartea                   |      1|
| Taraxicum officinalis           |      1|
| Yellow Perch                    |      1|

-   [Back to top](#overview)

### Resolve scientific taxa

Now the list of taxa looks reasonable. Extraneous characters have been removed, occurences of similarly spelled taxa have been harmonized, and non-taxa names have been removed. Send the list of taxa to `resolve_sci_taxa`, along with a preferred list of authorities to search, and successful hits will return the accepted scientific spelling, taxonomic serial number, and taxonomic rank. `resolve_sci_taxa` will give preference to the ordering of the taxonomic authorites input to the function. View the list of authorities supported by `resolve_sci_taxa` with `view_taxa_authorities`

``` r
# Supported authorities are listed in the column titled resolve_sci_taxa
view_taxa_authorities()
```

|   id| authority                                       | resolve\_sci\_taxa | resolve\_comm\_taxa |
|----:|:------------------------------------------------|:-------------------|:--------------------|
|    1| Catalogue of Life (COL)                         | supported          | not supported       |
|    3| Integrated Taxonomic Information System (ITIS)  | supported          | supported           |
|    9| World Register of Marine Species (WORMS)        | supported          | not supported       |
|   11| Global Biodiversity Information Facility (GBIF) | supported          | not supported       |
|   12| Encyclopedia of Life (EOL)                      | not supported      | supported           |
|  165| Tropicos - Missouri Botanical Garden            | supported          | not supported       |

The authorities *ITIS* and *WORMS* will be used.

``` r
# Resolve taxa using ITIS and WORMS
resolve_sci_taxa(path = my_path, data.sources = c(3,9))
```

    ##                             taxa_raw       taxa_trimmed
    ## 1                             Mosses               <NA>
    ## 2                   Unsorted biomass               <NA>
    ## 3     Achillea millefolium(lanulosa)               <NA>
    ## 4                    Crepis tectorum               <NA>
    ## 5                        Cyperus sp.            Cyperus
    ## 6             Euphorbia glyptosperma               <NA>
    ## 7                 Lespedeza capitata               <NA>
    ## 8  Achillea millefolium(lanulosaaaa)               <NA>
    ## 9   Achillea millefolium(lanulosabb)               <NA>
    ## 10  Achillea millefolium(lanulosacc)               <NA>
    ## 11              Lepidium densiflorum               <NA>
    ## 12                     Poa pratensis               <NA>
    ## 13                  Rumex acetosella               <NA>
    ## 14           Schizachyrium scoparium               <NA>
    ## 15                Bouteloua gracilis               <NA>
    ## 16                 Koeleria cristata               <NA>
    ## 17                    Liatris aspera               <NA>
    ## 18                  Lupinus perennis               <NA>
    ## 19                  Panicum virgatum               <NA>
    ## 20            Petalostemum purpureum               <NA>
    ## 21             Petalostemum villosum               <NA>
    ## 22                Solidago nemoralis               <NA>
    ## 23                Sorghastrum nutans               <NA>
    ## 24                     Stipa spartea               <NA>
    ## 25                Andropogon gerardi               <NA>
    ## 26            Bouteloua curtipendula               <NA>
    ## 27                 Coreopsis palmata               <NA>
    ## 28              Miscellaneous litter               <NA>
    ## 29             Petalostemum candidum               <NA>
    ## 30                   Solidago rigida               <NA>
    ## 31            Sporobolus cryptandrus               <NA>
    ## 32                  Agropyron repens               <NA>
    ## 33                Aristida basiramea               <NA>
    ## 34                     Digitaria sp.          Digitaria
    ## 35               Erigeron canadensis               <NA>
    ## 36                   Hedeoma hispida               <NA>
    ## 37               Physalis virginiana               <NA>
    ## 38             Taraxicum officinalis               <NA>
    ## 39                   Agrostis scabra               <NA>
    ## 40   Ambrosia artemisiifolia elatior               <NA>
    ## 41            Eragrostis spectabilis               <NA>
    ## 42                 Amorpha canescens               <NA>
    ## 43                             -9999               <NA>
    ## 44                      Yellow Perch               <NA>
    ## 45                     Rainbow smelt               <NA>
    ## 46                  Large mouth bass               <NA>
    ## 47                 Petalostemum S.p.       Petalostemum
    ## 48                           Poa Cf.                Poa
    ## 49                Schizachyrium spp.      Schizachyrium
    ## 50                      Petalostemum               <NA>
    ## 51                         Poa cf...                Poa
    ## 52                 Schizachyrium sPp      Schizachyrium
    ## 53                _Koeleria_cristata  Koeleria cristata
    ## 54                Lespedeza_capitata Lespedeza capitata
    ## 55                  _Liatris_aspera_     Liatris aspera
    ## 56                              <NA>               <NA>
    ## 57          Oncorhynchus tshawytscha               <NA>
    ## 58            Oncorhynchus gorbuscha               <NA>
    ## 59              Oncorhynchus kisutch               <NA>
    ##        taxa_replacement taxa_removed                      taxa_clean
    ## 1                  <NA>           NA                            <NA>
    ## 2                  <NA>         TRUE                            <NA>
    ## 3  Achillea millefolium           NA            Achillea millefolium
    ## 4                  <NA>           NA                 Crepis tectorum
    ## 5                  <NA>           NA                         Cyperus
    ## 6                  <NA>           NA          Euphorbia glyptosperma
    ## 7                  <NA>           NA              Lespedeza capitata
    ## 8  Achillea millefolium           NA            Achillea millefolium
    ## 9  Achillea millefolium           NA            Achillea millefolium
    ## 10 Achillea millefolium           NA            Achillea millefolium
    ## 11                 <NA>           NA            Lepidium densiflorum
    ## 12                 <NA>           NA                   Poa pratensis
    ## 13                 <NA>           NA                Rumex acetosella
    ## 14                 <NA>           NA         Schizachyrium scoparium
    ## 15                 <NA>           NA              Bouteloua gracilis
    ## 16                 <NA>           NA               Koeleria cristata
    ## 17                 <NA>           NA                  Liatris aspera
    ## 18                 <NA>           NA                Lupinus perennis
    ## 19                 <NA>           NA                Panicum virgatum
    ## 20                 <NA>           NA                            <NA>
    ## 21                 <NA>           NA                            <NA>
    ## 22                 <NA>           NA              Solidago nemoralis
    ## 23                 <NA>           NA              Sorghastrum nutans
    ## 24                 <NA>           NA                   Stipa spartea
    ## 25                 <NA>           NA              Andropogon gerardi
    ## 26                 <NA>           NA          Bouteloua curtipendula
    ## 27                 <NA>           NA               Coreopsis palmata
    ## 28                 <NA>         TRUE                            <NA>
    ## 29                 <NA>           NA                            <NA>
    ## 30                 <NA>           NA                 Solidago rigida
    ## 31                 <NA>           NA          Sporobolus cryptandrus
    ## 32                 <NA>           NA                Agropyron repens
    ## 33                 <NA>           NA              Aristida basiramea
    ## 34                 <NA>           NA                       Digitaria
    ## 35                 <NA>           NA             Erigeron canadensis
    ## 36                 <NA>           NA                 Hedeoma hispida
    ## 37                 <NA>           NA             Physalis virginiana
    ## 38                 <NA>           NA            Taraxacum officinale
    ## 39                 <NA>           NA                 Agrostis scabra
    ## 40                 <NA>           NA Ambrosia artemisiifolia elatior
    ## 41                 <NA>           NA          Eragrostis spectabilis
    ## 42                 <NA>           NA               Amorpha canescens
    ## 43                 <NA>         TRUE                            <NA>
    ## 44                 <NA>           NA                            <NA>
    ## 45                 <NA>           NA                            <NA>
    ## 46                 <NA>           NA                            <NA>
    ## 47                 <NA>           NA                            <NA>
    ## 48                 <NA>           NA                             Poa
    ## 49                 <NA>           NA                   Schizachyrium
    ## 50                 <NA>           NA                            <NA>
    ## 51                 <NA>           NA                             Poa
    ## 52                 <NA>           NA                   Schizachyrium
    ## 53                 <NA>           NA               Koeleria cristata
    ## 54                 <NA>           NA              Lespedeza capitata
    ## 55                 <NA>           NA                  Liatris aspera
    ## 56                 <NA>         TRUE                            <NA>
    ## 57                 <NA>           NA        Oncorhynchus tshawytscha
    ## 58                 <NA>           NA          Oncorhynchus gorbuscha
    ## 59                 <NA>           NA            Oncorhynchus kisutch
    ##       rank authority authority_id score difference
    ## 1     <NA>      <NA>         <NA>  <NA>       <NA>
    ## 2     <NA>      <NA>         <NA>  <NA>       <NA>
    ## 3  Species      ITIS        35423 0.988       <NA>
    ## 4  Species      ITIS        37212 0.988       <NA>
    ## 5    Genus      ITIS        39882  0.75       <NA>
    ## 6  Species      ITIS        28074 0.988       <NA>
    ## 7  Species      ITIS        25897 0.988       <NA>
    ## 8  Species      ITIS        35423 0.988       <NA>
    ## 9  Species      ITIS        35423 0.988       <NA>
    ## 10 Species      ITIS        35423 0.988       <NA>
    ## 11 Species      ITIS        22960 0.988       <NA>
    ## 12 Species      ITIS        41088 0.988       <NA>
    ## 13 Species      ITIS        20934 0.988       <NA>
    ## 14 Species      ITIS        42076 0.988       <NA>
    ## 15 Species      ITIS        41493 0.988       <NA>
    ## 16 Species      ITIS       515476 0.988       <NA>
    ## 17 Species      ITIS        37909 0.988       <NA>
    ## 18 Species      ITIS        26091 0.988       <NA>
    ## 19 Species      ITIS        40913 0.988       <NA>
    ## 20    <NA>      <NA>         <NA>  <NA>       <NA>
    ## 21    <NA>      <NA>         <NA>  <NA>       <NA>
    ## 22 Species      ITIS        36281 0.988       <NA>
    ## 23 Species      ITIS        42102 0.988       <NA>
    ## 24 Species      ITIS        42166 0.988       <NA>
    ## 25 Species      ITIS       786156 0.988       <NA>
    ## 26 Species      ITIS        41500 0.988       <NA>
    ## 27 Species      ITIS        37148 0.988       <NA>
    ## 28    <NA>      <NA>         <NA>  <NA>       <NA>
    ## 29    <NA>      <NA>         <NA>  <NA>       <NA>
    ## 30 Species      ITIS        36297 0.988       <NA>
    ## 31 Species      ITIS        42132 0.988       <NA>
    ## 32 Species      ITIS        40382 0.988       <NA>
    ## 33 Species      ITIS        41412 0.988       <NA>
    ## 34   Genus      ITIS        40603  0.75       <NA>
    ## 35 Species      ITIS       196266 0.988       <NA>
    ## 36 Species      ITIS       502890 0.988       <NA>
    ## 37 Species      ITIS        30612 0.988       <NA>
    ## 38 Species      ITIS        36213  0.75       <NA>
    ## 39 Species      ITIS        40424 0.988       <NA>
    ## 40    <NA>      ITIS         <NA> 0.999       <NA>
    ## 41 Species      ITIS        40717 0.988       <NA>
    ## 42 Species      ITIS        25371 0.988       <NA>
    ## 43    <NA>      <NA>         <NA>  <NA>       <NA>
    ## 44    <NA>      <NA>         <NA>  <NA>       <NA>
    ## 45    <NA>      <NA>         <NA>  <NA>       <NA>
    ## 46    <NA>      <NA>         <NA>  <NA>       <NA>
    ## 47    <NA>      <NA>         <NA>  <NA>       <NA>
    ## 48   Genus      ITIS        41074  0.75       <NA>
    ## 49   Genus      ITIS        42069  0.75       <NA>
    ## 50    <NA>      <NA>         <NA>  <NA>       <NA>
    ## 51   Genus      ITIS        41074  0.75       <NA>
    ## 52   Genus      ITIS        42069  0.75       <NA>
    ## 53 Species      ITIS       515476 0.988       <NA>
    ## 54 Species      ITIS        25897 0.988       <NA>
    ## 55 Species      ITIS        37909 0.988       <NA>
    ## 56    <NA>      <NA>         <NA>  <NA>       <NA>
    ## 57 Species      ITIS       161980 0.988       <NA>
    ## 58 Species      ITIS       161975 0.988       <NA>
    ## 59 Species      ITIS       161977 0.988       <NA>

The taxa that could be resolved to *ITIS* and *WORMS* were logged to taxa\_map.csv, along with their taxonomic serial numbers and taxonomic ranks.

-   [Back to top](#overview)

### Resolve common taxa

Some of the taxa that couldn't be resolved by `resolve_sci_taxa` is because their common names were listed. Use `resolve_comm_taxa` to attempt resolution of these common names to an authority. `resolve_comm_taxa` is similar to `resolve_sci_taxa` in that it requires a preferred list of authorities to search against. Select authorities supported by `resolve_comm_taxa`.

``` r
# View the list of authorities supported by resolve_comm_taxa
view_authorities()
```

|   id| authority                                       | resolve\_sci\_taxa | resolve\_comm\_taxa |
|----:|:------------------------------------------------|:-------------------|:--------------------|
|    1| Catalogue of Life (COL)                         | supported          | not supported       |
|    3| Integrated Taxonomic Information System (ITIS)  | supported          | supported           |
|    9| World Register of Marine Species (WORMS)        | supported          | not supported       |
|   11| Global Biodiversity Information Facility (GBIF) | supported          | not supported       |
|   12| Encyclopedia of Life (EOL)                      | not supported      | supported           |
|  165| Tropicos - Missouri Botanical Garden            | supported          | not supported       |

``` r
# Resolve common using ITIS and Encyclopedia of Life
resolve_comm_taxa(path = my_path, data.sources = c(3,12))
```

    ##                             taxa_raw       taxa_trimmed
    ## 1                             Mosses               <NA>
    ## 2                   Unsorted biomass               <NA>
    ## 3     Achillea millefolium(lanulosa)               <NA>
    ## 4                    Crepis tectorum               <NA>
    ## 5                        Cyperus sp.            Cyperus
    ## 6             Euphorbia glyptosperma               <NA>
    ## 7                 Lespedeza capitata               <NA>
    ## 8  Achillea millefolium(lanulosaaaa)               <NA>
    ## 9   Achillea millefolium(lanulosabb)               <NA>
    ## 10  Achillea millefolium(lanulosacc)               <NA>
    ## 11              Lepidium densiflorum               <NA>
    ## 12                     Poa pratensis               <NA>
    ## 13                  Rumex acetosella               <NA>
    ## 14           Schizachyrium scoparium               <NA>
    ## 15                Bouteloua gracilis               <NA>
    ## 16                 Koeleria cristata               <NA>
    ## 17                    Liatris aspera               <NA>
    ## 18                  Lupinus perennis               <NA>
    ## 19                  Panicum virgatum               <NA>
    ## 20            Petalostemum purpureum               <NA>
    ## 21             Petalostemum villosum               <NA>
    ## 22                Solidago nemoralis               <NA>
    ## 23                Sorghastrum nutans               <NA>
    ## 24                     Stipa spartea               <NA>
    ## 25                Andropogon gerardi               <NA>
    ## 26            Bouteloua curtipendula               <NA>
    ## 27                 Coreopsis palmata               <NA>
    ## 28              Miscellaneous litter               <NA>
    ## 29             Petalostemum candidum               <NA>
    ## 30                   Solidago rigida               <NA>
    ## 31            Sporobolus cryptandrus               <NA>
    ## 32                  Agropyron repens               <NA>
    ## 33                Aristida basiramea               <NA>
    ## 34                     Digitaria sp.          Digitaria
    ## 35               Erigeron canadensis               <NA>
    ## 36                   Hedeoma hispida               <NA>
    ## 37               Physalis virginiana               <NA>
    ## 38             Taraxicum officinalis               <NA>
    ## 39                   Agrostis scabra               <NA>
    ## 40   Ambrosia artemisiifolia elatior               <NA>
    ## 41            Eragrostis spectabilis               <NA>
    ## 42                 Amorpha canescens               <NA>
    ## 43                             -9999               <NA>
    ## 44                      Yellow Perch               <NA>
    ## 45                     Rainbow smelt               <NA>
    ## 46                  Large mouth bass               <NA>
    ## 47                 Petalostemum S.p.       Petalostemum
    ## 48                           Poa Cf.                Poa
    ## 49                Schizachyrium spp.      Schizachyrium
    ## 50                      Petalostemum               <NA>
    ## 51                         Poa cf...                Poa
    ## 52                 Schizachyrium sPp      Schizachyrium
    ## 53                _Koeleria_cristata  Koeleria cristata
    ## 54                Lespedeza_capitata Lespedeza capitata
    ## 55                  _Liatris_aspera_     Liatris aspera
    ## 56                              <NA>               <NA>
    ## 57          Oncorhynchus tshawytscha               <NA>
    ## 58            Oncorhynchus gorbuscha               <NA>
    ## 59              Oncorhynchus kisutch               <NA>
    ##        taxa_replacement taxa_removed                      taxa_clean
    ## 1                  <NA>           NA                          Mosses
    ## 2                  <NA>         TRUE                            <NA>
    ## 3  Achillea millefolium           NA            Achillea millefolium
    ## 4                  <NA>           NA                 Crepis tectorum
    ## 5                  <NA>           NA                         Cyperus
    ## 6                  <NA>           NA          Euphorbia glyptosperma
    ## 7                  <NA>           NA              Lespedeza capitata
    ## 8  Achillea millefolium           NA            Achillea millefolium
    ## 9  Achillea millefolium           NA            Achillea millefolium
    ## 10 Achillea millefolium           NA            Achillea millefolium
    ## 11                 <NA>           NA            Lepidium densiflorum
    ## 12                 <NA>           NA                   Poa pratensis
    ## 13                 <NA>           NA                Rumex acetosella
    ## 14                 <NA>           NA         Schizachyrium scoparium
    ## 15                 <NA>           NA              Bouteloua gracilis
    ## 16                 <NA>           NA               Koeleria cristata
    ## 17                 <NA>           NA                  Liatris aspera
    ## 18                 <NA>           NA                Lupinus perennis
    ## 19                 <NA>           NA                Panicum virgatum
    ## 20                 <NA>           NA          Petalostemum purpureum
    ## 21                 <NA>           NA           Petalostemum villosum
    ## 22                 <NA>           NA              Solidago nemoralis
    ## 23                 <NA>           NA              Sorghastrum nutans
    ## 24                 <NA>           NA                   Stipa spartea
    ## 25                 <NA>           NA              Andropogon gerardi
    ## 26                 <NA>           NA          Bouteloua curtipendula
    ## 27                 <NA>           NA               Coreopsis palmata
    ## 28                 <NA>         TRUE                            <NA>
    ## 29                 <NA>           NA           Petalostemum candidum
    ## 30                 <NA>           NA                 Solidago rigida
    ## 31                 <NA>           NA          Sporobolus cryptandrus
    ## 32                 <NA>           NA                Agropyron repens
    ## 33                 <NA>           NA              Aristida basiramea
    ## 34                 <NA>           NA                       Digitaria
    ## 35                 <NA>           NA             Erigeron canadensis
    ## 36                 <NA>           NA                 Hedeoma hispida
    ## 37                 <NA>           NA             Physalis virginiana
    ## 38                 <NA>           NA            Taraxacum officinale
    ## 39                 <NA>           NA                 Agrostis scabra
    ## 40                 <NA>           NA Ambrosia artemisiifolia elatior
    ## 41                 <NA>           NA          Eragrostis spectabilis
    ## 42                 <NA>           NA               Amorpha canescens
    ## 43                 <NA>         TRUE                            <NA>
    ## 44                 <NA>           NA                    Yellow Perch
    ## 45                 <NA>           NA                   Rainbow smelt
    ## 46                 <NA>           NA                Large mouth bass
    ## 47                 <NA>           NA                    Petalostemum
    ## 48                 <NA>           NA                             Poa
    ## 49                 <NA>           NA                   Schizachyrium
    ## 50                 <NA>           NA                    Petalostemum
    ## 51                 <NA>           NA                             Poa
    ## 52                 <NA>           NA                   Schizachyrium
    ## 53                 <NA>           NA               Koeleria cristata
    ## 54                 <NA>           NA              Lespedeza capitata
    ## 55                 <NA>           NA                  Liatris aspera
    ## 56                 <NA>         TRUE                            <NA>
    ## 57                 <NA>           NA        Oncorhynchus tshawytscha
    ## 58                 <NA>           NA          Oncorhynchus gorbuscha
    ## 59                 <NA>           NA            Oncorhynchus kisutch
    ##       rank authority authority_id score difference
    ## 1   Common      ITIS        14189    NA       <NA>
    ## 2     <NA>      <NA>         <NA>    NA       <NA>
    ## 3  Species      ITIS        35423 0.988       <NA>
    ## 4  Species      ITIS        37212 0.988       <NA>
    ## 5    Genus      ITIS        39882 0.750       <NA>
    ## 6  Species      ITIS        28074 0.988       <NA>
    ## 7  Species      ITIS        25897 0.988       <NA>
    ## 8  Species      ITIS        35423 0.988       <NA>
    ## 9  Species      ITIS        35423 0.988       <NA>
    ## 10 Species      ITIS        35423 0.988       <NA>
    ## 11 Species      ITIS        22960 0.988       <NA>
    ## 12 Species      ITIS        41088 0.988       <NA>
    ## 13 Species      ITIS        20934 0.988       <NA>
    ## 14 Species      ITIS        42076 0.988       <NA>
    ## 15 Species      ITIS        41493 0.988       <NA>
    ## 16 Species      ITIS       515476 0.988       <NA>
    ## 17 Species      ITIS        37909 0.988       <NA>
    ## 18 Species      ITIS        26091 0.988       <NA>
    ## 19 Species      ITIS        40913 0.988       <NA>
    ## 20  Common       EOL     49943005    NA       <NA>
    ## 21  Common       EOL         <NA>    NA       <NA>
    ## 22 Species      ITIS        36281 0.988       <NA>
    ## 23 Species      ITIS        42102 0.988       <NA>
    ## 24 Species      ITIS        42166 0.988       <NA>
    ## 25 Species      ITIS       786156 0.988       <NA>
    ## 26 Species      ITIS        41500 0.988       <NA>
    ## 27 Species      ITIS        37148 0.988       <NA>
    ## 28    <NA>      <NA>         <NA>    NA       <NA>
    ## 29  Common       EOL     49943004    NA       <NA>
    ## 30 Species      ITIS        36297 0.988       <NA>
    ## 31 Species      ITIS        42132 0.988       <NA>
    ## 32 Species      ITIS        40382 0.988       <NA>
    ## 33 Species      ITIS        41412 0.988       <NA>
    ## 34   Genus      ITIS        40603 0.750       <NA>
    ## 35 Species      ITIS       196266 0.988       <NA>
    ## 36 Species      ITIS       502890 0.988       <NA>
    ## 37 Species      ITIS        30612 0.988       <NA>
    ## 38 Species      ITIS        36213 0.750       <NA>
    ## 39 Species      ITIS        40424 0.988       <NA>
    ## 40    <NA>      ITIS         <NA> 0.999       <NA>
    ## 41 Species      ITIS        40717 0.988       <NA>
    ## 42 Species      ITIS        25371 0.988       <NA>
    ## 43    <NA>      <NA>         <NA>    NA       <NA>
    ## 44  Common      ITIS       168469    NA       <NA>
    ## 45  Common      ITIS       162041    NA       <NA>
    ## 46  Common       EOL     50027504    NA       <NA>
    ## 47  Common       EOL     49943003    NA       <NA>
    ## 48   Genus      ITIS        41074 0.750       <NA>
    ## 49   Genus      ITIS        42069 0.750       <NA>
    ## 50  Common       EOL     49943003    NA       <NA>
    ## 51   Genus      ITIS        41074 0.750       <NA>
    ## 52   Genus      ITIS        42069 0.750       <NA>
    ## 53 Species      ITIS       515476 0.988       <NA>
    ## 54 Species      ITIS        25897 0.988       <NA>
    ## 55 Species      ITIS        37909 0.988       <NA>
    ## 56    <NA>      <NA>         <NA>    NA       <NA>
    ## 57 Species      ITIS       161980 0.988       <NA>
    ## 58 Species      ITIS       161975 0.988       <NA>
    ## 59 Species      ITIS       161977 0.988       <NA>

-   [Back to top](#overview)

Taxa map overview
=================

Throughout the cleaning process, results have been logged to taxa\_map.csv facilitating understanding of the changes to the raw taxa list. The taxa map will be used to create a revision of the raw taxa list, but first an explanation of the columns of this file is warranted. Information about taxa\_map.csv can also be found in the documentation for `create_taxa_map` (i.e. `?create_taxa_map`). The taxa map has 10 columns:

-   **taxa\_raw** - The unique taxa extracted from the raw data by `create_taxa_map`.
-   **taxa\_trimmed** - Taxa that were operated on by `trim_taxa`, with the resultant name listed.
-   **taxa\_replacement** - Taxa that were operated on by `replace_taxa`, with the resultant replacement listed.
-   **taxa\_removed** - Taxa that were operated on by `remove_taxa`. TRUE if taxa was removed, NA otherwise.
-   **taxa\_clean** - Taxa that were successfully resolved to an authority by `resolve_sci_taxa` or `resolve_comm_taxa`. The listed taxa spelling is accepted by the matched authority.
-   **rank** - Taxonomic rank determined by `resolve_sci_taxa` or a value of *Common* if resolved by `resolve_comm_taxa`.
-   **authority** - Taxonomic authority resolved to by `resolve_sci_taxa` or `resolve_comm_taxa`.
-   **authority\_id** - Identification number/value of the resolved taxon in the taxonomic authority listed under *authority*.
-   **score** - A value given by some authorities as to how well the raw taxon matched the resolved taxon. See the authority for more information.
-   **difference** - TRUE if there is a difference between taxa\_raw and taxa\_clean.

Below is the taxa\_map.csv for the cleaning procedures implemented on the test data. Some noteworthy features of this map:

-   taxa\_trimmed, taxa\_replacement, and taxa\_removed contain values as per the specifications listed above.
-   taxa\_clean contains the accepted spelling of taxa that were able to be resolved to a taxonomic authority. Not all taxa were resolved. In these instances a manual search of an authority is recommended. Often a manual search will reveal additional information that will aid in the resolving of a taxon. Once resolved. The fields taxa\_clean, rank, authority, and authority\_id can be manually updated.
-   rank, authority, and authority\_id contain values if the taxon was resolved, and contains NA otherwise.

| taxa\_raw                         | taxa\_trimmed      | taxa\_replacement    | taxa\_removed | taxa\_clean                     | rank    | authority |  authority\_id|  score| difference |
|:----------------------------------|:-------------------|:---------------------|:--------------|:--------------------------------|:--------|:----------|--------------:|------:|:-----------|
| Mosses                            | NA                 | NA                   | NA            | Mosses                          | Common  | ITIS      |          14189|     NA| NA         |
| Unsorted biomass                  | NA                 | NA                   | TRUE          | NA                              | NA      | NA        |             NA|     NA| NA         |
| Achillea millefolium(lanulosa)    | NA                 | Achillea millefolium | NA            | Achillea millefolium            | Species | ITIS      |          35423|  0.988| NA         |
| Crepis tectorum                   | NA                 | NA                   | NA            | Crepis tectorum                 | Species | ITIS      |          37212|  0.988| NA         |
| Cyperus sp.                       | Cyperus            | NA                   | NA            | Cyperus                         | Genus   | ITIS      |          39882|  0.750| NA         |
| Euphorbia glyptosperma            | NA                 | NA                   | NA            | Euphorbia glyptosperma          | Species | ITIS      |          28074|  0.988| NA         |
| Lespedeza capitata                | NA                 | NA                   | NA            | Lespedeza capitata              | Species | ITIS      |          25897|  0.988| NA         |
| Achillea millefolium(lanulosaaaa) | NA                 | Achillea millefolium | NA            | Achillea millefolium            | Species | ITIS      |          35423|  0.988| NA         |
| Achillea millefolium(lanulosabb)  | NA                 | Achillea millefolium | NA            | Achillea millefolium            | Species | ITIS      |          35423|  0.988| NA         |
| Achillea millefolium(lanulosacc)  | NA                 | Achillea millefolium | NA            | Achillea millefolium            | Species | ITIS      |          35423|  0.988| NA         |
| Lepidium densiflorum              | NA                 | NA                   | NA            | Lepidium densiflorum            | Species | ITIS      |          22960|  0.988| NA         |
| Poa pratensis                     | NA                 | NA                   | NA            | Poa pratensis                   | Species | ITIS      |          41088|  0.988| NA         |
| Rumex acetosella                  | NA                 | NA                   | NA            | Rumex acetosella                | Species | ITIS      |          20934|  0.988| NA         |
| Schizachyrium scoparium           | NA                 | NA                   | NA            | Schizachyrium scoparium         | Species | ITIS      |          42076|  0.988| NA         |
| Bouteloua gracilis                | NA                 | NA                   | NA            | Bouteloua gracilis              | Species | ITIS      |          41493|  0.988| NA         |
| Koeleria cristata                 | NA                 | NA                   | NA            | Koeleria cristata               | Species | ITIS      |         515476|  0.988| NA         |
| Liatris aspera                    | NA                 | NA                   | NA            | Liatris aspera                  | Species | ITIS      |          37909|  0.988| NA         |
| Lupinus perennis                  | NA                 | NA                   | NA            | Lupinus perennis                | Species | ITIS      |          26091|  0.988| NA         |
| Panicum virgatum                  | NA                 | NA                   | NA            | Panicum virgatum                | Species | ITIS      |          40913|  0.988| NA         |
| Petalostemum purpureum            | NA                 | NA                   | NA            | Petalostemum purpureum          | Common  | EOL       |       49943005|     NA| NA         |
| Petalostemum villosum             | NA                 | NA                   | NA            | Petalostemum villosum           | Common  | EOL       |             NA|     NA| NA         |
| Solidago nemoralis                | NA                 | NA                   | NA            | Solidago nemoralis              | Species | ITIS      |          36281|  0.988| NA         |
| Sorghastrum nutans                | NA                 | NA                   | NA            | Sorghastrum nutans              | Species | ITIS      |          42102|  0.988| NA         |
| Stipa spartea                     | NA                 | NA                   | NA            | Stipa spartea                   | Species | ITIS      |          42166|  0.988| NA         |
| Andropogon gerardi                | NA                 | NA                   | NA            | Andropogon gerardi              | Species | ITIS      |         786156|  0.988| NA         |
| Bouteloua curtipendula            | NA                 | NA                   | NA            | Bouteloua curtipendula          | Species | ITIS      |          41500|  0.988| NA         |
| Coreopsis palmata                 | NA                 | NA                   | NA            | Coreopsis palmata               | Species | ITIS      |          37148|  0.988| NA         |
| Miscellaneous litter              | NA                 | NA                   | TRUE          | NA                              | NA      | NA        |             NA|     NA| NA         |
| Petalostemum candidum             | NA                 | NA                   | NA            | Petalostemum candidum           | Common  | EOL       |       49943004|     NA| NA         |
| Solidago rigida                   | NA                 | NA                   | NA            | Solidago rigida                 | Species | ITIS      |          36297|  0.988| NA         |
| Sporobolus cryptandrus            | NA                 | NA                   | NA            | Sporobolus cryptandrus          | Species | ITIS      |          42132|  0.988| NA         |
| Agropyron repens                  | NA                 | NA                   | NA            | Agropyron repens                | Species | ITIS      |          40382|  0.988| NA         |
| Aristida basiramea                | NA                 | NA                   | NA            | Aristida basiramea              | Species | ITIS      |          41412|  0.988| NA         |
| Digitaria sp.                     | Digitaria          | NA                   | NA            | Digitaria                       | Genus   | ITIS      |          40603|  0.750| NA         |
| Erigeron canadensis               | NA                 | NA                   | NA            | Erigeron canadensis             | Species | ITIS      |         196266|  0.988| NA         |
| Hedeoma hispida                   | NA                 | NA                   | NA            | Hedeoma hispida                 | Species | ITIS      |         502890|  0.988| NA         |
| Physalis virginiana               | NA                 | NA                   | NA            | Physalis virginiana             | Species | ITIS      |          30612|  0.988| NA         |
| Taraxicum officinalis             | NA                 | NA                   | NA            | Taraxacum officinale            | Species | ITIS      |          36213|  0.750| NA         |
| Agrostis scabra                   | NA                 | NA                   | NA            | Agrostis scabra                 | Species | ITIS      |          40424|  0.988| NA         |
| Ambrosia artemisiifolia elatior   | NA                 | NA                   | NA            | Ambrosia artemisiifolia elatior | NA      | ITIS      |             NA|  0.999| NA         |
| Eragrostis spectabilis            | NA                 | NA                   | NA            | Eragrostis spectabilis          | Species | ITIS      |          40717|  0.988| NA         |
| Amorpha canescens                 | NA                 | NA                   | NA            | Amorpha canescens               | Species | ITIS      |          25371|  0.988| NA         |
| -9999                             | NA                 | NA                   | TRUE          | NA                              | NA      | NA        |             NA|     NA| NA         |
| Yellow Perch                      | NA                 | NA                   | NA            | Yellow Perch                    | Common  | ITIS      |         168469|     NA| NA         |
| Rainbow smelt                     | NA                 | NA                   | NA            | Rainbow smelt                   | Common  | ITIS      |         162041|     NA| NA         |
| Large mouth bass                  | NA                 | NA                   | NA            | Large mouth bass                | Common  | EOL       |       50027504|     NA| NA         |
| Petalostemum S.p.                 | Petalostemum       | NA                   | NA            | Petalostemum                    | Common  | EOL       |       49943003|     NA| NA         |
| Poa Cf.                           | Poa                | NA                   | NA            | Poa                             | Genus   | ITIS      |          41074|  0.750| NA         |
| Schizachyrium spp.                | Schizachyrium      | NA                   | NA            | Schizachyrium                   | Genus   | ITIS      |          42069|  0.750| NA         |
| Petalostemum                      | NA                 | NA                   | NA            | Petalostemum                    | Common  | EOL       |       49943003|     NA| NA         |
| Poa cf...                         | Poa                | NA                   | NA            | Poa                             | Genus   | ITIS      |          41074|  0.750| NA         |
| Schizachyrium sPp                 | Schizachyrium      | NA                   | NA            | Schizachyrium                   | Genus   | ITIS      |          42069|  0.750| NA         |
| \_Koeleria\_cristata              | Koeleria cristata  | NA                   | NA            | Koeleria cristata               | Species | ITIS      |         515476|  0.988| NA         |
| Lespedeza\_capitata               | Lespedeza capitata | NA                   | NA            | Lespedeza capitata              | Species | ITIS      |          25897|  0.988| NA         |
| *Liatris\_aspera*                 | Liatris aspera     | NA                   | NA            | Liatris aspera                  | Species | ITIS      |          37909|  0.988| NA         |
| NA                                | NA                 | NA                   | TRUE          | NA                              | NA      | NA        |             NA|     NA| NA         |
| Oncorhynchus tshawytscha          | NA                 | NA                   | NA            | Oncorhynchus tshawytscha        | Species | ITIS      |         161980|  0.988| NA         |
| Oncorhynchus gorbuscha            | NA                 | NA                   | NA            | Oncorhynchus gorbuscha          | Species | ITIS      |         161975|  0.988| NA         |
| Oncorhynchus kisutch              | NA                 | NA                   | NA            | Oncorhynchus kisutch            | Species | ITIS      |         161977|  0.988| NA         |

-   [Back to top](#overview)

### Revise taxa

Now that the taxa have been cleaned, as best they can, the raw data table can be updated with the new taxonomic information. This new information is contained in 4 new columns, which have the same definitions as listed in the taxa map:

-   **taxa\_clean** - Taxa that were successfully resolved to an authority. The listed taxa spelling is accepted by the matched authority.
-   **taxa\_rank** - Taxonomic rank.
-   **taxa\_authority** - Taxonomic authority that was resolved.
-   **taxa\_authority\_id** - Identification number/value of the resolved taxon in the taxonomic authority.

These 4 columns are appended to the raw data table and written to a file named "taxonomyCleanr\_output".

``` r
# Revise the raw data table and write to file
revise_taxa(path = my_path, x = data, col = 'Species', sep = '\t')
```

    ##      Year Sample_Date Plot Heat_Treatment
    ## 1    2007     8/22/07   29        Control
    ## 2    2007     8/22/07   29        Control
    ## 3    2007     8/24/07   29           High
    ## 3.1  2007     8/24/07   29           High
    ## 3.2  2007     8/24/07   29           High
    ## 4    2007     8/24/07   29           High
    ## 5    2007     8/24/07   29           High
    ## 6    2007     8/23/07   29           High
    ## 7    2007     8/24/07   29           High
    ## 3.3  2007     8/21/07   29            Low
    ## 8    2007     8/21/07   29            Low
    ## 9    2007     8/21/07   29            Low
    ## 10   2007     8/21/07   29            Low
    ## 5.1  2007     8/21/07   29            Low
    ## 11   2007     8/20/07   29            Low
    ## 7.1  2007     8/21/07   29            Low
    ## 12   2007     8/21/07   29            Low
    ## 13   2007     8/21/07   29            Low
    ## 14   2007     8/21/07   29            Low
    ## 2.1  2007     8/21/07   64        Control
    ## 15   2007     8/20/07   64           High
    ## 5.2  2007     8/20/07   64           High
    ## 16   2007     8/20/07   64           High
    ## 7.2  2007     8/20/07   64           High
    ## 17   2007     8/20/07   64           High
    ## 18   2007     8/20/07   64           High
    ## 19   2007     8/20/07   64           High
    ## 20   2007     8/20/07   64           High
    ## 21   2007     8/20/07   64           High
    ## 12.1 2007     8/20/07   64           High
    ## 14.1 2007     8/20/07   64           High
    ## 22   2007     8/20/07   64           High
    ## 23   2007     8/20/07   64           High
    ## 24   2007     8/20/07   64           High
    ## 3.4  2007     8/24/07   64            Low
    ## 25   2007     8/24/07   64            Low
    ## 26   2007     8/24/07   64            Low
    ## 15.1 2007     8/24/07   64            Low
    ## 27   2007     8/24/07   64            Low
    ## 16.1 2007     8/24/07   64            Low
    ## 7.3  2007     8/24/07   64            Low
    ## 17.1 2007     8/24/07   64            Low
    ## 18.1 2007     8/24/07   64            Low
    ## 28   2007     8/24/07   64            Low
    ## 29   2007     8/24/07   64            Low
    ## 20.1 2007     8/24/07   64            Low
    ## 14.2 2007     8/24/07   64            Low
    ## 30   2007     8/24/07   64            Low
    ## 31   2007     8/24/07   64            Low
    ## 2.2  2007     8/20/07   69        Control
    ## 3.5  2007     8/20/07   69           High
    ## 32   2007     8/20/07   69           High
    ## 33   2007     8/20/07   69           High
    ## 4.1  2007     8/20/07   69           High
    ## 5.3  2007     8/20/07   69           High
    ## 34   2007     8/20/07   69           High
    ## 35   2007     8/20/07   69           High
    ## 36   2007     8/20/07   69           High
    ## 11.1 2007     8/20/07   69           High
    ## 18.2 2007     8/20/07   69           High
    ## 28.1 2007     8/20/07   69           High
    ## 37   2007     8/20/07   69           High
    ## 38   2007     8/20/07   69           High
    ## 3.6  2007     8/24/07   69            Low
    ## 39   2007     8/24/07   69            Low
    ## 40   2007     8/24/07   69            Low
    ## 33.1 2007     8/24/07   69            Low
    ## 15.2 2007     8/24/07   69            Low
    ## 4.2  2007     8/24/07   69            Low
    ## 5.4  2007     8/24/07   69            Low
    ## 41   2007     8/24/07   69            Low
    ## 35.1 2007     8/24/07   69            Low
    ## 36.1 2007     8/24/07   69            Low
    ## 7.4  2007     8/24/07   69            Low
    ## 28.2 2007     8/24/07   69            Low
    ## 37.1 2007     8/24/07   69            Low
    ## 14.3 2007     8/24/07   69            Low
    ## 42   2007     8/23/07   78        Control
    ## 2.3  2007     8/21/07   78        Control
    ## 25.1 2007     8/23/07   78           High
    ## 15.3 2007     8/23/07   78           High
    ## 7.5  2007     8/23/07   78           High
    ## 18.3 2007     8/23/07   78           High
    ## 20.2 2007     8/23/07   78           High
    ## 12.2 2007     8/23/07   78           High
    ## 14.4 2007     8/23/07   78           High
    ## 30.1 2007     8/23/07   78           High
    ## 23.1 2007     8/23/07   78           High
    ## 42.1 2007     8/28/07   78            Low
    ## 25.2 2007     8/28/07   78            Low
    ## 15.4 2007     8/28/07   78            Low
    ## 27.1 2007     8/28/07   78            Low
    ## 35.2 2007     8/28/07   78            Low
    ## 43   2007     8/28/07   78            Low
    ## 17.2 2007     8/28/07   78            Low
    ## 18.4 2007     8/28/07   78            Low
    ## 20.3 2007     8/28/07   78            Low
    ## 12.3 2007     8/28/07   78            Low
    ## 14.5 2007     8/28/07   78            Low
    ## 22.1 2007     8/28/07   78            Low
    ## 1.1  2007     8/22/07   29        Control
    ## 44   2007     8/22/07   29        Control
    ## 45   2007     8/22/07   29        Control
    ## 46   2007     8/22/07   29        Control
    ## 47   2007     8/28/07   78            Low
    ## 48   2007     8/28/07   78            Low
    ## 49   2007     8/28/07   78            Low
    ## 50   2007     8/28/07   78            Low
    ## 51   2007     8/28/07   78            Low
    ## 52   2007     8/28/07   78            Low
    ## 53   2007     8/24/07   64            Low
    ## 54   2007     8/24/07   64            Low
    ## 55   2007     8/24/07   64            Low
    ## NA   2007     8/24/07   64            Low
    ## NA.1 2007     8/24/07   64            Low
    ## 57   2007     8/24/07   64            Low
    ## 58   2007     8/24/07   64            Low
    ## 59   2007     8/24/07   64            Low
    ##                                Species   Mass
    ## 1                               Mosses 150.53
    ## 2                     Unsorted biomass 150.53
    ## 3       Achillea millefolium(lanulosa)   0.13
    ## 3.1     Achillea millefolium(lanulosa)   3.60
    ## 3.2     Achillea millefolium(lanulosa)   9.77
    ## 4                      Crepis tectorum   1.43
    ## 5                          Cyperus sp.   0.53
    ## 6               Euphorbia glyptosperma   0.05
    ## 7                   Lespedeza capitata 139.90
    ## 3.3     Achillea millefolium(lanulosa)   0.60
    ## 8    Achillea millefolium(lanulosaaaa)   1.10
    ## 9     Achillea millefolium(lanulosabb)   4.90
    ## 10    Achillea millefolium(lanulosacc)   0.87
    ## 5.1                        Cyperus sp.   1.53
    ## 11                Lepidium densiflorum   0.05
    ## 7.1                 Lespedeza capitata  54.67
    ## 12                       Poa pratensis   0.07
    ## 13                    Rumex acetosella   0.33
    ## 14             Schizachyrium scoparium   0.70
    ## 2.1                   Unsorted biomass 202.55
    ## 15                  Bouteloua gracilis  12.20
    ## 5.2                        Cyperus sp.   0.23
    ## 16                   Koeleria cristata   0.87
    ## 7.2                 Lespedeza capitata  52.83
    ## 17                      Liatris aspera   2.80
    ## 18                    Lupinus perennis  50.90
    ## 19                    Panicum virgatum   0.43
    ## 20              Petalostemum purpureum   9.03
    ## 21               Petalostemum villosum  15.13
    ## 12.1                     Poa pratensis   0.23
    ## 14.1           Schizachyrium scoparium  23.60
    ## 22                  Solidago nemoralis  32.10
    ## 23                  Sorghastrum nutans   5.53
    ## 24                       Stipa spartea   4.00
    ## 3.4     Achillea millefolium(lanulosa)   0.83
    ## 25                  Andropogon gerardi  13.93
    ## 26              Bouteloua curtipendula   0.20
    ## 15.1                Bouteloua gracilis  27.10
    ## 27                   Coreopsis palmata   4.40
    ## 16.1                 Koeleria cristata   0.83
    ## 7.3                 Lespedeza capitata  44.10
    ## 17.1                    Liatris aspera  14.00
    ## 18.1                  Lupinus perennis  27.87
    ## 28                Miscellaneous litter   1.87
    ## 29               Petalostemum candidum   3.00
    ## 20.1            Petalostemum purpureum   9.33
    ## 14.2           Schizachyrium scoparium  10.97
    ## 30                     Solidago rigida  39.57
    ## 31              Sporobolus cryptandrus   0.60
    ## 2.2                   Unsorted biomass  58.85
    ## 3.5     Achillea millefolium(lanulosa)   3.53
    ## 32                    Agropyron repens   0.37
    ## 33                  Aristida basiramea   6.53
    ## 4.1                    Crepis tectorum   0.83
    ## 5.3                        Cyperus sp.   3.17
    ## 34                       Digitaria sp.   0.10
    ## 35                 Erigeron canadensis   8.33
    ## 36                     Hedeoma hispida   1.30
    ## 11.1              Lepidium densiflorum   0.13
    ## 18.2                  Lupinus perennis   0.37
    ## 28.1              Miscellaneous litter   0.70
    ## 37                 Physalis virginiana   0.43
    ## 38               Taraxicum officinalis   0.06
    ## 3.6     Achillea millefolium(lanulosa)   2.97
    ## 39                     Agrostis scabra   0.47
    ## 40     Ambrosia artemisiifolia elatior   0.47
    ## 33.1                Aristida basiramea   9.53
    ## 15.2                Bouteloua gracilis   0.10
    ## 4.2                    Crepis tectorum   1.33
    ## 5.4                        Cyperus sp.   1.70
    ## 41              Eragrostis spectabilis   1.63
    ## 35.1               Erigeron canadensis   2.67
    ## 36.1                   Hedeoma hispida   0.20
    ## 7.4                 Lespedeza capitata   0.10
    ## 28.2              Miscellaneous litter   0.93
    ## 37.1               Physalis virginiana   1.97
    ## 14.3           Schizachyrium scoparium   0.23
    ## 42                   Amorpha canescens   9.30
    ## 2.3                   Unsorted biomass 216.13
    ## 25.1                Andropogon gerardi  22.60
    ## 15.3                Bouteloua gracilis   0.73
    ## 7.5                 Lespedeza capitata   7.03
    ## 18.3                  Lupinus perennis  20.90
    ## 20.2            Petalostemum purpureum   0.30
    ## 12.2                     Poa pratensis   1.30
    ## 14.4           Schizachyrium scoparium  10.87
    ## 30.1                   Solidago rigida 133.00
    ## 23.1                Sorghastrum nutans   1.40
    ## 42.1                 Amorpha canescens  47.80
    ## 25.2                Andropogon gerardi  19.10
    ## 15.4                Bouteloua gracilis   9.93
    ## 27.1                 Coreopsis palmata   1.03
    ## 35.2               Erigeron canadensis   4.17
    ## 43                               -9999   9.53
    ## 17.2                    Liatris aspera  11.03
    ## 18.4                  Lupinus perennis  10.27
    ## 20.3            Petalostemum purpureum   6.53
    ## 12.3                     Poa pratensis   0.90
    ## 14.5           Schizachyrium scoparium  10.83
    ## 22.1                Solidago nemoralis   3.43
    ## 1.1                             Mosses 150.53
    ## 44                        Yellow Perch 150.53
    ## 45                       Rainbow smelt 150.53
    ## 46                    Large mouth bass 150.53
    ## 47                   Petalostemum S.p.   6.53
    ## 48                             Poa Cf.   0.90
    ## 49                  Schizachyrium spp.  10.83
    ## 50                        Petalostemum   6.53
    ## 51                           Poa cf...   0.90
    ## 52                   Schizachyrium sPp  10.83
    ## 53                  _Koeleria_cristata   0.83
    ## 54                  Lespedeza_capitata  44.10
    ## 55                    _Liatris_aspera_  14.00
    ## NA                                       0.83
    ## NA.1                                    44.10
    ## 57            Oncorhynchus tshawytscha  44.10
    ## 58              Oncorhynchus gorbuscha  44.10
    ## 59                Oncorhynchus kisutch  44.10
    ##                           taxa_clean taxa_rank taxa_authority
    ## 1                             Mosses    Common           ITIS
    ## 2                   Unsorted biomass      <NA>           <NA>
    ## 3               Achillea millefolium   Species           ITIS
    ## 3.1             Achillea millefolium   Species           ITIS
    ## 3.2             Achillea millefolium   Species           ITIS
    ## 4                    Crepis tectorum   Species           ITIS
    ## 5                            Cyperus     Genus           ITIS
    ## 6             Euphorbia glyptosperma   Species           ITIS
    ## 7                 Lespedeza capitata   Species           ITIS
    ## 3.3             Achillea millefolium   Species           ITIS
    ## 8               Achillea millefolium   Species           ITIS
    ## 9               Achillea millefolium   Species           ITIS
    ## 10              Achillea millefolium   Species           ITIS
    ## 5.1                          Cyperus     Genus           ITIS
    ## 11              Lepidium densiflorum   Species           ITIS
    ## 7.1               Lespedeza capitata   Species           ITIS
    ## 12                     Poa pratensis   Species           ITIS
    ## 13                  Rumex acetosella   Species           ITIS
    ## 14           Schizachyrium scoparium   Species           ITIS
    ## 2.1                 Unsorted biomass      <NA>           <NA>
    ## 15                Bouteloua gracilis   Species           ITIS
    ## 5.2                          Cyperus     Genus           ITIS
    ## 16                 Koeleria cristata   Species           ITIS
    ## 7.2               Lespedeza capitata   Species           ITIS
    ## 17                    Liatris aspera   Species           ITIS
    ## 18                  Lupinus perennis   Species           ITIS
    ## 19                  Panicum virgatum   Species           ITIS
    ## 20            Petalostemum purpureum    Common            EOL
    ## 21             Petalostemum villosum    Common            EOL
    ## 12.1                   Poa pratensis   Species           ITIS
    ## 14.1         Schizachyrium scoparium   Species           ITIS
    ## 22                Solidago nemoralis   Species           ITIS
    ## 23                Sorghastrum nutans   Species           ITIS
    ## 24                     Stipa spartea   Species           ITIS
    ## 3.4             Achillea millefolium   Species           ITIS
    ## 25                Andropogon gerardi   Species           ITIS
    ## 26            Bouteloua curtipendula   Species           ITIS
    ## 15.1              Bouteloua gracilis   Species           ITIS
    ## 27                 Coreopsis palmata   Species           ITIS
    ## 16.1               Koeleria cristata   Species           ITIS
    ## 7.3               Lespedeza capitata   Species           ITIS
    ## 17.1                  Liatris aspera   Species           ITIS
    ## 18.1                Lupinus perennis   Species           ITIS
    ## 28              Miscellaneous litter      <NA>           <NA>
    ## 29             Petalostemum candidum    Common            EOL
    ## 20.1          Petalostemum purpureum    Common            EOL
    ## 14.2         Schizachyrium scoparium   Species           ITIS
    ## 30                   Solidago rigida   Species           ITIS
    ## 31            Sporobolus cryptandrus   Species           ITIS
    ## 2.2                 Unsorted biomass      <NA>           <NA>
    ## 3.5             Achillea millefolium   Species           ITIS
    ## 32                  Agropyron repens   Species           ITIS
    ## 33                Aristida basiramea   Species           ITIS
    ## 4.1                  Crepis tectorum   Species           ITIS
    ## 5.3                          Cyperus     Genus           ITIS
    ## 34                         Digitaria     Genus           ITIS
    ## 35               Erigeron canadensis   Species           ITIS
    ## 36                   Hedeoma hispida   Species           ITIS
    ## 11.1            Lepidium densiflorum   Species           ITIS
    ## 18.2                Lupinus perennis   Species           ITIS
    ## 28.1            Miscellaneous litter      <NA>           <NA>
    ## 37               Physalis virginiana   Species           ITIS
    ## 38              Taraxacum officinale   Species           ITIS
    ## 3.6             Achillea millefolium   Species           ITIS
    ## 39                   Agrostis scabra   Species           ITIS
    ## 40   Ambrosia artemisiifolia elatior      <NA>           ITIS
    ## 33.1              Aristida basiramea   Species           ITIS
    ## 15.2              Bouteloua gracilis   Species           ITIS
    ## 4.2                  Crepis tectorum   Species           ITIS
    ## 5.4                          Cyperus     Genus           ITIS
    ## 41            Eragrostis spectabilis   Species           ITIS
    ## 35.1             Erigeron canadensis   Species           ITIS
    ## 36.1                 Hedeoma hispida   Species           ITIS
    ## 7.4               Lespedeza capitata   Species           ITIS
    ## 28.2            Miscellaneous litter      <NA>           <NA>
    ## 37.1             Physalis virginiana   Species           ITIS
    ## 14.3         Schizachyrium scoparium   Species           ITIS
    ## 42                 Amorpha canescens   Species           ITIS
    ## 2.3                 Unsorted biomass      <NA>           <NA>
    ## 25.1              Andropogon gerardi   Species           ITIS
    ## 15.3              Bouteloua gracilis   Species           ITIS
    ## 7.5               Lespedeza capitata   Species           ITIS
    ## 18.3                Lupinus perennis   Species           ITIS
    ## 20.2          Petalostemum purpureum    Common            EOL
    ## 12.2                   Poa pratensis   Species           ITIS
    ## 14.4         Schizachyrium scoparium   Species           ITIS
    ## 30.1                 Solidago rigida   Species           ITIS
    ## 23.1              Sorghastrum nutans   Species           ITIS
    ## 42.1               Amorpha canescens   Species           ITIS
    ## 25.2              Andropogon gerardi   Species           ITIS
    ## 15.4              Bouteloua gracilis   Species           ITIS
    ## 27.1               Coreopsis palmata   Species           ITIS
    ## 35.2             Erigeron canadensis   Species           ITIS
    ## 43                             -9999      <NA>           <NA>
    ## 17.2                  Liatris aspera   Species           ITIS
    ## 18.4                Lupinus perennis   Species           ITIS
    ## 20.3          Petalostemum purpureum    Common            EOL
    ## 12.3                   Poa pratensis   Species           ITIS
    ## 14.5         Schizachyrium scoparium   Species           ITIS
    ## 22.1              Solidago nemoralis   Species           ITIS
    ## 1.1                           Mosses    Common           ITIS
    ## 44                      Yellow Perch    Common           ITIS
    ## 45                     Rainbow smelt    Common           ITIS
    ## 46                  Large mouth bass    Common            EOL
    ## 47                      Petalostemum    Common            EOL
    ## 48                               Poa     Genus           ITIS
    ## 49                     Schizachyrium     Genus           ITIS
    ## 50                      Petalostemum    Common            EOL
    ## 51                               Poa     Genus           ITIS
    ## 52                     Schizachyrium     Genus           ITIS
    ## 53                 Koeleria cristata   Species           ITIS
    ## 54                Lespedeza capitata   Species           ITIS
    ## 55                    Liatris aspera   Species           ITIS
    ## NA                                        <NA>           <NA>
    ## NA.1                                      <NA>           <NA>
    ## 57          Oncorhynchus tshawytscha   Species           ITIS
    ## 58            Oncorhynchus gorbuscha   Species           ITIS
    ## 59              Oncorhynchus kisutch   Species           ITIS
    ##      taxa_authority_id
    ## 1                14189
    ## 2                   NA
    ## 3                35423
    ## 3.1              35423
    ## 3.2              35423
    ## 4                37212
    ## 5                39882
    ## 6                28074
    ## 7                25897
    ## 3.3              35423
    ## 8                35423
    ## 9                35423
    ## 10               35423
    ## 5.1              39882
    ## 11               22960
    ## 7.1              25897
    ## 12               41088
    ## 13               20934
    ## 14               42076
    ## 2.1                 NA
    ## 15               41493
    ## 5.2              39882
    ## 16              515476
    ## 7.2              25897
    ## 17               37909
    ## 18               26091
    ## 19               40913
    ## 20            49943005
    ## 21                  NA
    ## 12.1             41088
    ## 14.1             42076
    ## 22               36281
    ## 23               42102
    ## 24               42166
    ## 3.4              35423
    ## 25              786156
    ## 26               41500
    ## 15.1             41493
    ## 27               37148
    ## 16.1            515476
    ## 7.3              25897
    ## 17.1             37909
    ## 18.1             26091
    ## 28                  NA
    ## 29            49943004
    ## 20.1          49943005
    ## 14.2             42076
    ## 30               36297
    ## 31               42132
    ## 2.2                 NA
    ## 3.5              35423
    ## 32               40382
    ## 33               41412
    ## 4.1              37212
    ## 5.3              39882
    ## 34               40603
    ## 35              196266
    ## 36              502890
    ## 11.1             22960
    ## 18.2             26091
    ## 28.1                NA
    ## 37               30612
    ## 38               36213
    ## 3.6              35423
    ## 39               40424
    ## 40                  NA
    ## 33.1             41412
    ## 15.2             41493
    ## 4.2              37212
    ## 5.4              39882
    ## 41               40717
    ## 35.1            196266
    ## 36.1            502890
    ## 7.4              25897
    ## 28.2                NA
    ## 37.1             30612
    ## 14.3             42076
    ## 42               25371
    ## 2.3                 NA
    ## 25.1            786156
    ## 15.3             41493
    ## 7.5              25897
    ## 18.3             26091
    ## 20.2          49943005
    ## 12.2             41088
    ## 14.4             42076
    ## 30.1             36297
    ## 23.1             42102
    ## 42.1             25371
    ## 25.2            786156
    ## 15.4             41493
    ## 27.1             37148
    ## 35.2            196266
    ## 43                  NA
    ## 17.2             37909
    ## 18.4             26091
    ## 20.3          49943005
    ## 12.3             41088
    ## 14.5             42076
    ## 22.1             36281
    ## 1.1              14189
    ## 44              168469
    ## 45              162041
    ## 46            50027504
    ## 47            49943003
    ## 48               41074
    ## 49               42069
    ## 50            49943003
    ## 51               41074
    ## 52               42069
    ## 53              515476
    ## 54               25897
    ## 55               37909
    ## NA                  NA
    ## NA.1                NA
    ## 57              161980
    ## 58              161975
    ## 59              161977

|  Year| Sample\_Date |  Plot| Heat\_Treatment | Species                           |    Mass| taxa\_clean                     | taxa\_rank | taxa\_authority |  taxa\_authority\_id|
|-----:|:-------------|-----:|:----------------|:----------------------------------|-------:|:--------------------------------|:-----------|:----------------|--------------------:|
|  2007| 8/22/07      |    29| Control         | Mosses                            |  150.53| Mosses                          | Common     | ITIS            |                14189|
|  2007| 8/22/07      |    29| Control         | Unsorted biomass                  |  150.53| Unsorted biomass                | NA         | NA              |                   NA|
|  2007| 8/24/07      |    29| High            | Achillea millefolium(lanulosa)    |    0.13| Achillea millefolium            | Species    | ITIS            |                35423|
|  2007| 8/24/07      |    29| High            | Achillea millefolium(lanulosa)    |    3.60| Achillea millefolium            | Species    | ITIS            |                35423|
|  2007| 8/24/07      |    29| High            | Achillea millefolium(lanulosa)    |    9.77| Achillea millefolium            | Species    | ITIS            |                35423|
|  2007| 8/24/07      |    29| High            | Crepis tectorum                   |    1.43| Crepis tectorum                 | Species    | ITIS            |                37212|
|  2007| 8/24/07      |    29| High            | Cyperus sp.                       |    0.53| Cyperus                         | Genus      | ITIS            |                39882|
|  2007| 8/23/07      |    29| High            | Euphorbia glyptosperma            |    0.05| Euphorbia glyptosperma          | Species    | ITIS            |                28074|
|  2007| 8/24/07      |    29| High            | Lespedeza capitata                |  139.90| Lespedeza capitata              | Species    | ITIS            |                25897|
|  2007| 8/21/07      |    29| Low             | Achillea millefolium(lanulosa)    |    0.60| Achillea millefolium            | Species    | ITIS            |                35423|
|  2007| 8/21/07      |    29| Low             | Achillea millefolium(lanulosaaaa) |    1.10| Achillea millefolium            | Species    | ITIS            |                35423|
|  2007| 8/21/07      |    29| Low             | Achillea millefolium(lanulosabb)  |    4.90| Achillea millefolium            | Species    | ITIS            |                35423|
|  2007| 8/21/07      |    29| Low             | Achillea millefolium(lanulosacc)  |    0.87| Achillea millefolium            | Species    | ITIS            |                35423|
|  2007| 8/21/07      |    29| Low             | Cyperus sp.                       |    1.53| Cyperus                         | Genus      | ITIS            |                39882|
|  2007| 8/20/07      |    29| Low             | Lepidium densiflorum              |    0.05| Lepidium densiflorum            | Species    | ITIS            |                22960|
|  2007| 8/21/07      |    29| Low             | Lespedeza capitata                |   54.67| Lespedeza capitata              | Species    | ITIS            |                25897|
|  2007| 8/21/07      |    29| Low             | Poa pratensis                     |    0.07| Poa pratensis                   | Species    | ITIS            |                41088|
|  2007| 8/21/07      |    29| Low             | Rumex acetosella                  |    0.33| Rumex acetosella                | Species    | ITIS            |                20934|
|  2007| 8/21/07      |    29| Low             | Schizachyrium scoparium           |    0.70| Schizachyrium scoparium         | Species    | ITIS            |                42076|
|  2007| 8/21/07      |    64| Control         | Unsorted biomass                  |  202.55| Unsorted biomass                | NA         | NA              |                   NA|
|  2007| 8/20/07      |    64| High            | Bouteloua gracilis                |   12.20| Bouteloua gracilis              | Species    | ITIS            |                41493|
|  2007| 8/20/07      |    64| High            | Cyperus sp.                       |    0.23| Cyperus                         | Genus      | ITIS            |                39882|
|  2007| 8/20/07      |    64| High            | Koeleria cristata                 |    0.87| Koeleria cristata               | Species    | ITIS            |               515476|
|  2007| 8/20/07      |    64| High            | Lespedeza capitata                |   52.83| Lespedeza capitata              | Species    | ITIS            |                25897|
|  2007| 8/20/07      |    64| High            | Liatris aspera                    |    2.80| Liatris aspera                  | Species    | ITIS            |                37909|
|  2007| 8/20/07      |    64| High            | Lupinus perennis                  |   50.90| Lupinus perennis                | Species    | ITIS            |                26091|
|  2007| 8/20/07      |    64| High            | Panicum virgatum                  |    0.43| Panicum virgatum                | Species    | ITIS            |                40913|
|  2007| 8/20/07      |    64| High            | Petalostemum purpureum            |    9.03| Petalostemum purpureum          | Common     | EOL             |             49943005|
|  2007| 8/20/07      |    64| High            | Petalostemum villosum             |   15.13| Petalostemum villosum           | Common     | EOL             |                   NA|
|  2007| 8/20/07      |    64| High            | Poa pratensis                     |    0.23| Poa pratensis                   | Species    | ITIS            |                41088|
|  2007| 8/20/07      |    64| High            | Schizachyrium scoparium           |   23.60| Schizachyrium scoparium         | Species    | ITIS            |                42076|
|  2007| 8/20/07      |    64| High            | Solidago nemoralis                |   32.10| Solidago nemoralis              | Species    | ITIS            |                36281|
|  2007| 8/20/07      |    64| High            | Sorghastrum nutans                |    5.53| Sorghastrum nutans              | Species    | ITIS            |                42102|
|  2007| 8/20/07      |    64| High            | Stipa spartea                     |    4.00| Stipa spartea                   | Species    | ITIS            |                42166|
|  2007| 8/24/07      |    64| Low             | Achillea millefolium(lanulosa)    |    0.83| Achillea millefolium            | Species    | ITIS            |                35423|
|  2007| 8/24/07      |    64| Low             | Andropogon gerardi                |   13.93| Andropogon gerardi              | Species    | ITIS            |               786156|
|  2007| 8/24/07      |    64| Low             | Bouteloua curtipendula            |    0.20| Bouteloua curtipendula          | Species    | ITIS            |                41500|
|  2007| 8/24/07      |    64| Low             | Bouteloua gracilis                |   27.10| Bouteloua gracilis              | Species    | ITIS            |                41493|
|  2007| 8/24/07      |    64| Low             | Coreopsis palmata                 |    4.40| Coreopsis palmata               | Species    | ITIS            |                37148|
|  2007| 8/24/07      |    64| Low             | Koeleria cristata                 |    0.83| Koeleria cristata               | Species    | ITIS            |               515476|
|  2007| 8/24/07      |    64| Low             | Lespedeza capitata                |   44.10| Lespedeza capitata              | Species    | ITIS            |                25897|
|  2007| 8/24/07      |    64| Low             | Liatris aspera                    |   14.00| Liatris aspera                  | Species    | ITIS            |                37909|
|  2007| 8/24/07      |    64| Low             | Lupinus perennis                  |   27.87| Lupinus perennis                | Species    | ITIS            |                26091|
|  2007| 8/24/07      |    64| Low             | Miscellaneous litter              |    1.87| Miscellaneous litter            | NA         | NA              |                   NA|
|  2007| 8/24/07      |    64| Low             | Petalostemum candidum             |    3.00| Petalostemum candidum           | Common     | EOL             |             49943004|
|  2007| 8/24/07      |    64| Low             | Petalostemum purpureum            |    9.33| Petalostemum purpureum          | Common     | EOL             |             49943005|
|  2007| 8/24/07      |    64| Low             | Schizachyrium scoparium           |   10.97| Schizachyrium scoparium         | Species    | ITIS            |                42076|
|  2007| 8/24/07      |    64| Low             | Solidago rigida                   |   39.57| Solidago rigida                 | Species    | ITIS            |                36297|
|  2007| 8/24/07      |    64| Low             | Sporobolus cryptandrus            |    0.60| Sporobolus cryptandrus          | Species    | ITIS            |                42132|
|  2007| 8/20/07      |    69| Control         | Unsorted biomass                  |   58.85| Unsorted biomass                | NA         | NA              |                   NA|
|  2007| 8/20/07      |    69| High            | Achillea millefolium(lanulosa)    |    3.53| Achillea millefolium            | Species    | ITIS            |                35423|
|  2007| 8/20/07      |    69| High            | Agropyron repens                  |    0.37| Agropyron repens                | Species    | ITIS            |                40382|
|  2007| 8/20/07      |    69| High            | Aristida basiramea                |    6.53| Aristida basiramea              | Species    | ITIS            |                41412|
|  2007| 8/20/07      |    69| High            | Crepis tectorum                   |    0.83| Crepis tectorum                 | Species    | ITIS            |                37212|
|  2007| 8/20/07      |    69| High            | Cyperus sp.                       |    3.17| Cyperus                         | Genus      | ITIS            |                39882|
|  2007| 8/20/07      |    69| High            | Digitaria sp.                     |    0.10| Digitaria                       | Genus      | ITIS            |                40603|
|  2007| 8/20/07      |    69| High            | Erigeron canadensis               |    8.33| Erigeron canadensis             | Species    | ITIS            |               196266|
|  2007| 8/20/07      |    69| High            | Hedeoma hispida                   |    1.30| Hedeoma hispida                 | Species    | ITIS            |               502890|
|  2007| 8/20/07      |    69| High            | Lepidium densiflorum              |    0.13| Lepidium densiflorum            | Species    | ITIS            |                22960|
|  2007| 8/20/07      |    69| High            | Lupinus perennis                  |    0.37| Lupinus perennis                | Species    | ITIS            |                26091|
|  2007| 8/20/07      |    69| High            | Miscellaneous litter              |    0.70| Miscellaneous litter            | NA         | NA              |                   NA|
|  2007| 8/20/07      |    69| High            | Physalis virginiana               |    0.43| Physalis virginiana             | Species    | ITIS            |                30612|
|  2007| 8/20/07      |    69| High            | Taraxicum officinalis             |    0.06| Taraxacum officinale            | Species    | ITIS            |                36213|
|  2007| 8/24/07      |    69| Low             | Achillea millefolium(lanulosa)    |    2.97| Achillea millefolium            | Species    | ITIS            |                35423|
|  2007| 8/24/07      |    69| Low             | Agrostis scabra                   |    0.47| Agrostis scabra                 | Species    | ITIS            |                40424|
|  2007| 8/24/07      |    69| Low             | Ambrosia artemisiifolia elatior   |    0.47| Ambrosia artemisiifolia elatior | NA         | ITIS            |                   NA|
|  2007| 8/24/07      |    69| Low             | Aristida basiramea                |    9.53| Aristida basiramea              | Species    | ITIS            |                41412|
|  2007| 8/24/07      |    69| Low             | Bouteloua gracilis                |    0.10| Bouteloua gracilis              | Species    | ITIS            |                41493|
|  2007| 8/24/07      |    69| Low             | Crepis tectorum                   |    1.33| Crepis tectorum                 | Species    | ITIS            |                37212|
|  2007| 8/24/07      |    69| Low             | Cyperus sp.                       |    1.70| Cyperus                         | Genus      | ITIS            |                39882|
|  2007| 8/24/07      |    69| Low             | Eragrostis spectabilis            |    1.63| Eragrostis spectabilis          | Species    | ITIS            |                40717|
|  2007| 8/24/07      |    69| Low             | Erigeron canadensis               |    2.67| Erigeron canadensis             | Species    | ITIS            |               196266|
|  2007| 8/24/07      |    69| Low             | Hedeoma hispida                   |    0.20| Hedeoma hispida                 | Species    | ITIS            |               502890|
|  2007| 8/24/07      |    69| Low             | Lespedeza capitata                |    0.10| Lespedeza capitata              | Species    | ITIS            |                25897|
|  2007| 8/24/07      |    69| Low             | Miscellaneous litter              |    0.93| Miscellaneous litter            | NA         | NA              |                   NA|
|  2007| 8/24/07      |    69| Low             | Physalis virginiana               |    1.97| Physalis virginiana             | Species    | ITIS            |                30612|
|  2007| 8/24/07      |    69| Low             | Schizachyrium scoparium           |    0.23| Schizachyrium scoparium         | Species    | ITIS            |                42076|
|  2007| 8/23/07      |    78| Control         | Amorpha canescens                 |    9.30| Amorpha canescens               | Species    | ITIS            |                25371|
|  2007| 8/21/07      |    78| Control         | Unsorted biomass                  |  216.13| Unsorted biomass                | NA         | NA              |                   NA|
|  2007| 8/23/07      |    78| High            | Andropogon gerardi                |   22.60| Andropogon gerardi              | Species    | ITIS            |               786156|
|  2007| 8/23/07      |    78| High            | Bouteloua gracilis                |    0.73| Bouteloua gracilis              | Species    | ITIS            |                41493|
|  2007| 8/23/07      |    78| High            | Lespedeza capitata                |    7.03| Lespedeza capitata              | Species    | ITIS            |                25897|
|  2007| 8/23/07      |    78| High            | Lupinus perennis                  |   20.90| Lupinus perennis                | Species    | ITIS            |                26091|
|  2007| 8/23/07      |    78| High            | Petalostemum purpureum            |    0.30| Petalostemum purpureum          | Common     | EOL             |             49943005|
|  2007| 8/23/07      |    78| High            | Poa pratensis                     |    1.30| Poa pratensis                   | Species    | ITIS            |                41088|
|  2007| 8/23/07      |    78| High            | Schizachyrium scoparium           |   10.87| Schizachyrium scoparium         | Species    | ITIS            |                42076|
|  2007| 8/23/07      |    78| High            | Solidago rigida                   |  133.00| Solidago rigida                 | Species    | ITIS            |                36297|
|  2007| 8/23/07      |    78| High            | Sorghastrum nutans                |    1.40| Sorghastrum nutans              | Species    | ITIS            |                42102|
|  2007| 8/28/07      |    78| Low             | Amorpha canescens                 |   47.80| Amorpha canescens               | Species    | ITIS            |                25371|
|  2007| 8/28/07      |    78| Low             | Andropogon gerardi                |   19.10| Andropogon gerardi              | Species    | ITIS            |               786156|
|  2007| 8/28/07      |    78| Low             | Bouteloua gracilis                |    9.93| Bouteloua gracilis              | Species    | ITIS            |                41493|
|  2007| 8/28/07      |    78| Low             | Coreopsis palmata                 |    1.03| Coreopsis palmata               | Species    | ITIS            |                37148|
|  2007| 8/28/07      |    78| Low             | Erigeron canadensis               |    4.17| Erigeron canadensis             | Species    | ITIS            |               196266|
|  2007| 8/28/07      |    78| Low             | -9999                             |    9.53| -9999                           | NA         | NA              |                   NA|
|  2007| 8/28/07      |    78| Low             | Liatris aspera                    |   11.03| Liatris aspera                  | Species    | ITIS            |                37909|
|  2007| 8/28/07      |    78| Low             | Lupinus perennis                  |   10.27| Lupinus perennis                | Species    | ITIS            |                26091|
|  2007| 8/28/07      |    78| Low             | Petalostemum purpureum            |    6.53| Petalostemum purpureum          | Common     | EOL             |             49943005|
|  2007| 8/28/07      |    78| Low             | Poa pratensis                     |    0.90| Poa pratensis                   | Species    | ITIS            |                41088|
|  2007| 8/28/07      |    78| Low             | Schizachyrium scoparium           |   10.83| Schizachyrium scoparium         | Species    | ITIS            |                42076|
|  2007| 8/28/07      |    78| Low             | Solidago nemoralis                |    3.43| Solidago nemoralis              | Species    | ITIS            |                36281|
|  2007| 8/22/07      |    29| Control         | Mosses                            |  150.53| Mosses                          | Common     | ITIS            |                14189|
|  2007| 8/22/07      |    29| Control         | Yellow Perch                      |  150.53| Yellow Perch                    | Common     | ITIS            |               168469|
|  2007| 8/22/07      |    29| Control         | Rainbow smelt                     |  150.53| Rainbow smelt                   | Common     | ITIS            |               162041|
|  2007| 8/22/07      |    29| Control         | Large mouth bass                  |  150.53| Large mouth bass                | Common     | EOL             |             50027504|
|  2007| 8/28/07      |    78| Low             | Petalostemum S.p.                 |    6.53| Petalostemum                    | Common     | EOL             |             49943003|
|  2007| 8/28/07      |    78| Low             | Poa Cf.                           |    0.90| Poa                             | Genus      | ITIS            |                41074|
|  2007| 8/28/07      |    78| Low             | Schizachyrium spp.                |   10.83| Schizachyrium                   | Genus      | ITIS            |                42069|
|  2007| 8/28/07      |    78| Low             | Petalostemum                      |    6.53| Petalostemum                    | Common     | EOL             |             49943003|
|  2007| 8/28/07      |    78| Low             | Poa cf...                         |    0.90| Poa                             | Genus      | ITIS            |                41074|
|  2007| 8/28/07      |    78| Low             | Schizachyrium sPp                 |   10.83| Schizachyrium                   | Genus      | ITIS            |                42069|
|  2007| 8/24/07      |    64| Low             | \_Koeleria\_cristata              |    0.83| Koeleria cristata               | Species    | ITIS            |               515476|
|  2007| 8/24/07      |    64| Low             | Lespedeza\_capitata               |   44.10| Lespedeza capitata              | Species    | ITIS            |                25897|
|  2007| 8/24/07      |    64| Low             | *Liatris\_aspera*                 |   14.00| Liatris aspera                  | Species    | ITIS            |                37909|
|  2007| 8/24/07      |    64| Low             |                                   |    0.83|                                 | NA         | NA              |                   NA|
|  2007| 8/24/07      |    64| Low             |                                   |   44.10|                                 | NA         | NA              |                   NA|
|  2007| 8/24/07      |    64| Low             | Oncorhynchus tshawytscha          |   44.10| Oncorhynchus tshawytscha        | Species    | ITIS            |               161980|
|  2007| 8/24/07      |    64| Low             | Oncorhynchus gorbuscha            |   44.10| Oncorhynchus gorbuscha          | Species    | ITIS            |               161975|
|  2007| 8/24/07      |    64| Low             | Oncorhynchus kisutch              |   44.10| Oncorhynchus kisutch            | Species    | ITIS            |               161977|

-   [Back to top](#overview)

### Make taxonomicCoverage EML

When creating EML metadata (Ecological Metadata Language), it is a good practice to include the taxonomic entities and their respective hierarchies to facilitate search and discovery.

``` r
# Create the taxonomicCoverage EML node set and write to file
make_taxonomicCoverage(path = my_path)
```

    ## <taxonomicCoverage system="uuid">
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Bryophyta</taxonRankValue>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Asteranae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Asterales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Asteraceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Achillea</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Achillea millefolium</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Asteranae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Asterales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Asteraceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Crepis</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Crepis tectorum</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Lilianae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Poales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Cyperaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Cyperus</taxonRankValue>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Rosanae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Malpighiales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Euphorbiaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Euphorbia</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Euphorbia glyptosperma</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Rosanae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Fabales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Fabaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Lespedeza</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Lespedeza capitata</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Asteranae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Asterales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Asteraceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Achillea</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Achillea millefolium</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Asteranae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Asterales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Asteraceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Achillea</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Achillea millefolium</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Asteranae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Asterales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Asteraceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Achillea</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Achillea millefolium</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Rosanae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Brassicales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Brassicaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Lepidium</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Lepidium densiflorum</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Lilianae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Poales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Poaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Poa</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Poa pratensis</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Caryophyllanae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Caryophyllales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Polygonaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Rumex</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Rumex acetosella</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Lilianae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Poales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Poaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Schizachyrium</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Schizachyrium scoparium</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Lilianae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Poales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Poaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Bouteloua</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Bouteloua gracilis</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>species</taxonRankName>
    ##     <taxonRankValue>NA</taxonRankValue>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Asteranae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Asterales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Asteraceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Liatris</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Liatris aspera</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Rosanae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Fabales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Fabaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Lupinus</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Lupinus perennis</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Lilianae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Poales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Poaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Panicum</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Panicum virgatum</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Asteranae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Asterales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Asteraceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Solidago</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Solidago nemoralis</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Lilianae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Poales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Poaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Sorghastrum</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Sorghastrum nutans</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>species</taxonRankName>
    ##     <taxonRankValue>NA</taxonRankValue>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>species</taxonRankName>
    ##     <taxonRankValue>NA</taxonRankValue>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Lilianae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Poales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Poaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Bouteloua</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Bouteloua curtipendula</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Asteranae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Asterales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Asteraceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Coreopsis</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Coreopsis palmata</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Asteranae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Asterales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Asteraceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Solidago</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Solidago rigida</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Lilianae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Poales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Poaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Sporobolus</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Sporobolus cryptandrus</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>species</taxonRankName>
    ##     <taxonRankValue>NA</taxonRankValue>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Lilianae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Poales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Poaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Aristida</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Aristida basiramea</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>genus</taxonRankName>
    ##     <taxonRankValue>NA</taxonRankValue>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>species</taxonRankName>
    ##     <taxonRankValue>NA</taxonRankValue>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Asteranae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Lamiales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Lamiaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Hedeoma</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Hedeoma hispida</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Asteranae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Solanales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Solanaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Physalis</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Physalis virginiana</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Asteranae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Asterales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Asteraceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Taraxacum</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Taraxacum officinale</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Lilianae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Poales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Poaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Agrostis</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Agrostis scabra</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Lilianae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Poales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Poaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Eragrostis</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Eragrostis spectabilis</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Rosanae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Fabales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Fabaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Amorpha</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Amorpha canescens</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Animalia</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Bilateria</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Deuterostomia</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>phylum</taxonRankName>
    ##           <taxonRankValue>Chordata</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>subphylum</taxonRankName>
    ##             <taxonRankValue>Vertebrata</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>infraphylum</taxonRankName>
    ##               <taxonRankValue>Gnathostomata</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>superclass</taxonRankName>
    ##                 <taxonRankValue>Actinopterygii</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>class</taxonRankName>
    ##                   <taxonRankValue>Teleostei</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>superorder</taxonRankName>
    ##                     <taxonRankValue>Acanthopterygii</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>order</taxonRankName>
    ##                       <taxonRankValue>Perciformes</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>suborder</taxonRankName>
    ##                         <taxonRankValue>Percoidei</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>family</taxonRankName>
    ##                           <taxonRankValue>Percidae</taxonRankValue>
    ##                           <taxonomicClassification>
    ##                             <taxonRankName>genus</taxonRankName>
    ##                             <taxonRankValue>Perca</taxonRankValue>
    ##                             <taxonomicClassification>
    ##                               <taxonRankName>species</taxonRankName>
    ##                               <taxonRankValue>Perca flavescens</taxonRankValue>
    ##                             </taxonomicClassification>
    ##                           </taxonomicClassification>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Animalia</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Bilateria</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Deuterostomia</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>phylum</taxonRankName>
    ##           <taxonRankValue>Chordata</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>subphylum</taxonRankName>
    ##             <taxonRankValue>Vertebrata</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>infraphylum</taxonRankName>
    ##               <taxonRankValue>Gnathostomata</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>superclass</taxonRankName>
    ##                 <taxonRankValue>Actinopterygii</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>class</taxonRankName>
    ##                   <taxonRankValue>Teleostei</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>superorder</taxonRankName>
    ##                     <taxonRankValue>Protacanthopterygii</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>order</taxonRankName>
    ##                       <taxonRankValue>Osmeriformes</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>suborder</taxonRankName>
    ##                         <taxonRankValue>Osmeroidei</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>superfamily</taxonRankName>
    ##                           <taxonRankValue>Osmeroidea</taxonRankValue>
    ##                           <taxonomicClassification>
    ##                             <taxonRankName>family</taxonRankName>
    ##                             <taxonRankValue>Osmeridae</taxonRankValue>
    ##                             <taxonomicClassification>
    ##                               <taxonRankName>genus</taxonRankName>
    ##                               <taxonRankValue>Osmerus</taxonRankValue>
    ##                               <taxonomicClassification>
    ##                                 <taxonRankName>species</taxonRankName>
    ##                                 <taxonRankValue>Osmerus mordax</taxonRankValue>
    ##                               </taxonomicClassification>
    ##                             </taxonomicClassification>
    ##                           </taxonomicClassification>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Lilianae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Poales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Poaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Poa</taxonRankValue>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Lilianae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Poales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Poaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Schizachyrium</taxonRankValue>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Lilianae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Poales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Poaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Poa</taxonRankValue>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Lilianae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Poales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Poaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Schizachyrium</taxonRankValue>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>species</taxonRankName>
    ##     <taxonRankValue>NA</taxonRankValue>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Rosanae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Fabales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Fabaceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Lespedeza</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Lespedeza capitata</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Plantae</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Viridiplantae</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Streptophyta</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>superdivision</taxonRankName>
    ##           <taxonRankValue>Embryophyta</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>division</taxonRankName>
    ##             <taxonRankValue>Tracheophyta</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>subdivision</taxonRankName>
    ##               <taxonRankValue>Spermatophytina</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>class</taxonRankName>
    ##                 <taxonRankValue>Magnoliopsida</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>superorder</taxonRankName>
    ##                   <taxonRankValue>Asteranae</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>order</taxonRankName>
    ##                     <taxonRankValue>Asterales</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>family</taxonRankName>
    ##                       <taxonRankValue>Asteraceae</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>genus</taxonRankName>
    ##                         <taxonRankValue>Liatris</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>species</taxonRankName>
    ##                           <taxonRankValue>Liatris aspera</taxonRankValue>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Animalia</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Bilateria</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Deuterostomia</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>phylum</taxonRankName>
    ##           <taxonRankValue>Chordata</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>subphylum</taxonRankName>
    ##             <taxonRankValue>Vertebrata</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>infraphylum</taxonRankName>
    ##               <taxonRankValue>Gnathostomata</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>superclass</taxonRankName>
    ##                 <taxonRankValue>Actinopterygii</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>class</taxonRankName>
    ##                   <taxonRankValue>Teleostei</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>superorder</taxonRankName>
    ##                     <taxonRankValue>Protacanthopterygii</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>order</taxonRankName>
    ##                       <taxonRankValue>Salmoniformes</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>family</taxonRankName>
    ##                         <taxonRankValue>Salmonidae</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>subfamily</taxonRankName>
    ##                           <taxonRankValue>Salmoninae</taxonRankValue>
    ##                           <taxonomicClassification>
    ##                             <taxonRankName>genus</taxonRankName>
    ##                             <taxonRankValue>Oncorhynchus</taxonRankValue>
    ##                             <taxonomicClassification>
    ##                               <taxonRankName>species</taxonRankName>
    ##                               <taxonRankValue>Oncorhynchus tshawytscha</taxonRankValue>
    ##                             </taxonomicClassification>
    ##                           </taxonomicClassification>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Animalia</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Bilateria</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Deuterostomia</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>phylum</taxonRankName>
    ##           <taxonRankValue>Chordata</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>subphylum</taxonRankName>
    ##             <taxonRankValue>Vertebrata</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>infraphylum</taxonRankName>
    ##               <taxonRankValue>Gnathostomata</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>superclass</taxonRankName>
    ##                 <taxonRankValue>Actinopterygii</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>class</taxonRankName>
    ##                   <taxonRankValue>Teleostei</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>superorder</taxonRankName>
    ##                     <taxonRankValue>Protacanthopterygii</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>order</taxonRankName>
    ##                       <taxonRankValue>Salmoniformes</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>family</taxonRankName>
    ##                         <taxonRankValue>Salmonidae</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>subfamily</taxonRankName>
    ##                           <taxonRankValue>Salmoninae</taxonRankValue>
    ##                           <taxonomicClassification>
    ##                             <taxonRankName>genus</taxonRankName>
    ##                             <taxonRankValue>Oncorhynchus</taxonRankValue>
    ##                             <taxonomicClassification>
    ##                               <taxonRankName>species</taxonRankName>
    ##                               <taxonRankValue>Oncorhynchus gorbuscha</taxonRankValue>
    ##                             </taxonomicClassification>
    ##                           </taxonomicClassification>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ##   <taxonomicClassification>
    ##     <taxonRankName>kingdom</taxonRankName>
    ##     <taxonRankValue>Animalia</taxonRankValue>
    ##     <taxonomicClassification>
    ##       <taxonRankName>subkingdom</taxonRankName>
    ##       <taxonRankValue>Bilateria</taxonRankValue>
    ##       <taxonomicClassification>
    ##         <taxonRankName>infrakingdom</taxonRankName>
    ##         <taxonRankValue>Deuterostomia</taxonRankValue>
    ##         <taxonomicClassification>
    ##           <taxonRankName>phylum</taxonRankName>
    ##           <taxonRankValue>Chordata</taxonRankValue>
    ##           <taxonomicClassification>
    ##             <taxonRankName>subphylum</taxonRankName>
    ##             <taxonRankValue>Vertebrata</taxonRankValue>
    ##             <taxonomicClassification>
    ##               <taxonRankName>infraphylum</taxonRankName>
    ##               <taxonRankValue>Gnathostomata</taxonRankValue>
    ##               <taxonomicClassification>
    ##                 <taxonRankName>superclass</taxonRankName>
    ##                 <taxonRankValue>Actinopterygii</taxonRankValue>
    ##                 <taxonomicClassification>
    ##                   <taxonRankName>class</taxonRankName>
    ##                   <taxonRankValue>Teleostei</taxonRankValue>
    ##                   <taxonomicClassification>
    ##                     <taxonRankName>superorder</taxonRankName>
    ##                     <taxonRankValue>Protacanthopterygii</taxonRankValue>
    ##                     <taxonomicClassification>
    ##                       <taxonRankName>order</taxonRankName>
    ##                       <taxonRankValue>Salmoniformes</taxonRankValue>
    ##                       <taxonomicClassification>
    ##                         <taxonRankName>family</taxonRankName>
    ##                         <taxonRankValue>Salmonidae</taxonRankValue>
    ##                         <taxonomicClassification>
    ##                           <taxonRankName>subfamily</taxonRankName>
    ##                           <taxonRankValue>Salmoninae</taxonRankValue>
    ##                           <taxonomicClassification>
    ##                             <taxonRankName>genus</taxonRankName>
    ##                             <taxonRankValue>Oncorhynchus</taxonRankValue>
    ##                             <taxonomicClassification>
    ##                               <taxonRankName>species</taxonRankName>
    ##                               <taxonRankValue>Oncorhynchus kisutch</taxonRankValue>
    ##                             </taxonomicClassification>
    ##                           </taxonomicClassification>
    ##                         </taxonomicClassification>
    ##                       </taxonomicClassification>
    ##                     </taxonomicClassification>
    ##                   </taxonomicClassification>
    ##                 </taxonomicClassification>
    ##               </taxonomicClassification>
    ##             </taxonomicClassification>
    ##           </taxonomicClassification>
    ##         </taxonomicClassification>
    ##       </taxonomicClassification>
    ##     </taxonomicClassification>
    ##   </taxonomicClassification>
    ## </taxonomicCoverage>

-   [Back to top](#overview)
