import 'dart:convert';

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:build_pubspec/builder.dart';
import 'package:checked_yaml/checked_yaml.dart';
import 'package:test/test.dart';

final _isParsedYamlException = const TypeMatcher<ParsedYamlException>();

void main() {
  test('no name provided', () async {
    expect(
        () => testBuilder(
            buildPubspec(), _createPackageStub({'version': '1.0.0'})),
        throwsA(_isParsedYamlException));
  });
  test('no version provided', () async {
    expect(
        () => testBuilder(buildPubspec(), _createPackageStub({'name': 'pkg'})),
        throwsA(const TypeMatcher<StateError>().having((se) => se.message,
            'message', 'pubspec.yaml does not have a version defined.')));
  }, skip: true);
  test('bad version provided', () async {
    expect(
        () => testBuilder(buildPubspec(),
            _createPackageStub({'name': 'pkg', 'version': 'not a version'})),
        throwsA(_isParsedYamlException));
  });
  test('valid input', () async {
    await testBuilder(
        buildPubspec(), _createPackageStub({'name': 'pkg', 'version': '1.0.0'}),
        outputs: {
          'pkg|lib/src/pubspec.dart': r'''
// Generated file. Do not modify.
//
// This file is generated using the build_pubspec package.
// For more information, go to: https://pub.dev/packages/build_pubspec
const String name = 'pkg';
const String version = '1.0.0';
'''
        });
  });
  test('valid input with custom field', () async {
    await testBuilder(
        buildPubspec(const BuilderOptions({'version_field_name': 'myVersion'})),
        _createPackageStub({'name': 'pkg', 'version': '1.0.0'}),
        outputs: {
          'pkg|lib/src/pubspec.dart': r'''
// Generated file. Do not modify.
//
// This file is generated using the build_pubspec package.
// For more information, go to: https://pub.dev/packages/build_pubspec
const String name = 'pkg';
const String myVersion = '1.0.0';
'''
        });
  });
}

Map<String, String> _createPackageStub(Map<String, dynamic> pubspecContent) => {
      'pkg|pubspec.yaml': jsonEncode(pubspecContent),
    };
