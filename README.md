# `build_pubspec`

This package helps you convert fields from your `pubspec.yaml` file into Dart code.
Based on the fields in your pubspec, this package will generate Dart code so
that you can access these fields easily from your Flutter, AngularDart, command-line tool, or backend app.

![Pub](https://img.shields.io/pub/v/build_pubspec.svg)

## Common use-cases

* Create command-line apps and fill out the `help` headline and `version` commands automatically
* Create beautiful example apps for your Flutter packages and plugins with an always-up-to-date description and links to your docs, issue tracker and repository
* Display the current version of your app to your users in your mobile app
* Add app version to your logs, analytics or backend calls

## Usage

1. Add `build_pubspec` to your `pubspec.yaml` as **`dev_dependency`**. Make sure [`build_runner`](https://pub.dev/packages/build_runner) is also listed as development dependency.

    ```yaml
    dev_dependencies:
      build_runner: ^1.0.0
      build_pubspec: ^1.0.0
    ```

2. Get dependencies: `pub get`. If you are using Flutter, run `flutter pub get`.

3. Build!

    ```console
    $ pub run build_runner build
    ```
 
    Based on the following `pubspec.yaml` file...

    ```yaml
    name: build_pubspec_example
    description: This is an example description.
    publish_to: 'none'
    authors:
      - Vince Varga <vince.varga@dartside.dev>
    version: 0.1.2
    ```
   
   ... the default build will create the `lib/src/pubspec.dart` file:

    ```dart
    // Generated file. Do not modify.
    //
    // This file is generated using the build_pubspec package.
    // For more information, go to: https://pub.dev/packages/build_pubspec
    const List<String> authors = [
      'Vince Varga <vince.varga@dartside.dev>',
    ];
    const String description =
        '''This is an example description.''';
    const String name = '''build_pubspec_example''';
    const String version = '''0.1.2''';
    ```

4. Use the generated Dart code.
   
   You can now include this Dart file in your app code if you want to reference a field from your `pubspec.yaml` file.

## Examples

I maintain various examples for this package. Check them all out in the [`examples/`](https://github.com/dartsidedev/build_pubspec/tree/master/example) folder.

## Customize your build

Create a `build.yaml` file in your project.

### Change field names

You can customize the output Dart file's fields names, for example, if you want to output the `version` as `const String v = '...';'`.

If a key is not present in the `pubspec.yaml`, it will not be part of the output Dart file.

If you wish to skip a key, set its field name option to empty string.

```yaml
targets:
  $default:
    builders:
      build_pubspec:
        options:
          authors_field_name: betterAuthors
          description_field_name: betterDescription
          documentation_field_name: betterDocumentation
          homepage_field_name: betterHomepage
          issue_tracker_field_name: betterIssueTracker
          # name field is intentionally left empty in this example to
          # demo how to skip the name in the output dart file.
          name_field_name: ''
          repository_field_name: betterRepository
          version_field_name: betterVersion
```

### Change output file

By default, the destination file is `lib/src/pubspec.dart`.

If you wish to change it, create a `build.yaml` file in your project: 

```yaml
targets:
  $default:
    builders:
      build_pubspec:
        options:
          destination_file: 'lib/details.dart'
```

### Part files with `source_gen`
    
It is also possible to generate the version string as a part of an existing library 
in your package.

Disable the default builder, and enable the part builder:
   
```yaml
targets:
  $default:
    builders:
      build_pubspec:
        enabled: false
      build_pubspec|build_pubspec_part:
        enabled: true
        generate_for: ['lib/src/example.dart']
        options:
          version_field_name: 'exampleVersion' # defaults to 'packageVersion'
```

Make sure your `lib/src/example.dart` contains `part 'example.version.g.dart';`,

Once you run `pub run build_runner build`, the part file will be generated into `lib/src/my_lib.version.g.dart`.

# Acknowledgements

This package is based on [`build_version`](https://pub.dev/packages/build_version). Thank you for the original author, [Kevin Moore](https://pub.dev/publishers/j832.com/packages). It also includes fixes to the original repository from [Alexey Knyazev](https://github.com/lexaknyazev/build_version/tree/custom-name-source-gen). I could not have created this package without their original work.

# TODOs

I just got rid of Travis, so I need to take care of a new CI/CD pipeline. GitHub Actions.

* analyze, lint, run tests, all the usual stuff
* go to example folders and make sure the examples run correctly, make sure no git changes
