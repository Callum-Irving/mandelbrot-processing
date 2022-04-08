color black = color(0);
color white = color(255);
color[] precomputed;

void precomputeColors() {
  precomputed = new color[NUM_ITERATIONS + 1];
  for (int i = 0; i < NUM_ITERATIONS + 1; i++) {
    precomputed[i] = simpleMandelbrotColor(i);
  }
}

color binaryMandelbrotColor(int n) {
  if (n == NUM_ITERATIONS) return black;
  else return white;
}

color greyscaleMandelbrotColor(int n) {
  return color(map(n, NUM_ITERATIONS, 0, 0, 255));
}

color blueMandelbrotColor(int n) {
  colorMode(HSB);
  if (n == NUM_ITERATIONS) return color(0);
  float sat = map(n, NUM_ITERATIONS, 0, 0, 255);
  return color(150, sat, 255);
}

color simpleMandelbrotColor(int n) {
  colorMode(HSB);
  if (n == NUM_ITERATIONS) return color(0);
  return color(map(n, 0, NUM_ITERATIONS, 0, 255), 255, 255);
}

color complexMandelbrotColor(int n) {
  colorMode(RGB);
  float a = 0.1;
  float r = 0.5 * sin(a * n) + 0.5;
  float g = 0.5 * sin(a * n + 2.094) + 0.5;
  float b = 0.5 * sin(a * n + 4.188) + 0.5;
  return color(r * 255, g * 255, b * 255);
}
