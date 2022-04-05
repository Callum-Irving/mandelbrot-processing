float scale = 100;
PVector offset = new PVector(0, 0);

void setup() {
  size(400, 400);
  // Center world 0,0
  offset = screenToWorld(PVector.sub(offset, new PVector(width/2, height/2)));

  textSize(32);
  fill(0, 255, 0);
  stroke(0);
  strokeCap(PROJECT);
}

int time;
int elapsed;

void draw() {
  background(255);

  time = millis();

  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      PVector w = screenToWorld(new PVector(x, y));
      ComplexNumber c = new ComplexNumber(w.x, w.y);
      if (inMandelbrot(c))
        pixels[y * width + x] = color(0, 0, 0);
    }
    updatePixels();
  }

  elapsed = millis() - time;
  text(elapsed, 10, 30);
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
