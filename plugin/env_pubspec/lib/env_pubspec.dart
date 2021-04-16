import 'package:json_annotation/json_annotation.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
// ignore: implementation_imports
import 'package:pubspec_parse/src/dependency.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:checked_yaml/checked_yaml.dart';

part 'env_pubspec.g.dart';

@JsonSerializable(createToJson: false)
class EnvPubspec extends Pubspec {

  @JsonKey(fromJson: _parseEnv)
  final Map<String, String>? env;

  EnvPubspec(
    String name, {
    this.env,
    Version? version,
    String? publishTo,
    String? author,
    List<String>? authors,
    Map<String, VersionConstraint>? environment,
    String? homepage,
    Uri? repository,
    Uri? issueTracker,
    String? documentation,
    String? description,
    Map<String, Dependency>? dependencies,
    Map<String, Dependency>? devDependencies,
    Map<String, Dependency>? dependencyOverrides,
    Map<String, dynamic>? flutter,
  }) : super(
          name,
          version: version,
          publishTo: publishTo,
          author: author,
          authors: authors,
          environment: environment,
          homepage: homepage,
          repository: repository,
          issueTracker: issueTracker,
          documentation: documentation,
          description: description,
          dependencies: dependencies,
          devDependencies: devDependencies,
          dependencyOverrides: dependencyOverrides,
          flutter: flutter,
        );

  factory EnvPubspec.fromJson(Map json, {bool lenient = false}) {
    if (lenient) {
      while (json.isNotEmpty) {
        // Attempting to remove top-level properties that cause parsing errors.
        try {
          return _$EnvPubspecFromJson(Map<String, dynamic>.from(json));
        } on CheckedFromJsonException catch (e) {
          if (e.map == json && json.containsKey(e.key)) {
            json = Map.from(json)..remove(e.key);
            continue;
          }
          rethrow;
        }
      }
    }

    return _$EnvPubspecFromJson(Map<String, dynamic>.from(json));
  }

  factory EnvPubspec.parse(String yaml, {Uri? sourceUrl, bool lenient = false}) {
    return checkedYamlDecode(yaml, (map) {
      print(map);
      return EnvPubspec.fromJson(Map<String, dynamic>.from(map!), lenient: lenient);
    }, sourceUrl: sourceUrl);
  }
}

Version? _versionFromString(String? input) => input == null ? null : Version.parse(input);

Map<String, VersionConstraint> _environmentMap(Map? source) {
  if (source == null) {
    return {};
  }
  return source.map<String, VersionConstraint>(
    (k, value) {
      final key = k as String;
      if (key == 'dart') {
        // github.com/dart-lang/pub/blob/d84173eeb03c3/lib/src/pubspec.dart#L342
        // 'dart' is not allowed as a key!
        throw CheckedFromJsonException(
          source,
          'dart',
          'VersionConstraint',
          'Use "sdk" to for Dart SDK constraints.',
          badKey: true,
        );
      }

      VersionConstraint? constraint;
      if (value == null) {
        constraint = null;
      } else if (value is String) {
        try {
          constraint = VersionConstraint.parse(value);
        } on FormatException catch (e) {
          throw CheckedFromJsonException(source, key, 'Pubspec', e.message);
        }

        return MapEntry(key, constraint);
      } else {
        throw CheckedFromJsonException(source, key, 'VersionConstraint', '`$value` is not a String.');
      }
      return MapEntry(key, constraint!);
    },
  );
}

Map<String, String> _parseEnv(Map source) {
  return Map<String, String>.from(source);
}