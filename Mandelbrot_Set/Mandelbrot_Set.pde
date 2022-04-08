int NUM_ITERATIONS = 50;
float scale = 100;
Vec2 offset = new Vec2(0, 0);
int drawMode = 2;
boolean drawUi = true;

void setup() {
  size(600, 600);

  // Center world 0,0
  offset = screenToWorld(offset.sub(new Vec2(width/2, height/2)));

  textSize(32);
  noFill();

  precomputeColors();
  initPool();
}


void draw() {
  background(255);

  // Start frame timer.
  int time = millis();

  // Calculate and show Mandelbrot Set.
  switch (drawMode) {
  case 1:
    drawMandelbrotSimple();
    break;
  case 2:
    drawMandelbrotPool();
    break;
  case 3:
    drawMandelbrotThreaded();
    break;
  }

  // Stop frame timer.
  int elapsed = millis() - time;

  if (drawUi) {
    // Draw x-axis and y-axis.
    Vec2 origin = worldToScreen(new Vec2(0, 0));
    line(0, (float)origin.y, width, (float)origin.y);
    line((float)origin.x, 0, (float)origin.x, height);

    // Draw circle with radius 2
    circle((float)origin.x, (float)origin.y, 4 * scale);

    // Show frame time and number of iterations.
    text(elapsed + " ms", 10, 30);
    text("n=" + NUM_ITERATIONS, 10, 62);

    // Show mouse coords
    Vec2 mousePos = screenToWorld(mousePos());
    text(nf((float)mousePos.x, 1, 4) + ", " + nf((float)mousePos.y, 1, 4), mouseX, mouseY);
  }
}

void drawMandelbrotSimple() {
  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      Vec2 w = screenToWorld(new Vec2(x, y));
      ComplexNumber c = new ComplexNumber(w.x, w.y);
      int n = inMandelbrot(c);
      pixels[y * width + x] = precomputed[n];
    }
  }
  updatePixels();
}

final int THREAD_COUNT = 8;
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
  if (key == CODED) {
    switch (keyCode) {
    case UP:
      NUM_ITERATIONS += 10;
      precomputeColors();
      break;
    case DOWN:
      NUM_ITERATIONS -= 10;
      NUM_ITERATIONS = max(10, NUM_ITERATIONS);
      precomputeColors();
      break;
    }
  } else {
    switch (key) {
    case '1':
      drawMode = 1;
      break;
    case '2':
      drawMode = 2;
      break;
    case '3':
      drawMode = 3;
      break;
    case ' ':
      drawUi = !drawUi;
      break;
    }
  }
}
