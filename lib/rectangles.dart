import 'dart:io';
import 'dart:math';
import 'package:csv/csv.dart';

class Offset {
  double dx, dy;

  Offset(this.dx, this.dy);
}

class Rectangle {
  double left;
  double top;
  double width;
  double height;

  double originalLeft;
  double originalTop;

  bool isFixed;

  Rectangle(
    this.left,
    this.top,
    this.width,
    this.height, {
    this.isFixed = false,
  })  : originalLeft = left,
        originalTop = top;

  double get right => left + width;
  double get bottom => top + height;
  double get area => width * height;

  double get originalRight => originalLeft + width;
  double get originalBottom => originalTop + height;

  double get midx => (left + right) / 2;
  double get midy => (top + bottom) / 2;

  double get originalMidx => (originalLeft + originalRight) / 2;
  double get originalMidy => (originalTop + originalBottom) / 2;

  double get distanceFromOriginal => sqrt(
        pow(left - originalLeft, 2) + pow(top - originalTop, 2),
      );

  double get deltax => originalLeft - left;
  double get deltay => originalTop - top;

  void rotate(double theta) {
    double newLeft = originalLeft + deltax * cos(theta) - deltay * sin(theta);
    double newTop = originalTop + deltax * sin(theta) + deltay * cos(theta);

    left = newLeft;
    top = newTop;
  }

  bool overlap(Rectangle other) {
    if (left >= other.right || other.left >= right) return false;
    if (top >= other.bottom || other.top >= bottom) return false;
    return true;
  }

  double overlapx(Rectangle other) =>
      max(0, min(right, other.right) - max(left, other.left));

  double overlapy(Rectangle other) =>
      max(0, min(bottom, other.bottom) - max(top, other.top));

  Rectangle overlapRect(Rectangle other) {
    double left = max(this.left, other.left);
    double top = max(this.top, other.top);
    return Rectangle(left, top, overlapx(other), overlapy(other));
  }

  Offset centerVec(Rectangle other) =>
      Offset(midx - other.midx, midy - other.midy);

  List<double> asTuple() => [left, top, width, height];

  @override
  String toString() => "Rect${asTuple()}";

  static bool hasOverlaps(List<Rectangle> rectangles) {
    for (var i = 0; i < rectangles.length; i++) {
      for (var j = i + 1; j < rectangles.length; j++) {
        if (rectangles[i].overlap(rectangles[j])) return true;
      }
    }
    return false;
  }

  static List<Rectangle> overlapRectangles(List<Rectangle> rectangles) {
    List<Rectangle> overlaps = [];
    for (var i = 0; i < rectangles.length; i++) {
      for (var j = i + 1; j < rectangles.length; j++) {
        if (rectangles[i].overlap(rectangles[j])) {
          overlaps.add(rectangles[i].overlapRect(rectangles[j]));
        }
      }
    }
    return overlaps;
  }

  static double totalMovement(List<Rectangle> rectangles) {
    double total = 0;
    for (var rectangle in rectangles) {
      total += rectangle.distanceFromOriginal;
    }
    return total;
  }

  static void toCsv(List<Rectangle> rectangles, String out) {
    List<List<double>> rows = [];
    for (var rectangle in rectangles) {
      rows.add(rectangle.asTuple());
    }
    String csvData = ListToCsvConverter().convert(rows);
    File(out).writeAsString(csvData);
  }

  static List<Rectangle> fromCsv(String csvfile) {
    List<Rectangle> rects = [];
    List<List<double>> rows = const CsvToListConverter().convert(
      File(csvfile).readAsStringSync(),
    );
    for (var row in rows) {
      rects.add(Rectangle(row[0], row[1], row[2], row[3]));
    }
    return rects;
  }
}
