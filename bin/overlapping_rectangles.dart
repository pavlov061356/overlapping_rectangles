import 'dart:io';

import 'package:overlapping_rectangles/overlapping_rectangles.dart'
    as overlapping_rectangles;

void main(List<String> arguments) {
  if ((arguments.length != 2) ||
      arguments.contains('--help') ||
      arguments.contains('-h')) {
    print('Usage: overlapping_rectangles.dart <input.csv> <output.csv>');
    exit(1);
  }
  return overlapping_rectangles.runSeparation(arguments[0], arguments[1]);
}
