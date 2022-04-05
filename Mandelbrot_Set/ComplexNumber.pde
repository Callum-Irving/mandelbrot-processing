class ComplexNumber {
  double real;
  double imaginary;

  ComplexNumber(double r, double i) {
    this.real = r;
    this.imaginary = i;
  }

  ComplexNumber add(ComplexNumber other) {
    return new ComplexNumber(this.real + other.real, this.imaginary + other.imaginary);
  }

  ComplexNumber add(double n) {
    return new ComplexNumber(this.real + n, this.imaginary);
  }

  ComplexNumber sub(ComplexNumber other) {
    return new ComplexNumber(this.real - other.real, this.imaginary - other.imaginary);
  }

  ComplexNumber sub(double n) {
    return new ComplexNumber(this.real - n, this.imaginary);
  }

  ComplexNumber mul(ComplexNumber other) {
    return new ComplexNumber(this.real * other.real - this.imaginary * other.imaginary, this.real * other.imaginary + this.imaginary * other.real);
  }

  ComplexNumber mul(double n) {
    return new ComplexNumber(this.real * n, this.imaginary * n);
  }

  ComplexNumber div(ComplexNumber other) {
    ComplexNumber numerator = this.mul(other.conjugate());
    double divisor = other.mul(other.conjugate()).real;
    return numerator.div(divisor);
  }

  ComplexNumber div(double n) {
    return new ComplexNumber(this.real / n, this.imaginary / n);
  }

  ComplexNumber conjugate() {
    return new ComplexNumber(this.real, -this.imaginary);
  }

  double abs() {
    return Math.sqrt(this.real * this.real + this.imaginary * this.imaginary);
  }

  String toString() {
    return this.real + (this.imaginary >= 0 ? " + " : " - ") + Math.abs(this.imaginary) + "i";
  }
}
