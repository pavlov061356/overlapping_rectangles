library overlapping_rectangles;

import 'package:overlapping_rectangles/rectangles.dart';
import 'package:overlapping_rectangles/separation.dart';

void runSeparation(
  String inputCsvPath,
  String outputCsvPath, {
  Duration timeout = const Duration(minutes: 10),
}) {
  List<Rectangle> rectangles = Rectangle.fromCsv(inputCsvPath);
  Separation separation = Separation(
    rectangles,
  );

  var startTime = DateTime.now();
  while (DateTime.now().difference(startTime) < timeout) {
    if (!Rectangle.hasOverlaps(rectangles)) break;

    separation.step();
  }
  Rectangle.toCsv(rectangles, outputCsvPath);
}
