int NUM_ITERATIONS = 50;
float scale = 100;
Point offset = new Point(0, 0);

void setup() {
  size(400, 400);
  // Center world 0,0
  offset = screenToWorld(offset.sub(new Point(width/2, height/2)));

  textSize(32);
  fill(0, 255, 0);
  stroke(0);
  strokeCap(PROJECT);
  colorMode(HSB);
}

int time;
int elapsed;

void draw() {
  background(255);

  time = millis();

  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      Point w = screenToWorld(new Point(x, y));
      ComplexNumber c = new ComplexNumber(w.x, w.y);
      pixels[y * width + x] = color(map(inMandelbrot(c), 0, NUM_ITERATIONS, 0, 255), 255, 255);
    }
    updatePixels();
  }

  elapsed = millis() - time;
  text(elapsed, 10, 30);
  text("n = " + NUM_ITERATIONS, 10, 52);
}

void mouseDragged() {
  if (mousePressed && mouseButton == LEFT) {
    offset.x -= (mouseX - pmouseX) / scale;
    offset.y -= (mouseY - pmouseY) / scale;
  }
}

void mouseWheel(MouseEvent e) {
  float amount = e.getCount();
  Point prev = screenToWorld(mousePos());
  if (amount > 0) scale *= 1.2;
  else if (amount < 0) scale /= 1.2;
  Point current = screenToWorld(mousePos());
  offset = offset.add(prev.sub(current));
}

void keyPressed() {
  switch (keyCode) {
  case UP:
    NUM_ITERATIONS += 10;
    break;
  case DOWN:
    NUM_ITERATIONS -= 10;
    break;
  }
}
