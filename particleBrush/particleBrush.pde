Brush p;
Brush[] brushes = new Brush[50]; //an empty brush array

//the "Crosshair" is a white ellipse the follows the mouse, but does not draw
// anything else on the canvas
PGraphics crosshair; 

void setup() {
  size(1200,800);
  background(0);
  
  //adds brush particles to the array
  for (int i = 0; i < brushes.length-1; i++) {
      Brush x = new Brush( random(0,width), random(0,height) );
      brushes[i] = x;
  }
  
  

  crosshair = createGraphics(width, height);   //creates a graphic
  //creates initial Crosshair image - white ellipse at mouse position
  crosshair.beginDraw(); 
    //crosshair.background(0);  
    fill(255);
    noStroke();
    crosshair.ellipse(mouseX, mouseY, 50, 50); 
  crosshair.endDraw();

}

void draw() {
  
  //clear();


  crosshair.beginDraw();   //re-draws ellipse at mouse position
    crosshair.background(0,50);  // <--ISSUE: Drawing background also erases brush strokes
    fill(255);
    crosshair.ellipse(mouseX, mouseY, 50, 50); 
  crosshair.endDraw();
  
  image(crosshair, 0, 0);  // Display crosshair image
  
  
  
  // Draw & update brush particles
  for (int i = 0; i < brushes.length-1; i++) {
    brushes[i].run();
  }
  
  
}

void mousePressed() { 
  println("MousePressed");
  crosshair.beginDraw();
    crosshair.background(0,255);  
  crosshair.endDraw();
} 

void keyPressed() { 
  println("Keypressed");

} 

class Brush { //Brush Class

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
