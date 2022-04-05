// This is like PVector but uses double instead of float
class Point {
  double x, y;

  Point(double x, double y) {
    this.x = x;
    this.y = y;
  }

  Point mul(double m) {
    return new Point(x * m, y * m);
  }

  Point div(double m) {
    return new Point(x / m, y / m);
  }

  Point add(Point o) {
    return new Point(this.x + o.x, this.y + o.y);
  }

  Point sub(Point o) {
    return new Point(this.x - o.x, this.y - o.y);
  }
}

Point screenToWorld(Point pos) {
  return pos.div(scale).add(offset);
}

Point worldToScreen(Point pos) {
  return pos.sub(offset).mul(scale);
}

Point mousePos() {
  return new Point(mouseX, mouseY);
}
