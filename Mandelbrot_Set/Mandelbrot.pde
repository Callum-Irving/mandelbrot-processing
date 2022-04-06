float inMandelbrot(ComplexNumber z) {
  ComplexNumber c = new ComplexNumber(z.real, z.imaginary);
  for (int i = 0; i < NUM_ITERATIONS; i++) {
    z = z.mul(z).add(c);
    if (z.real * z.real + z.imaginary * z.imaginary > 4) return i;
  }
  return NUM_ITERATIONS;
}
