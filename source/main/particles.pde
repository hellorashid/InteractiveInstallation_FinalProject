// PARTICLE BRUSH


// Based on:
// Particle system by: Raven Kwok,  ravenkwok.com
//Posted on OpenProcessing.org, Jul.9, 2011,Jul.12, 2016.


// Initialize particle array & gravity values
Ptc [] ptcs;
float gMag = 0, gVelMax = 6, gThres, gThresT, gBgAlpha = 255, gBgAlphaT = 255;
float time;

// colors for center webs
color webColor = color(255, 0, 0);

//Initialize multiple particles
void initPtcs(int amt) {
  ptcs = new Ptc[amt];
  for (int i=0; i<ptcs.length; i++) {
    ptcs[i] = new Ptc();
  }
}

// Updates particles to new position based on X & Y position
void updatePtcs() {
  if (onPressed) {
    for (int i=0; i<ptcs.length; i++) {
      // X & Y POSITION INSTEAD OF MOUSE POSTIONS:
      ptcs[i].update(xPosition, yPosition);
    }
  } else {
    for (int i=0; i<ptcs.length; i++) {
      ptcs[i].update();
    }
  }
}

// Draws all particles in Particles Array
void drawPtcs() {
  for (int i=0; i<ptcs.length; i++) {
    ptcs[i].drawPtc();
  }
}

// Draws Center lines
void drawCnts() {
  for (int i=0; i<ptcs.length; i++) {
    for (int j=i+1; j<ptcs.length; j++) {
      //calculate distance between two consecutive particles in array
      float d = dist(ptcs[i].pos.x, ptcs[i].pos.y, ptcs[j].pos.x, ptcs[j].pos.y);
      if (d<gThres) {
        // draws center line if distance is less than threshhold
        float scalar = map(d, 0, gThres, 1, 0);
        ptcs[i].drawCnt(ptcs[j], scalar);
      }
    }
  }
}


class Ptc {  // Particle class

  PVector pos, pPos, vel, acc;
  float decay, weight, magScalar;

  Ptc() {
    // inialize particle, with Position, Velocity, & Acceleration
    pos = new PVector(random(width), random(height));
    pPos = new PVector(pos.x, pos.y); //position vector
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);

    // Sets random weight
    weight = random(2,5);
    decay = map(weight, 1, 5, .95, .85);
    magScalar = map(weight, 1, 10, .5, .05);
  }

  void update(float tgtX, float tgtY) {
    onPressed = true;
    pPos.set(pos.x, pos.y);
    acc.set(tgtX-pos.x, tgtY-pos.y);

    //Use normalize() instead in Java mode
    float accMag = sqrt(sq(acc.x)+sq(acc.y));
    acc.mult(1.0/accMag);
    //------------------------------
    acc.mult(gMag * magScalar);
    vel.add(acc);
    //Use limit() instead in Java mode
    float velMag = sqrt(sq(vel.x)+sq(vel.y));
    if(velMag>gVelMax) vel.mult(gVelMax/velMag);
    //------------------------------
    pos.add(vel);
    acc.set(0, 0, 0);
    boundaryCheck();
  }

  void update() {
    onPressed = true;
    pPos.set(pos.x, pos.y);
    // updates velocity & position
    vel.add(acc);
    vel.mult(decay);
    pos.add(vel);

    acc.set(0, 0);
    boundaryCheck();
  }

  void drawPtc() {
    //strokeWeight(weight);
    time =( millis()/1000);
     strokeWeight(1);
    //color for lines

   // stroke(0xff000000 | int(random(0xffffff)));
    stroke(#008080,255);
    // change stroke based on time
    //if (time > 10){
    //  stroke(255);
    //}

    // draws particle
    if(onPressed)line(pos.x, pos.y, pPos.x, pPos.y);
    else point(pos.x, pos.y);
  }

  // draws center line,
  void drawCnt(Ptc coPtc, float scalar) {
    strokeWeight((weight+coPtc.weight)*.1*scalar); // calculate stroke weight
    //strokeWeight(random(0.0001,0.1)); // random stroke weight
    stroke(webColor,random(10,200)); // uses WebColor, with random Opacity
    line(pos.x, pos.y, coPtc.pos.x, coPtc.pos.y); // Draw line
  }

// Checks if particle position is outside screen boundry
  void boundaryCheck() {
    if (pos.x > width) {
      pos.x = width;
      vel.x *= -1; // reverse X velocity
    } else if (pos.x < 0) {
      pos.x = 0;
      vel.x *= -1;
    }
    if (pos.y > height) {
      vel.y *= -1;  // reverse Y velocity
    } else if (pos.y < 0) {
      vel.y *= -1;
    }
  }
}

boolean onPressed;
void mousePressed(){ // mouse press for testing, simulates presence
  onPressed = true;
  gThresT = 0;
  gBgAlphaT = 255;
  inFrame = true;
}
