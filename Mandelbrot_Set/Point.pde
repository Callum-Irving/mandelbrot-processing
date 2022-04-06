// This is like PVector but uses double instead of float
class Vec2 {
  double x, y;

  Vec2(double x, double y) {
    this.x = x;
    this.y = y;
  }

  Vec2 mul(double m) {
    return new Vec2(x * m, y * m);
  }

  Vec2 div(double m) {
    return new Vec2(x / m, y / m);
  }

  Vec2 add(Vec2 o) {
    return new Vec2(this.x + o.x, this.y + o.y);
  }

  Vec2 sub(Vec2 o) {
    return new Vec2(this.x - o.x, this.y - o.y);
  }
}

Vec2 screenToWorld(Vec2 pos) {
  return pos.div(scale).add(offset);
}

Vec2 worldToScreen(Vec2 pos) {
  return pos.sub(offset).mul(scale);
}

Vec2 mousePos() {
  return new Vec2(mouseX, mouseY);
}
