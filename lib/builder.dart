/// Configuration for using `package:build`-compatible build systems.
///
/// This library is **not** intended to be imported by typical end-users unless
/// you are creating a custom compilation pipeline.
///
/// See [package:build_runner](https://pub.dev/packages/build_runner)
/// for more information.
library builder;

import 'dart:async';
import 'package:build/build.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:source_gen/source_gen.dart';


Future<String> _pubspecSource(BuildStep buildStep, String versionFieldName) async {
  final assetId = AssetId(buildStep.inputId.package, 'pubspec.yaml');
  final content = await buildStep.readAsString(assetId);
  final pubspec = Pubspec.parse(content, sourceUrl: assetId.uri);

  if (pubspec.version == null) {
    throw StateError('pubspec.yaml does not have a version defined.');
  }
  return '''
// Generated file. Do not modify.
//
// This file is generated using the build_pubspec package.
// For more information, go to: https://pub.dev/packages/build_pubspec

const String $versionFieldName = '${pubspec.version}';
''';
}

Builder buildPubspec([BuilderOptions options]) => _PubspecBuilder(options);

Builder buildPubspecPart([BuilderOptions options]) => PartBuilder(
    [_PubspecPartGenerator(_versionFieldName(options))], '.pubspec.g.dart');

// TODO(vargavince91): Support all field name customization
// https://github.com/dartsidedev/build_pubspec/issues/1
String _versionFieldName(BuilderOptions options) =>
    options != null && options.config.containsKey('version_field_name')
        ? options.config['version_field_name'] as String
        : 'packageVersion';

class _PubspecBuilder implements Builder {
  _PubspecBuilder([BuilderOptions options]) : versionFieldName = _versionFieldName(options);

  final String versionFieldName;

  @override
  Future build(BuildStep buildStep) async {
    await buildStep.writeAsString(
        AssetId(buildStep.inputId.package, 'lib/src/pubspec.dart'),
        await _pubspecSource(buildStep, versionFieldName));
  }

  @override
  final buildExtensions = const {
    r'$lib$': ['src/pubspec.dart']
  };
}

class _PubspecPartGenerator extends Generator {
  _PubspecPartGenerator(this.versionFieldName);

  final String versionFieldName;

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async =>
      _pubspecSource(buildStep, versionFieldName);
}
