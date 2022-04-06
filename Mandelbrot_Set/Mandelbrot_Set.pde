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
  //colorMode(HSB);
}

int time;
int elapsed;

void draw() {
  background(255);
  time = millis();

  drawMandelbrotThreaded();

  elapsed = millis() - time;
  text(elapsed, 10, 30);
  text("n = " + NUM_ITERATIONS, 10, 52);
}

void drawMandelbrotSimple() {
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      Point w = screenToWorld(new Point(x, y));
      ComplexNumber c = new ComplexNumber(w.x, w.y);

      int n = inMandelbrot(c);

      // More complicated and cooler way but I don't understand it.
      float a = 0.1;
      float r = 0.5 * sin(a * n) + 0.5;
      float g = 0.5 * sin(a * n + 2.094) + 0.5;
      float b = 0.5 * sin(a * n + 4.188) + 0.5;
      pixels[y * width + x] = color(r * 255, g * 255, b * 255);

      // Simple but lame way. Uses HSB colours.
      //pixels[y * width + x] = color(map(inMandelbrot(c), 0, NUM_ITERATIONS, 0, 255), 255, 255);
    }
  }
  updatePixels();
}

final int THREAD_COUNT = 4;
void drawMandelbrotThreaded() {
  loadPixels();

  Thread[] threads = new Thread[THREAD_COUNT];
  int sectionSize = width / THREAD_COUNT;
  for (int i = 0; i < THREAD_COUNT; i ++) {
    threads[i] = new Thread(new MandelbrotThread(i * sectionSize, 0, (i + 1) * sectionSize, height));
    threads[i].start();
  }

  for (int i = 0; i < THREAD_COUNT; i++) {
    try {
      threads[i].join();
    } 
    catch (InterruptedException e) {
      e.printStackTrace();
    }
  }

  updatePixels();
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
    NUM_ITERATIONS = max(10, NUM_ITERATIONS);
    break;
  }
}
