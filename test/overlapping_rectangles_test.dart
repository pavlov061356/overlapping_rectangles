import 'dart:math';

import 'package:overlapping_rectangles/rectangles.dart';
import 'package:overlapping_rectangles/separation.dart';
import 'package:test/test.dart';

void main() {
  group('Rectangle tests', () {
    test('dimensions', () {
      Rectangle r = Rectangle(10, 20, 30, 50);
      expect(r.right, 40);
      expect(r.bottom, 70);
      expect(r.area, 1500);
      expect(r.midx, 25);
      expect(r.midy, 45);
    });

    test('moveX', () {
      Rectangle r = Rectangle(10, 20, 30, 50);
      r.left = 5;
      expect(r.originalLeft, 10);
      expect(r.left, 5);
      expect(r.deltax, 5);
      expect(r.distanceFromOriginal, 5);
    });

    test('moveY', () {
      Rectangle r = Rectangle(10, 20, 30, 50);
      r.top = 5;
      expect(r.originalTop, 20);
      expect(r.top, 5);
      expect(r.deltay, 15);
      expect(r.distanceFromOriginal, 15);
    });

    test('moveXY', () {
      Rectangle r = Rectangle(10, 20, 30, 50);
      r.top = 16;
      r.left = 7;
      expect(r.deltay, 4);
      expect(r.deltax, 3);
      expect(r.distanceFromOriginal, 5);
    });

    test('basic overlap', () {
      Rectangle r1 = Rectangle(0, 0, 10, 10);
      Rectangle r2 = Rectangle(5, 5, 10, 10);
      expect(r1.overlap(r2), true);
      expect(r1.overlapx(r2), 5);
      expect(r1.overlapy(r2), 5);
      expect(r1.overlapRect(r2).area, 25);
    });

    test('cross overlap', () {
      Rectangle r1 = Rectangle(0, 5, 10, 1);
      Rectangle r2 = Rectangle(5, 0, 1, 10);
      expect(r1.overlap(r2), true);
      expect(r1.overlapx(r2), 1);
      expect(r1.overlapy(r2), 1);
      expect(r1.overlapRect(r2).area, 1);
    });

    test('contained overlap', () {
      Rectangle r1 = Rectangle(0, 0, 10, 10);
      Rectangle r2 = Rectangle(5, 5, 2, 2);
      expect(r1.overlap(r2), true);
      expect(r1.overlapx(r2), 2);
      expect(r1.overlapy(r2), 2);
      expect(r1.overlapRect(r2).area, 4);
    });

    test('contained overlap in Separation', () {
      Rectangle r1 = Rectangle(0, 0, 10, 10, isFixed: true);
      Rectangle r2 = Rectangle(5, 5, 2, 2, isFixed: true);
      expect(r1.overlap(r2), true);

      try {
        Separation _ = Separation([r1, r2]);
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });

    test('border not overlap', () {
      Rectangle r1 = Rectangle(0, 0, 10, 10);
      Rectangle r2 = Rectangle(10, 0, 10, 10);
      expect(r1.overlap(r2), false);
    });

    test('rotate', () {
      Rectangle r1 = Rectangle(0, 0, 1, 1);
      r1.left = 5;
      expect(r1.originalTop, 0);
      expect(r1.originalLeft, 0);
      expect(r1.deltax, -5);
      r1.rotate(pi / 2);
      expect(r1.left, closeTo(0, 0.001));
      expect(r1.top, closeTo(-5, 0.001));
    });
  });
}
