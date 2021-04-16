// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_pubspec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnvPubspec _$EnvPubspecFromJson(Map<String, dynamic> json) {
  return EnvPubspec(
    json['name'] as String,
    env: _parseEnv(json['env'] as Map),
    version: _versionFromString(json['version'] as String?),
    publishTo: json['publishTo'] as String?,
    author: json['author'] as String?,
    authors:
        (json['authors'] as List<dynamic>?)?.map((e) => e as String).toList(),
    environment: _environmentMap(json['environment'] as Map?),
    homepage: json['homepage'] as String?,
    repository: json['repository'] == null
        ? null
        : Uri.parse(json['repository'] as String),
    issueTracker: json['issueTracker'] == null
        ? null
        : Uri.parse(json['issueTracker'] as String),
    documentation: json['documentation'] as String?,
    description: json['description'] as String?,
    dependencies: parseDeps(json['dependencies'] as Map?),
    devDependencies: parseDeps(json['devDependencies'] as Map?),
    dependencyOverrides: parseDeps(json['dependencyOverrides'] as Map?),
    flutter: json['flutter'] as Map<String, dynamic>?,
  );
}
