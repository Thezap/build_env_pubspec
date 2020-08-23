# `build_pubspec`

This package helps you convert fields from your `pubspec.yaml` file into Dart code. Based on the fields in your pubspec, this package will generate Dart code so that you can access these fields easily from your Flutter, AngularDart, or backend app.

![Pub](https://img.shields.io/pub/v/build_pubspec.svg)
[![Build Status](https://travis-ci.com/dartsidedev/build_pubspec.svg?branch=master)](https://travis-ci.com/dartsidedev/build_pubspec)

## Common use-cases

* Display current version of your app to your users
* Add build information to your logs, analytics or backend calls
* Create example apps for your Flutter packages and plugins with an up-to-date description and links to your docs, issue tracker and repository

Do you have another use case for this package? [Tell me about it on Twitter](https://twitter.com/serial_dev) or [open a issue on GitHub](https://github.com/dartsidedev/build_pubspec). I appreciate your help in making this package better.

## Usage

1. Add `build_pubspec` to your `pubspec.yaml` as **`dev_dependency`**. Make sure [`build_runner`](https://pub.dev/packages/build_runner) is also listed as development dependency.

    ```yaml
    name: your_package
    version: 1.2.3
    authors:
      - McPubby Pubspec <mcpubby.pubspec@example.com>
    dev_dependencies:
      build_runner: ^1.0.0
      # Look up latest version on https://pub.dev/packages/build_pubspec#-changelog-tab-
      build_pubspec: ^1.0.0
    ```

2. Run a build.

    ```console
    $ pub run build_runner build
    ```

    `lib/src/pubspec.dart` will be generated with content, based on the `pubspec.yaml file`

    ```console
    $ cat pubspec.dart
    name: build_pubspec_example
    description: This is an example description. Great job! Awesome package.
    publish_to: 'none'
    authors:
      - Vince Varga <vince.varga@dartside.dev>

    version: 0.1.2

    environment:
      sdk: ">=2.1.0 <3.0.0"

    dev_dependencies:
      build_runner: ^1.0.0
      build_pubspec:
        path: ../../
    ```

    ```console
    $ cat lib/src/pubspec.dart
    // Generated file. Do not modify.
    //
    // This file is generated using the build_pubspec package.
    // For more information, go to: https://pub.dev/packages/build_pubspec
    const List<String> authors = [
      'Vince Varga <vince.varga@dartside.dev>',
    ];
    const String description =
        '''This is an example description. Great job! Awesome package.''';
    const String name = '''build_pubspec_example''';
    const String version = '''0.1.2''';
    ```

    You can now include this Dart file in your app code if you want to reference a field from your `pubspec.yaml` file.

### Customization

#### Change output file

#### Change field names

#### Part files

## Examples

I maintain various examples for this package. Check them all out at TODO: link.

example apps (or integration test cases):
* simple
* renamed
* .g.dart
* flutter



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

This package is based on [`build_version`](https://pub.dev/packages/build_version). Thank you for the original author, [Kevin Moore](https://pub.dev/publishers/j832.com/packages). It also includes fixes to the original repository from [Alexey Knyazev](https://github.com/lexaknyazev/build_version/tree/custom-name-source-gen). I could not have created this package without their original work.
