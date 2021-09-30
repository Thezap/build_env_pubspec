/// Configuration for using `package:build`-compatible build systems.
///
/// This library is **not** intended to be imported by typical end-users unless
/// you are creating a custom compilation pipeline.
///
/// See [package:build_runner](https://pub.dev/packages/build_runner)
/// for more information.
library builder;

import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:env_pubspec/env_pubspec.dart';
import 'package:source_gen/source_gen.dart';

Builder buildPubspec([BuilderOptions? options]) {
  return _PubspecBuilder(options);
}

Builder buildPubspecPart([BuilderOptions? options]) {
  final fields = _FieldsContainer.fromBuilderOptions(options!);
  final generators = [_PubspecPartGenerator(fields)];
  return PartBuilder(generators, '.pubspec.env.dart');
}

class _PubspecBuilder implements Builder {
  _PubspecBuilder([BuilderOptions? options])
      : fields = _FieldsContainer.fromBuilderOptions(options!),
        destination = _destinationFromBuilderOptions(options);

  final _FieldsContainer fields;
  final String destination;

  @override
  Future build(BuildStep buildStep) async {
    final id = AssetId(buildStep.inputId.package, destination);
    final contents = await _build(buildStep, fields);
    await buildStep.writeAsString(id, contents);

    // add also static file with reexport
    final staticId = AssetId(buildStep.inputId.package, 'lib/src/pubspec/pubspec.dart');
    await buildStep.writeAsString(staticId, """"
part '.pubspec.env.dart';
    """);
  }

  @override
  Map<String, List<String>> get buildExtensions {
    return {
      'pubspec.yaml': [destination]
    };
  }
}

class _PubspecPartGenerator extends Generator {
  _PubspecPartGenerator(this.fields);

  final _FieldsContainer fields;

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) {
    return _build(buildStep, fields);
  }
}

Future<String> _build(BuildStep buildStep, _FieldsContainer fields) async {
  final assetId = AssetId(buildStep.inputId.package, 'pubspec.yaml');
  final content = await buildStep.readAsString(assetId);
  final pubspec = EnvPubspec.parse(content, sourceUrl: assetId.uri);
  final buff = StringBuffer();
  const _header =
      '''// Generated file. Do not modify.\n//\n// This file is generated using the build_pubspec package.\n// For more information, go to: https://pub.dev/packages/build_pubspec''';
  buff.writeln(_header);

  buff.writeln('''class Pubspec {''');

  if (pubspec.authors != null && pubspec.authors.isNotEmpty && fields.authorsFieldName.isNotEmpty) {
    buff.writeln('''  static const List<String> ${fields.authorsFieldName} = [''');
    final writeAuthor = (author) => buff.writeln('''    '$author',''');
    pubspec.authors.forEach(writeAuthor);
    buff.writeln('''  ];''');
  }

  if (pubspec.description != null && fields.descriptionFieldName.isNotEmpty) {
    buff.writeln("""  static const String ${fields.descriptionFieldName} = '''${pubspec.description}''';""");
  }

  if (pubspec.documentation != null && fields.documentationFieldName.isNotEmpty) {
    buff.writeln("""  static const String ${fields.documentationFieldName} = '''${pubspec.documentation}''';""");
  }

  if (pubspec.homepage != null && fields.homepageFieldName.isNotEmpty) {
    buff.writeln("""  static const String ${fields.homepageFieldName} = '''${pubspec.homepage}''';""");
  }

  if (pubspec.issueTracker != null && fields.issueTrackerFieldName.isNotEmpty) {
    buff.writeln("""  static const String ${fields.issueTrackerFieldName} = '''${pubspec.issueTracker}''';""");
  }

  if (pubspec.name != null && fields.nameFieldName.isNotEmpty) {
    buff.writeln("""  static const String ${fields.nameFieldName} = '''${pubspec.name}''';""");
  }

  if (pubspec.repository != null && fields.repositoryFieldName.isNotEmpty) {
    buff.writeln("""  static const String ${fields.repositoryFieldName} = '''${pubspec.repository}''';""");
  }

  if (pubspec.version != null && fields.versionFieldName.isNotEmpty) {
    buff.writeln("""  static const String ${fields.versionFieldName} = '''${pubspec.version}''';""");
  }
  buff.writeln('''}''');


  if (pubspec.env != null) {
    buff.writeln('''class PubspecEnv {''');
    await Future.forEach<MapEntry<String, String>>(pubspec.env!.entries, (entries) async {
      final key = entries.key;
      final value = entries.value;
      print('run for of $key');
      final result = await Process.run('sh', ['-c', 'echo -n "$value"'], runInShell: true);
      print('exite code ${result.exitCode}');
      String out;
      if (result.exitCode != 0) {
        out = '''NullThrownError()''';
        print(result.stderr);
      } else {
        out = result.stdout as String;
        print('value of $out');
      }
      buff.writeln("""  static const String $key = '''$out''';""");
    });

    buff.writeln('''}''');
    print(pubspec.env);
  }

  return buff.toString();
}


class _FieldsContainer {
  _FieldsContainer(Map<String, dynamic> config)
      : authorsFieldName = _f(config, 'authors'),
        descriptionFieldName = _f(config, 'description'),
        documentationFieldName = _f(config, 'documentation'),
        homepageFieldName = _f(config, 'homepage'),
        issueTrackerFieldName = _f(config, 'issue_tracker'),
        nameFieldName = _f(config, 'name'),
        repositoryFieldName = _f(config, 'repository'),
        versionFieldName = _f(config, 'version');

  factory _FieldsContainer.fromBuilderOptions(BuilderOptions options) {
    return _FieldsContainer(options?.config ?? {});
  }

  /// Build field name based on the field [name] and the passed in [config].
  static String _f(Map<String, dynamic> config, String name) {
    final field = _snakeToCamel(name);
    if (config == null) return field;
    final key = '${name}_field_name';
    return config[key] as String ?? field;
  }

  final String authorsFieldName;
  final String descriptionFieldName;
  final String documentationFieldName;
  final String homepageFieldName;
  final String issueTrackerFieldName;
  final String nameFieldName;
  final String repositoryFieldName;
  final String versionFieldName;
}

String _destinationFromBuilderOptions(BuilderOptions options) {
  const defaultDestination = 'lib/src/pubspec/pubspec.g.dart';
  if (options == null) return defaultDestination;
  if (options.config == null) return defaultDestination;
  return options.config['destination_file'] as String ?? defaultDestination;
}

String _snakeToCamel(String snake) {
  return snake
      .split('_')
      .asMap()
      .map((i, w) {
        if (i == 0) return MapEntry(i, w);
        final v = '${w.substring(0, 1).toUpperCase()}${w.substring(1)}';
        return MapEntry(i, v);
      })
      .values
      .join('');
}
