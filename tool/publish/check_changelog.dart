import 'dart:io';

void main(List<String> args) {
  print(args);
  String changeLog = File('CHANGELOG.md').readAsStringSync();
  var tagVersion = '';
  if (args.isNotEmpty) {
    tagVersion = args[0].split('/').last;
  }
  if (tagVersion.startsWith('v')) {
    tagVersion = tagVersion.substring(1);
  }

  if (!changeLog.startsWith('## $tagVersion')) {
    throw Exception(
        'CHANGELOG.md doesn\'t started with \'## $tagVersion\' tag version ($tagVersion)');
  }
}
