float scale = 100;
PVector offset = new PVector(0, 0);

void setup() {
  ComplexNumber z = new ComplexNumber(3, 4);
  ComplexNumber w = new ComplexNumber(3, 2);

  float c = z.abs();
  println("z is", c, "units away from the origin");

  ComplexNumber sum = z.add(w);
  println("Sum is", sum);
  
  ComplexNumber d = new ComplexNumber(-2, 0);
  println(inMandelbrot(d));
  
  size(400, 400);
  // Center world 0,0
  offset = screenToWorld(PVector.sub(offset, new PVector(width/2, height/2)));
}

void draw() {
  background(255);
  stroke(0);
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      PVector w = screenToWorld(new PVector(x, y));
      ComplexNumber c = new ComplexNumber(w.x, w.y);
      if (inMandelbrot(c))
        point(x, y);
    }
  }
}

PVector screenToWorld(PVector pos) {
  return pos.div(scale).add(offset);
}

PVector worldToScreen(PVector pos) {
  return pos.sub(offset).mult(scale);
}

PVector mousePos() {
  return new PVector(mouseX, mouseY);
}

void mouseDragged() {
  if (mousePressed && mouseButton == LEFT) {
    offset.x -= (mouseX - pmouseX) / scale;
    offset.y -= (mouseY - pmouseY) / scale;
  }
}

void mouseWheel(MouseEvent e) {
  float amount = e.getCount();
  PVector prev = screenToWorld(mousePos());
  if (amount > 0) scale *= 1.2;
  else if (amount < 0) scale /= 1.2;
  PVector current = screenToWorld(mousePos());
  offset = offset.add(prev.sub(current));
}
