# `build_pubspec`

## 0.1.2 - October 17, 2019

* Add option to override destination file.
* Support custom field names in destination Dart code for all supported fields

## 0.1.1 - October 15, 2019

Add new supported fields: `authors`, `description`, `documentation`, `homepage`, `issueTracker`, `name`, `repository`.

In case the field is not present in the pubspec, the builder just skips it.

The code is still quite messy and the documentation is lacking.

## 0.1.0 - October 14, 2019

Create new package, `build_pubspec` based on `build_version` package.

* Rename package
* Improve documentation
* Add example project

# `build_version`

This package is based on [`kevmoo/build_version`](https://github.com/kevmoo/build_version). Here's the original change log.

## `build_version: 2.0.1`

* Support the latest `package:build_config`.

## Merged from `lexaknyazev/build_version`

[Got changes from `lexaknyazev/build_version` fork](https://github.com/lexaknyazev/build_version/tree/custom-name-source-gen)

* Users can now customize the version constant name and the generated 
  version file could be a part of an existing package library. 

## `build_version: 2.0.0`

* The builder now runs when `build_version` is a dependency. `build.yaml`
  changes are no longer required.

## `build_version: 1.0.1`

* Support `package:build_runner` `v1.0.0`.

## `build_version: 1.0.0`

* Initial version, created by Stagehand
