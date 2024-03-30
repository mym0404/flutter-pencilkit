import 'dart:io';

import 'package:yaml/yaml.dart';

// ignore_for_file: avoid_print

void main() async {
  var output = await Process.run('yarn', ['check:all']);
  if (output.exitCode != 0) {
    print(output.stderr);
    print('❌ The version $version is failed to publish\nCheck process failed');
  }

  var pubspec = File('pubspec.yaml');
  var content = loadYaml(pubspec.readAsStringSync()) as YamlMap;
  var version = content['version'] as String;

  String changeLog = File('CHANGELOG.md').readAsStringSync();
  if (!changeLog.startsWith('## $version')) {
    throw Exception(
        'CHANGELOG.md doesn\'t started with \'## $version\' tag version ($version)');
  }

  print('🎉 The version $version is valid to publish!');

  var output = await Process.run('bash', ['dart', 'pub', 'publish']);
  if (output.exitCode == 0) {
    print(output.stdout);
    print('🎉 The version $version is published!');
  } else {
    print(output.stderr);
    print('❌ The version $version is failed to publish');
  }
}
