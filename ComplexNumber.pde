class ComplexNumber {
  float real;
  float imaginary;

  ComplexNumber(float r, float i) {
    this.real = r;
    this.imaginary = i;
  }

  ComplexNumber add(ComplexNumber other) {
    return new ComplexNumber(this.real + other.real, this.imaginary + other.imaginary);
  }

  ComplexNumber add(float n) {
    return new ComplexNumber(this.real + n, this.imaginary);
  }

  ComplexNumber sub(ComplexNumber other) {
    return new ComplexNumber(this.real - other.real, this.imaginary - other.imaginary);
  }

  ComplexNumber sub(float n) {
    return new ComplexNumber(this.real - n, this.imaginary);
  }

  ComplexNumber mul(ComplexNumber other) {
    return new ComplexNumber(this.real * other.real - this.imaginary * other.imaginary, this.real * other.imaginary + this.imaginary * other.real);
  }

  ComplexNumber mul(float n) {
    return new ComplexNumber(this.real * n, this.imaginary * n);
  }

  ComplexNumber div(ComplexNumber other) {
    ComplexNumber numerator = this.mul(other.conjugate());
    float divisor = other.mul(other.conjugate()).real;
    return numerator.div(divisor);
  }

  ComplexNumber div(float n) {
    return new ComplexNumber(this.real / n, this.imaginary / n);
  }

  ComplexNumber conjugate() {
    return new ComplexNumber(this.real, -this.imaginary);
  }

  float abs() {
    return sqrt(this.real * this.real + this.imaginary * this.imaginary);
  }

  String toString() {
    return this.real + (this.imaginary >= 0 ? " + " : " - ") + Math.abs(this.imaginary) + "i";
  }
}
