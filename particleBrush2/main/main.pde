
import org.openkinect.processing.*;

PImage crosshair; 


//Colors

color backgroundColor = color(14,7,33); 
color foregroundColor = color(80,33,59);


// Kinect Shit
Kinect2 kinect2;
float minThresh = 480;
float maxThresh = 830; 
PImage img; 

float xPosition = 0; 
float yPosition = 0; 

int particleSize = 32;

void setup() {
  frameRate = 60;
  fullScreen();

  kinect2 = new Kinect2(this);
  
  
  
  
  kinect2.initDepth();
  kinect2.initDevice();
  img = createImage(kinect2.depthWidth, kinect2.depthHeight,HSB);

  
  background(255);
  frameRate(60);

  textSize(15);
  
  initPtcs(60);
  initSliders();
  
  
 //crosshair = createGraphics(width, height); 
  crosshair = loadImage("crosshair.png"); 
 // crosshair.beginDraw(); 
 //   //background(255, 0); 
 //   pushMatrix(); 
 //   fill(255, 0, 88);
 //   noStroke();
 //   ellipse(0, 0, 30, 30); 
 //   popMatrix(); 
 // crosshair.endDraw(); 

  
}

void draw(){
  
  
  println(frameRate);
  //background(#7F0037);
   //background(255); 
  onPressed = true;

  int[] depth = kinect2.getRawDepth();
  img.loadPixels();
  float sumX = 0;
  float sumY = 0;
  float totalPixels = 0;


  
  
  for (int x =0; x< kinect2.depthWidth; x++){
    for (int y =0; y<kinect2.depthHeight; y++){
      int offset = x + y * kinect2.depthWidth;
      int d = depth[offset];
     
      if (d > minThresh  && d < maxThresh && x > 0){
        //foreground image color
        img.pixels[offset] = foregroundColor;
        sumX += x;
        sumY += y;
        totalPixels ++;
        
        particleSize = d / 20;
        
    } else {
      //background color
      img.pixels[offset] = backgroundColor;
    }
  }
}
      
    
    img.updatePixels();
    //image(img,0,0, width, height);
    float avgX = sumX / totalPixels;
    float avgY = sumY /totalPixels;
 
    
      xPosition = (avgX / 500) * width;
      yPosition = (avgY / 400) * height; 
 
    
    
  
    
  
 
   
   
  gThres = lerp(gThres, gThresT, 0.001);
  //gBgAlpha = lerp(gBgAlpha, gBgAlphaT, .02);
  //gBgAlpha = 1; 
  gMag = sliderForce.value;
  
  updatePtcs();
  updateSliders();

  //noStroke();
  //fill(255, gBgAlpha);
  //rect(0, 0, width, height);

  drawPtcs();
  drawCnts();
  //drawSliders();
  
 
 
 //   if (totalPixels > 500) { 
 //     pushMatrix(); 
 //       image(crosshair, xPosition, yPosition); 
 //      popMatrix(); 

 //   }; 
    
    
    //for when user is not their 
    if (totalPixels < 500) { 
      
      //saveFrame();
      takePic(); 
     
    }; 
    text(avgY, 500,500);
    
 }
 
boolean pictureTaken = false; 
 void takePic() { 
   if (pictureTaken == false) { 
   saveFrame(); 
     pictureTaken = true; 
   } 
   
 };  
 