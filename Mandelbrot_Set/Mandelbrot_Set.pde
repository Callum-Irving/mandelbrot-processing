int NUM_ITERATIONS = 50;
float scale = 100;
Vec2 offset = new Vec2(0, 0);

void setup() {
  size(600, 600);

  // Center world 0,0
  offset = screenToWorld(offset.sub(new Vec2(width/2, height/2)));

  textSize(32);
  noFill();
}

void draw() {
  background(255);

  // Start frame timer.
  int time = millis();

  // Calculate and show Mandelbrot Set.
  drawMandelbrotThreaded();

  // Stop frame timer.
  int elapsed = millis() - time;

  // Draw x-axis and y-axis.
  Vec2 origin = worldToScreen(new Vec2(0, 0));
  line(0, (float)origin.y, width, (float)origin.y);
  line((float)origin.x, 0, (float)origin.x, height);

  // Draw circle with radius 2
  circle((float)origin.x, (float)origin.y, 4 * scale);

  // Show frame time and number of iterations.
  text(elapsed + " ms", 10, 30);
  text("n=" + NUM_ITERATIONS, 10, 62);
}

void drawMandelbrotSimple() {
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      Vec2 w = screenToWorld(new Vec2(x, y));
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
  Vec2 prev = screenToWorld(mousePos());
  if (amount > 0) scale *= 1.2;
  else if (amount < 0) scale /= 1.2;
  Vec2 current = screenToWorld(mousePos());
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
