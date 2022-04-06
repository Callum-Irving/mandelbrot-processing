int inMandelbrot(ComplexNumber z) {
  ComplexNumber c = new ComplexNumber(z.real, z.imaginary);
  for (int i = 0; i < NUM_ITERATIONS; i++) {
    z = z.mul(z).add(c);
    if (z.real * z.real + z.imaginary * z.imaginary > 4) return i;
  }
  return NUM_ITERATIONS;
}

class MandelbrotThread implements Runnable {
  int xStart, yStart, xEnd, yEnd;
  
  MandelbrotThread(int xs, int ys, int xe, int ye) {
    this.xStart = xs;
    this.yStart = ys;
    this.xEnd = xe;
    this.yEnd = ye;
  }
  
  void run() {
    for (int x = xStart; x < xEnd; x++) {
      for (int y = yStart; y < yEnd; y++) {
        Point w = screenToWorld(new Point(x, y));
        ComplexNumber c = new ComplexNumber(w.x, w.y);
        int n = inMandelbrot(c);
        // More complicated and cooler way but I don't understand it.
        float a = 0.1;
        float r = 0.5 * sin(a * n) + 0.5;
        float g = 0.5 * sin(a * n + 2.094) + 0.5;
        float b = 0.5 * sin(a * n + 4.188) + 0.5;
        pixels[y * width + x] = color(r * 255, g * 255, b * 255);
      }
    }
  }
}
