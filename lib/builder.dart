/// Configuration for using `package:build`-compatible build systems.
///
/// This library is **not** intended to be imported by typical end-users unless
/// you are creating a custom compilation pipeline.
///
/// See [package:build_runner](https://pub.dev/packages/build_runner)
/// for more information.
library builder;

import 'dart:async';
import 'package:meta/meta.dart';
import 'package:build/build.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:source_gen/source_gen.dart';

const String _header = '''
// Generated file. Do not modify.
//
// This file is generated using the build_pubspec package.
// For more information, go to: https://pub.dev/packages/build_pubspec''';

Future<String> _pubspecSource({
  @required BuildStep buildStep,
  @required String authorsFieldName,
  @required String descriptionFieldName,
  @required String documentationFieldName,
  @required String homepageFieldName,
  @required String issueTrackerFieldName,
  @required String nameFieldName,
  @required String repositoryFieldName,
  @required String versionFieldName,
}) async {
  final assetId = AssetId(buildStep.inputId.package, 'pubspec.yaml');
  final content = await buildStep.readAsString(assetId);
  final pubspec = Pubspec.parse(content, sourceUrl: assetId.uri);

  final buff = StringBuffer();

  buff.writeln(_header);

  if (pubspec.authors != null && pubspec.authors.isNotEmpty) {
    buff.writeln('''const List<String> $authorsFieldName = [''');
    final writeAuthor = (author) => buff.writeln('''  '$author',''');
    pubspec.authors.forEach(writeAuthor);
    buff.writeln('''];''');
  }

  if (pubspec.description != null) {
    buff.writeln(
        """const String $descriptionFieldName = '''${pubspec.description}'''; """);
  }

  if (pubspec.documentation != null) {
    buff.writeln(
        """const String $documentationFieldName = '${pubspec.documentation}';""");
  }

  if (pubspec.homepage != null) {
    buff.writeln(
        """const String $homepageFieldName = '${pubspec.homepage}';""");
  }

  if (pubspec.issueTracker != null) {
    buff.writeln(
        """const String $issueTrackerFieldName = '${pubspec.issueTracker}';""");
  }

  if (pubspec.name != null) {
    buff.writeln("""const String $nameFieldName = '${pubspec.name}';""");
  }

  if (pubspec.repository != null) {
    buff.writeln(
        """const String $repositoryFieldName = '${pubspec.repository}';""");
  }

  if (pubspec.version != null) {
    buff.writeln('''const String $versionFieldName = '${pubspec.version}';''');
  }

  return buff.toString();
}

Builder buildPubspec([BuilderOptions options]) => _PubspecBuilder(options);

Builder buildPubspecPart([BuilderOptions options]) {
  return PartBuilder(
    [
      _PubspecPartGenerator(
        authorsFieldName: _authorsFieldName(options),
        descriptionFieldName: _descriptionFieldName(options),
        documentationFieldName: _documentationFieldName(options),
        homepageFieldName: _homepageFieldName(options),
        issueTrackerFieldName: _issueTrackerFieldName(options),
        nameFieldName: _nameFieldName(options),
        repositoryFieldName: _repositoryFieldName(options),
        versionFieldName: _versionFieldName(options),
      ),
    ],
    '.pubspec.g.dart',
  );
}

// TODO(vargavince91): Support all field name customization
// https://github.com/dartsidedev/build_pubspec/issues/1

String _field(BuilderOptions options, String field, String defaultName) {
  if (options != null &&
      options.config != null &&
      options.config.containsKey(field)) {
    return options.config[field] as String;
  }
  return defaultName;
}

String _authorsFieldName(BuilderOptions options) =>
    _field(options, 'authors_field_name', 'authors');

String _descriptionFieldName(BuilderOptions options) =>
    _field(options, 'description_field_name', 'description');

String _documentationFieldName(BuilderOptions options) =>
    _field(options, 'documentation_field_name', 'documentation');

String _homepageFieldName(BuilderOptions options) =>
    _field(options, 'homepage_field_name', 'homepage');

String _issueTrackerFieldName(BuilderOptions options) =>
    _field(options, 'issue_tracker_field_name', 'issueTracker');

String _nameFieldName(BuilderOptions options) =>
    _field(options, 'name_field_name', 'name');

String _repositoryFieldName(BuilderOptions options) =>
    _field(options, 'repository_field_name', 'repository');

String _versionFieldName(BuilderOptions options) =>
    _field(options, 'version_field_name', 'version');

class _PubspecBuilder implements Builder {
  _PubspecBuilder([BuilderOptions options])
      : authorsFieldName = _authorsFieldName(options),
        descriptionFieldName = _descriptionFieldName(options),
        documentationFieldName = _documentationFieldName(options),
        homepageFieldName = _homepageFieldName(options),
        issueTrackerFieldName = _issueTrackerFieldName(options),
        nameFieldName = _nameFieldName(options),
        repositoryFieldName = _repositoryFieldName(options),
        versionFieldName = _versionFieldName(options);

  final String authorsFieldName;
  final String descriptionFieldName;
  final String documentationFieldName;
  final String homepageFieldName;
  final String issueTrackerFieldName;
  final String nameFieldName;
  final String repositoryFieldName;
  final String versionFieldName;

  @override
  Future build(BuildStep buildStep) async {
    await buildStep.writeAsString(
      AssetId(buildStep.inputId.package, 'lib/src/pubspec.dart'),
      await _pubspecSource(
        buildStep: buildStep,
        authorsFieldName: authorsFieldName,
        descriptionFieldName: descriptionFieldName,
        documentationFieldName: documentationFieldName,
        homepageFieldName: homepageFieldName,
        issueTrackerFieldName: issueTrackerFieldName,
        nameFieldName: nameFieldName,
        repositoryFieldName: repositoryFieldName,
        versionFieldName: versionFieldName,
      ),
    );
  }

  @override
  final buildExtensions = const {
    r'$lib$': ['src/pubspec.dart']
  };
}

class _PubspecPartGenerator extends Generator {
  _PubspecPartGenerator({
    @required this.authorsFieldName,
    @required this.descriptionFieldName,
    @required this.documentationFieldName,
    @required this.homepageFieldName,
    @required this.issueTrackerFieldName,
    @required this.nameFieldName,
    @required this.repositoryFieldName,
    @required this.versionFieldName,
  });

  final String authorsFieldName;
  final String descriptionFieldName;
  final String documentationFieldName;
  final String homepageFieldName;
  final String issueTrackerFieldName;
  final String nameFieldName;
  final String repositoryFieldName;
  final String versionFieldName;

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) =>
      _pubspecSource(
        buildStep: buildStep,
        authorsFieldName: authorsFieldName,
        descriptionFieldName: descriptionFieldName,
        documentationFieldName: documentationFieldName,
        homepageFieldName: homepageFieldName,
        issueTrackerFieldName: issueTrackerFieldName,
        nameFieldName: nameFieldName,
        repositoryFieldName: repositoryFieldName,
        versionFieldName: versionFieldName,
      );
}
