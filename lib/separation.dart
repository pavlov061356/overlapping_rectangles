import 'dart:math' hide Rectangle;

import 'package:overlapping_rectangles/rectangles.dart';

class Separation {
  List<Rectangle> rectangles;
  // Индексы несдвигаемых прямоугольников
  List<int> fixedPositions = [];

  Separation(this.rectangles, {this.fixedPositions = const []})
      : assert(fixedPositions.length <= rectangles.length);

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
      if (fixedPositions.contains(i)) continue;
      rectangles[i].left += vecs[i].dx;
      rectangles[i].top += vecs[i].dy;
    }
  }
}
