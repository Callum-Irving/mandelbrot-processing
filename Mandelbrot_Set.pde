void setup() {
  ComplexNumber a = new ComplexNumber(20, -4);
  ComplexNumber b = new ComplexNumber(3, 2);
  
  var c = a.div(b);
  
  println(c.format());
  
  noLoop();
  exit();
}

void draw() {
  
}
