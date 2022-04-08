int inMandelbrot(ComplexNumber z) {
  ComplexNumber c = new ComplexNumber(z.real, z.imaginary);
  for (int i = 0; i < NUM_ITERATIONS; i++) {
    z = z.mult(z).add(c);
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
    double initX = xStart / scale + offset.x;
    double initY = yStart / scale + offset.y;
    for (int x = xStart; x < xEnd; x++) {
      for (int y = yStart; y < yEnd; y++) {
        ComplexNumber c = new ComplexNumber(x / scale + offset.x, y / scale + offset.y);
        int n = inMandelbrot(c);
        pixels[y * width + x] = precomputed[n];
      }
    }
  }
}
