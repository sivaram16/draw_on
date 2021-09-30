import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

part 'select_area_widget.dart';

class DrawOnWidget extends StatefulWidget {
  /// Give the Correct answer coordinates to draw.
  final List<List<Offset>>? correctAnswerCoordinates;

  /// Widget that want to be appear
  final Widget? widget;

  /// Callback to get X - axis value
  final ValueChanged<double>? getXaxis;

  /// Callback to get Y - axis value
  final ValueChanged<double>? getYaxis;

  /// Callback for OnTap
  final Function()? onTap;

  /// Show pointer
  final bool? showPointer;

  /// Points Color
  final Color? pointsColor;

  /// Line Color
  final Color? lineColor;

  /// Line Stroke
  final double lineStroke;

  /// Point Stroke
  final double pointStroke;

  /// Draw on widget will let you to draw on the given widget and get the coordinates for it.
  DrawOnWidget({
    required this.correctAnswerCoordinates,
    required this.widget,
    required this.getXaxis,
    required this.getYaxis,
    this.showPointer = false,
    required this.onTap,
    required this.lineColor,
    required this.pointsColor,
    this.lineStroke = 4,
    this.pointStroke = 8,
  });
  @override
  _DrawOnWidgetState createState() => _DrawOnWidgetState();
}

class _DrawOnWidgetState extends State<DrawOnWidget> {
  /// Selected Position X
  double? selectedPositionX;

  /// Selected Position y
  double? selectedPositionY;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) => onSelected(details),
      onTap: widget.onTap,
      child: Stack(
        children: <Widget>[
          widget.widget!,
          if (selectedPositionX != null && widget.showPointer!)
            CustomPaint(
              painter: SelectionPoint(
                selectedPositionX!,
                selectedPositionY!,
                widget.pointsColor!,
                widget.pointStroke,
              ),
            ),
          CustomPaint(
            painter: AnswerRegion(
              widget.correctAnswerCoordinates!,
              widget.lineColor!,
              widget.lineStroke,
            ),
          )
        ],
      ),
    );
  }

  void onSelected(TapDownDetails details) {
    setState(() {
      selectedPositionX = details.localPosition.dx;
      selectedPositionY = details.localPosition.dy;
    });
    widget.getXaxis!(selectedPositionX!);
    widget.getYaxis!(selectedPositionY!);
  }
}

class SelectionPoint extends CustomPainter {
  /// Selection point of X
  double selectionPointXaxis;

  /// Selection point of Y
  double selectionPointYaxis;

  /// Point color
  final Color color;

  /// Point Stroke
  final double pointStroke;

  /// Class to define the selection point on the given widget
  SelectionPoint(
    this.selectionPointXaxis,
    this.selectionPointYaxis,
    this.color,
    this.pointStroke,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final pointMode = ui.PointMode.points;
    final points = [Offset(selectionPointXaxis, selectionPointYaxis)];
    final paint = Paint()
      ..color = color
      ..strokeWidth = pointStroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}

class AnswerRegion extends CustomPainter {
  /// Give the correct coordinates to draw
  List<List<Offset>> correctAnswerCoordinates;

  /// Color to draw
  final Color color;

  /// Line Stroke
  final double lineStroke;

  /// Class to define the Draw lines on the given widget with given coordinates.
  AnswerRegion(
    this.correctAnswerCoordinates,
    this.color,
    this.lineStroke,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final pointMode = ui.PointMode.polygon;

    for (final List<Offset> coordinates in correctAnswerCoordinates) {
      List<Offset> points = [];
      for (int i = 0; i < coordinates.length; i++) {
        points.add(Offset(coordinates[i].dx, coordinates[i].dy));
      }
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..color = color
        ..strokeWidth = lineStroke;
      canvas.drawPoints(pointMode, points, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

///* `NeedsAtLeastThreePoints` is thrown if `Polygon.points` contains less than 3 points
class NeedsAtLeastThreePoints implements Exception {
  int numberOfPoint;
  NeedsAtLeastThreePoints(this.numberOfPoint);
  String toString() =>
      "Please provide three or more points. Current number of Points: $numberOfPoint";
  int currentPointsInPolygon() => this.numberOfPoint;
}

/// A class for representing two-dimensional Polygon defined with `List<Point<num>> points`.
class Polygon {
  final List<Offset> points;
  String? name;

  ///Create a `Polygon` with vertices at `points`.
  /// Pass a `List<Point<num>>`
  Polygon(List<Offset> points) : points = points.toList(growable: false) {
    var numberOfPoint = this.points.length;
    if (numberOfPoint < 3) {
      throw NeedsAtLeastThreePoints(numberOfPoint);
    }
  }

  /// returns `true` if `(x,y)` is present inside `Polygon`
  bool contains(num px, num py) {
    num ax = 0;
    num ay = 0;
    num bx = points[points.length - 1].dx - px;
    num by = points[points.length - 1].dy - py;
    int depth = 0;

    for (int i = 0; i < points.length; i++) {
      ax = bx;
      ay = by;
      bx = points[i].dx - px;
      by = points[i].dy - py;

      if (ay < 0 && by < 0) continue; // both "up" or both "down"
      if (ay > 0 && by > 0) continue; // both "up" or both "down"
      if (ax < 0 && bx < 0) continue; // both points on left

      num lx = ax - ay * (bx - ax) / (by - ay);

      if (lx == 0) return true; // point on edge
      if (lx > 0) depth++;
    }

    return (depth & 1) == 1;
  }

  /// returns `true` if `Point` is present inside `Polygon`
  bool isPointInside(Offset i) {
    return contains(i.dx, i.dy);
  }

  /// Get the nearest point.
  static Offset? getNearestPoint(List<Offset> points, Offset latestPoints) {
    Offset? nearestPoints;
    double threshold = 30;
    double nearestDistance = 10000;
    for (final Offset point in points) {
      double x = point.dx - latestPoints.dx;
      double y = point.dy - latestPoints.dy;
      double distance = sqrt((x * x) + (y * y)).abs();
      if (distance < nearestDistance && distance <= threshold) {
        nearestPoints = point;
        nearestDistance = distance;
      }
    }
    if (nearestPoints != null) return nearestPoints;
    return null;
  }
}
