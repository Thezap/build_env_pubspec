WIP. Fork of build_version, soon to include all fields from the pubspec.

explain when to use this: maybe if you publish multiple plugins and you want to include the example app's info?

example apps (or integration test cases):
* simple
* renamed
* .g.dart
* flutter

![Pub](https://img.shields.io/pub/v/build_pubspec.svg)
[![Build Status](https://travis-ci.com/dartsidedev/build_pubspec.svg?branch=master)](https://travis-ci.com/dartsidedev/build_pubspec)

Include the version of your package in our source code.

1. Add `build_pubspec` to `pubspec.yaml`.
   field.

    ```yaml
    name: my_pkg
    version: 1.2.3
    dev_dependencies:
      build_runner: ^1.0.0
      build_pubspec: ...
    ```

2. Run a build.

    ```console
    > pub run build_runner build
    ```

    `lib/src/pubspec.dart` will be generated with content:

    ```dart
    // Generated code. Do not modify.
    const version = '1.2.3';
    ```

3. To customize the name of the constants, a `build.yaml`'s `option` can be used.

    ```yaml
    targets:
      $default:
        builders:
          build_pubspec:
            options:
              version_field_name: 'myVersion' # defaults to 'version'
    ```
    
4. It is also possible to generate the version string as a part of an existing library 
   in your package. In such a case, the default version builder needs to be disabled and 
   the version part builder should be used.
   
    ```yaml
    targets:
      $default:
        builders:
          build_pubspec:
            enabled: false
          build_pubspec|build_pubspec_part:
            enabled: true
            generate_for: ['lib/src/my_lib.dart']
            options:
              version_field_name: 'myLibraryVersion' # defaults to 'packageVersion'
    ```

   Assuming that `lib/src/my_lib.dart` contains `part 'my_lib.version.g.dart';`,
   `lib/src/my_lib.version.g.dart` will be generated with content:

    ```dart
    // GENERATED CODE - DO NOT MODIFY BY HAND
    
    part of 'my_lib.dart';
    
    // **************************************************************************
    // _VersionPartGenerator
    // **************************************************************************
    
    // Generated code. Do not modify.
    const packageVersion = '1.2.3';
    ```

  
# Acknowledgements

This package is based on [`build_version`](https://pub.dev/packages/build_version). Thank you for the original author, [Kevin Moore](https://pub.dev/publishers/j832.com/packages). It also includes fixes to the original repository from [Alexey Knyazev](https://github.com/lexaknyazev/build_version/tree/custom-name-source-gen).

If you find code or instructions that were not updated, open an issue, or ping me on [Twitter](https://twitter.com/serial_dev). I appreciate your help in making this package better.