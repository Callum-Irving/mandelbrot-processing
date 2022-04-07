import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.CountDownLatch;

int POOL_THREADS = 10;
color[] colors;

ExecutorService pool;
CountDownLatch latch;

void initPool() {
  colors = new color[width * height];
  pool = Executors.newFixedThreadPool(POOL_THREADS);
}

void drawMandelbrotPool() {
  latch = new CountDownLatch(POOL_THREADS);
  int sectionSize = width / POOL_THREADS;
  for (int i = 0; i < POOL_THREADS; i++) {
    int xs = i * sectionSize;
    int xe = (i + 1) * sectionSize;
    Runnable r = new PoolThread(xs, 0, xe, height);
    pool.execute(r);
  }

  // Wait for done
  try {
    latch.await();
  }
  catch (InterruptedException e) {
    e.printStackTrace();
  }

  loadPixels();

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      pixels[y * width + x] = colors[y * width + x];
    }
  }

  updatePixels();
}

class PoolThread implements Runnable {
  int xStart, yStart, xEnd, yEnd;

  PoolThread(int xs, int ys, int xe, int ye) {
    this.xStart = xs;
    this.yStart = ys;
    this.xEnd = xe;
    this.yEnd = ye;
  }

  void run() {
    for (int x = xStart; x < xEnd; x++) {
      for (int y = yStart; y < yEnd; y++) {
        Vec2 w = screenToWorld(new Vec2(x, y));
        ComplexNumber c = new ComplexNumber(w.x, w.y);
        int n = inMandelbrot(c);
        colors[y * width + x] = simpleMandelbrotColor(n);
      }
    }

    latch.countDown();
  }
}
