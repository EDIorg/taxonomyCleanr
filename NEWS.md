# taxonomyCleanr 1.5.0

### Enhancement

* __Improve handling of unsupported authorities:__ Methods have been improved for unsupported authorities (i.e. authorities other than "ITIS", "WORMS", "GBIF"). Users can now annotate outputs of `make_taxonomicCoverage()` with the `authority` and `authority.id` arguments. Values for these args will be listed in the return object "as is" and should correspond to the authority home page URL/URI and the taxon's ID within that authority system, respectively. Additionally, users can now manually define the taxon's `rank`. _NOTE: These new methods don't facilitate expansion of a taxon resolved in an unsupported system to the full classification hierarchy that is currently available when using ITIS, WORMS, or GBIF. That will require additional effort._ Furthermore, methods for supported authorities are more clearly defined in function docs. The enhancement partially addresses [EMLassemblyline issue #50](https://github.com/EDIorg/EMLassemblyline/issues/50).

# taxonomyCleanr 1.4.1

### Bug fix

* __get_classification():__ Was throwing errors for unresolvable taxa. No long doing this.

# taxonomyCleanr 1.4.0

### Enhancement

* __Annotation:__ Authority system and taxon identifier are now listed for each taxonomicClassification node (taxonomic rank) created via `make_taxonomicCoverage()` or `get_classification()`. Fixes [issue #28](https://github.com/EDIorg/taxonomyCleanr/issues/28)

* __Common names:__ All common names are listed, when available, for each taxonomicClassification node (taxonomic rank) created via `make_taxonomicCoverage()` or `get_classification()`. Fixes [issue #14](https://github.com/EDIorg/taxonomyCleanr/issues/14)

# taxonomyCleanr 1.3.2

### Bug fix

* __Resolve common taxa:__ Changes in `taxize::get_tsn_()` resulted in `resolve_comm_taxa()` unable to fetch data. This issue has been fixed. Thanks @srearl!

# taxonomyCleanr 1.3.1

### Bug fix

* __get_classification():__ A deprecated argument in `taxize::classification()` was throwing errors. Thanks for the fix @srearl !

# taxonomyCleanr 1.3.0

### Enhancements

* __Support unresolved taxa:__ Taxa that could not be resolved to an authority system are now included in EML outputs with an accompanied taxonomic rank value of "unknown".
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
