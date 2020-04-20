# taxonomyCleanr 1.3.0

### Enhancement

* __EML 2.2.0:__ EML output from `make_taxonomicCoverage()` now uses schema version 2.2.0. Note: Annotation has not yet been implemented.

# taxonomyCleanr 1.2.0

### Enhancements

These enhancements focus on making the resolve functions more robust and efficient, specifically:

* Warn if an authority can't be reached
* Don't try resolving taxa that have already been resolved
* Return results even if the connection to the authority fails

# taxonomyCleanr 1.1.3

### Bug fixes

* __New table readers:__ Old table readers were inaccurately reading data (e.g. dropping quote characters). This has been fixed.

### Enhancements

* __tibble input:__ Tibbles are now an accepted input taxonomyCleanr functions.

# taxonomyCleanr 1.1.2

### Bug fixes

* __Invalid taxonomicCoverage EML:__ Invalid taxonomicCoverage EML was being created due to incorrectly nested list objects names. This issue has been fixed.

# taxonomyCleanr 1.1.1

### Bug fixes

* __Missing taxonomicClassification:__ The taxonomicClassification element was missing from the taxonomicCoverage top-level list producing invalid EML. This issue has been fixed.

# taxonomyCleanr 1.1.0

### Enhancements

* __EML v2.0.0:__ `make_taxonomicCoverage()` now works with `EML` v.2.0.0 and outputs the taxonomicCoverage node as a list object and/or an .xml file written to path. The argument `write.file` has been added to enable use of taxa_map.csv without writing to file. These changes are based on a pull request by @srearl.

# taxonomyCleanr 1.0.1

### Bug fixes

* __Invalid input:__ Refactor calls to `taxize`. The `taxize` package changed to tibble outputs and taxonomyCleanr was expecting data frames. Inputs from taxize are now converted to data frames prior to processing. Thanks for reporting this issue @srearl!

# taxonomyCleanr 1.0.0

### Enhancements

* __Demo vignette:__ Clean up demonstration vignette.
* __Project website:__ Build project website with `pkgdown`.
* __Change log:__ Add change log!
