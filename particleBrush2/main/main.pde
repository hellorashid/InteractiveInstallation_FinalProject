
import org.openkinect.processing.*;



// TWITTTERRR

import gohai.simpletweet.*;
SimpleTweet simpletweet;
boolean tweeted; 
boolean shouldTweet; 

//Colors

color backgroundColor = color(#72B9FF); 
color foregroundColor = color(80,33,59);


// Kinect Shit
Kinect2 kinect2;
float minThresh = 800;
float maxThresh = 1200; 
PImage img; 


// Custom Variables
float xPosition = 0; 
float yPosition = 0; 

int particleSize = 32;
boolean inFrame; 

PImage crosshair; 


void setup() {
  frameRate = 60;
  fullScreen();
  //size(800, 600);
  kinect2 = new Kinect2(this);
  
  
  kinect2.initDepth();
  kinect2.initDevice();
  img = createImage(kinect2.depthWidth, kinect2.depthHeight,HSB);

  
  background(222);
  frameRate(60);
  textSize(15);
  inFrame = false;
  tweeted = false;
  
  initPtcs(60);
  initSliders();
  
  
 //crosshair = createGraphics(width, height); 
 //crosshair = loadImage("crosshair.png"); 
 // crosshair.beginDraw(); 
 //   //background(255, 0); 
 //   pushMatrix(); 
 //   fill(255, 0, 88);
 //   noStroke();
 //   ellipse(0, 0, 30, 30); 
 //   popMatrix(); 
 // crosshair.endDraw(); 


// TWIITTER 

  simpletweet = new SimpleTweet(this);
  shouldTweet = true;
  /*
   * Create a new Twitter app on https://apps.twitter.com/
   * then go to the tab "Keys and Access Tokens"
   * copy the consumer key and secret and fill the values in below
   * click the button to generate the access tokens for your account
   * copy and paste those values as well below
   */
  simpletweet.setOAuthConsumerKey("qpAc2YnhQlX1KMrDZqWERDrQC");
  simpletweet.setOAuthConsumerSecret("erm7RNrJsJcrGgJxCBgmU5E7AwQlstNHfnSpceL6gqHyanl7ts");
  simpletweet.setOAuthAccessToken("992478298323279872-JPCoLqs89NT9Pu1YV2OVinacmEyMF34");
  simpletweet.setOAuthAccessTokenSecret("0nrvpROB43evlkEsmvVEvrkvnmUjcilUQvc4NcLSrBbEN");
  
}

void draw(){
  
  
  //println(frameRate);
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
    
    if (totalPixels > 20) { 
      inFrame = true;
    } else { 
      inFrame = false; 
    } 
      
    
    img.updatePixels();
    //image(img,0,0, width, height);
    float avgX = sumX / totalPixels;
    float avgY = sumY /totalPixels;
 
    if (inFrame == true) { 
     xPosition = (avgX / 500) * width;
     yPosition = (avgY / 400) * height; 
     tweeted = false;
    } else { 
      xPosition = width/2; 
      yPosition = height/2;
       if (tweeted == false && shouldTweet == true) { 
          String tweet = simpletweet.tweetImage(get(), "IDM SHOWCASE 2018");
          println("Posted " + tweet);
       } 
      tweeted = true;
      background(backgroundColor, 200); 
    } 

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
  

    //for when user is not there 
    if (totalPixels < 20) { 
      //saveFrame();
      takePic(); 
    }; 
    println(inFrame);
    
 }
 
boolean pictureTaken = false; 
 void takePic() { 
   
   if (pictureTaken == false) { 
   saveFrame(); 
     pictureTaken = true; 
   } 
   
 };  
 