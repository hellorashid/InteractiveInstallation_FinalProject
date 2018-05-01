Brush p;
Brush[] brushes = new Brush[50];

void setup() {
  size(1200,800);
  background(0);
  p = new Brush(width/2, height/2);

  for (int i = 0; i < brushes.length-1; i++) {
      Brush x = new Brush( random(0,width), random(0,height) );
      brushes[i] = x;
  }

}

void draw() {
  p.run();

  for (int i = 0; i < brushes.length-1; i++) {
      brushes[i].run();
  }

}


class Brush {

  float xPosition = 0;
  float yPosition = 0;

  float vel = 10;
  float accel = 0;

  float easing = 0.01;

  color c = color( random(50,200), random(50,200), random(50,200) );

  Brush(float x, float y) {
     xPosition = x;
     yPosition = y;
     vel = 3;
     accel = 1;
  }

  void run() {
    update();
    display();
    println(vel);
  }

  void update() {

    float targetX = mouseX;
    float dx = targetX - xPosition;
    xPosition += dx * easing;

    float targetY = mouseY;
    float dy = targetY - yPosition;
    yPosition += dy * easing;

    vel += accel;
    //xPosition += vel;
    //yPosition += vel;

  }

  void display() {
    noStroke();
    fill(c);
    ellipse(xPosition, yPosition, 5, 5);
  }

}
