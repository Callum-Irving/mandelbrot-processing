int NUM_ITERATIONS = 50;
float scale = 100;
Point offset = new Point(0, 0);

void setup() {
  size(400, 400);
  // Center world 0,0
  offset = screenToWorld(offset.sub(new Point(width/2, height/2)));

  textSize(32);
  fill(255, 0, 0);
}

int time;
int elapsed;

void draw() {
  background(255);
  time = millis();

  drawMandelbrotThreaded();
  //drawMandelbrotSimple();

  elapsed = millis() - time;
  text(elapsed + " ms", 10, 30);
  text("n=" + NUM_ITERATIONS, 10, 62);
}

void drawMandelbrotSimple() {
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      Point w = screenToWorld(new Point(x, y));
      ComplexNumber c = new ComplexNumber(w.x, w.y);
      int n = inMandelbrot(c);
      pixels[y * width + x] = complexMandelbrotColor(n);
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
