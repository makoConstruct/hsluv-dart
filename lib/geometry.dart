import 'dart:math' as math;

// converted from https://github.com/hsluv/hsluv

class Point {
  Point(this.x, this.y);

  double x;
  double y;
}

class Line {
  Line({required this.slope, required this.intercept});

  double slope;
  double intercept;
}

// All angles in radians
// https://github.com/dart-lang/sdk/issues/2626
// typedef Angle double;

class Geometry {
  static Point intersectLineLine(Line a, Line b) {
    var x = (a.intercept - b.intercept) / (b.slope - a.slope);
    var y = a.slope * x + a.intercept;
    return Point(x, y);
  }

  static double distanceFromOrigin(Point point) {
    return math.sqrt(math.pow(point.x, 2) + math.pow(point.y, 2));
  }

  static double distanceLineFromOrigin(Line line) {
    // https://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line
    return line.intercept.abs() / math.sqrt(math.pow(line.slope, 2) + 1);
  }

  static Line perpendicularThroughPoint(Line line, Point point) {
    var slope = -1 / line.slope;
    var intercept = point.y - slope * point.x;
    return Line(slope: slope, intercept: intercept);
  }

  static double angleFromOrigin(Point point) {
    return math.atan2(point.y, point.x);
  }

  static double normalizeAngle(double angle) {
    var m = 2 * math.pi;
    return ((angle % m) + m) % m;
  }

  static double lengthOfRayUntilIntersect(double theta, Line line) {
    /// theta  -- angle of ray starting at (0, 0)
    /// m, b   -- slope and intercept of line
    /// x1, y1 -- coordinates of intersection
    /// len    -- length of ray until it intersects with line
    ///
    /// b + m * x1        = y1
    /// len              >= 0
    /// len * cos(theta)  = x1
    /// len * sin(theta)  = y1
    ///
    ///
    /// b + m * (len * cos(theta)) = len * sin(theta)
    /// b = len * sin(hrad) - m * len * cos(theta)
    /// b = len * (sin(hrad) - m * cos(hrad))
    /// len = b / (sin(hrad) - m * cos(hrad))
    return line.intercept / (math.sin(theta) - line.slope * math.cos(theta));
  }
}
