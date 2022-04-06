class ComplexNumber {
  double real, imaginary;

  ComplexNumber(double r, double i) {
    this.real = r;
    this.imaginary = i;
  }

  ComplexNumber add(ComplexNumber other) {
    return new ComplexNumber(this.real + other.real, this.imaginary + other.imaginary);
  }

  ComplexNumber add(double real) {
    return new ComplexNumber(this.real + real, this.imaginary);
  }

  ComplexNumber sub(ComplexNumber other) {
    return new ComplexNumber(this.real - other.real, this.imaginary - other.imaginary);
  }

  ComplexNumber sub(double real) {
    return new ComplexNumber(this.real - real, this.imaginary);
  }

  ComplexNumber mult(ComplexNumber other) {
    return new ComplexNumber(this.real * other.real - this.imaginary * other.imaginary, this.real * other.imaginary + this.imaginary * other.real);
  }

  ComplexNumber mult(double real) {
    return new ComplexNumber(this.real * real, this.imaginary * real);
  }

  ComplexNumber div(ComplexNumber other) {
    ComplexNumber numerator = this.mult(other.conjugate());
    double divisor = other.mult(other.conjugate()).real;
    return numerator.div(divisor);
  }

  ComplexNumber div(double real) {
    return new ComplexNumber(this.real / real, this.imaginary / real);
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
