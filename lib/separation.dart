import 'dart:math' hide Rectangle;

import 'package:overlapping_rectangles/rectangles.dart';

class Separation {
  List<Rectangle> rectangles;

  Separation(this.rectangles) {
    var fixedPositions =
        rectangles.where((r) => r.isFixed).map((r) => r).toList();

    bool intersect = false;

    for (int i = 0; i < fixedPositions.length; i++) {
      for (int j = i + 1; j < fixedPositions.length; j++) {
        if (rectangles[i].overlap(rectangles[j])) {
          intersect = true;
        }
      }
    }

    assert(!intersect, "Fixed rectangles must not overlap");
  }

  Offset translateVector(int idx) {
    Rectangle rect = rectangles[idx];
    List<Offset> overlapVectors = [];

    for (int i = 0; i < rectangles.length; i++) {
      if (i != idx && rect.overlap(rectangles[i])) {
        overlapVectors.add(rect.centerVec(rectangles[i]));
      }
    }

    if (overlapVectors.isEmpty) {
      return Offset(0, 0);
    } else {
      double sumX = 0;
      double sumY = 0;
      for (var vector in overlapVectors) {
        sumX += vector.dx;
        sumY += vector.dy;
      }
      return Offset(sumX, sumY);
    }
  }

  Offset normalize(Offset pair) {
    double mag = sqrt(pair.dx * pair.dx + pair.dy * pair.dy);
    if (mag == 0) {
      return pair;
    } else {
      return Offset(pair.dx / mag, pair.dy / mag);
    }
  }

  void step() {
    List<Offset> vecs = [];
    for (int i = 0; i < rectangles.length; i++) {
      vecs.add(normalize(translateVector(i)));
    }
    for (int i = 0; i < rectangles.length; i++) {
      if (rectangles[i].isFixed) continue;
      rectangles[i].left += vecs[i].dx;
      rectangles[i].top += vecs[i].dy;
    }
  }
}
