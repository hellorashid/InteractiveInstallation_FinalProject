
import processing.sound.*;
SoundFile file;


// ------- TWITTER ------------------ // 

import gohai.simpletweet.*;
SimpleTweet simpletweet;
boolean tweeted; 
boolean shouldTweet; 


// -------  KINECT (ONE - Depth Tracking) ------------------ // 
import org.openkinect.processing.*;
Kinect2 kinect2;
float minThresh = 800;
float maxThresh = 1200; 
PImage img; 


// -------  KINECT (TWO - HAND TRACKING) ------------------ // 
float handX; 
float handY;

float leftHandX; 
float leftHandY;


// -------  Custom Variables ------------------ // 
float xPosition = 0; 
float yPosition = 0; 

int particleSize = 32;
boolean inFrame; 
int particleCounter = 60; //Creates new particle every 2 seconds
PImage crosshair; 


// -------  Colors  ------------------ // 
color backgroundColor = color(#72B9FF); 
color foregroundColor = color(80,33,59);

void setup() {

  size(800, 600);
  //fullScreen();
  surface.setResizable(true);
  background(100);
  frameRate(120);
  textSize(15);
  inFrame = false;
  tweeted = false;
  frameRate(60);

// -------  KINECT (DEPTH) ------------------ // 

  //kinect2 = new Kinect2(this);
  //kinect2.initDepth();
  //kinect2.initDevice();
  //img = createImage(kinect2.depthWidth, kinect2.depthHeight,HSB);

  
// -------  KINECT (HAND) ------------------ // 

  kinect = new KinectPV2(this);

  //Enables depth and Body tracking (mask image)
  kinect.enableDepthMaskImg(true);
  kinect.enableSkeletonDepthMap(true);

  kinect.init();
  
 
  
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


// -------  TWITTER  ------------------ // 

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
  
  
  // -------  PARTICLES  ------------------ // 
  
  file = new SoundFile(this, "music.mp3");
  file.loop();

  initPtcs(30); 
  initSliders();

}

void draw(){
  
    onPressed = true;
  
  //background(255);
  //println(frameRate);
  //background(0, 0.01);
  //background(255); 



// KINECT (DEPTH) //
  //int[] depth = kinect2.getRawDepth();
  //img.loadPixels();
  //float sumX = 0;
  //float sumY = 0;
  //float totalPixels = 0;

  //  for (int x =0; x< kinect2.depthWidth; x++){
  //  for (int y =0; y<kinect2.depthHeight; y++){
  //    int offset = x + y * kinect2.depthWidth;
  //    int d = depth[offset];
     
  //    if (d > minThresh  && d < maxThresh && x > 0){
  //      //foreground image color
  //      img.pixels[offset] = foregroundColor;
  //      sumX += x;
  //      sumY += y;
  //      totalPixels ++;
  //      particleSize = d / 20;
  //    } else {
  //      //background color
  //      img.pixels[offset] = backgroundColor;
  //    }
  //  }
  //}
  //  img.updatePixels();
  //  //image(img,0,0, width, height);
  //  float avgX = sumX / totalPixels;
  //  float avgY = sumY /totalPixels;
  
    //  if (totalPixels > 20) { 
    //  inFrame = true;
    //} else { 
    //  inFrame = false; 
    //}
    
//  KINECT (HAND)

  //image(kinect.getDepthMaskImage(), 0, 0);
  
  //get the skeletons as an Arraylist of KSkeletons
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonDepthMap();

  //individual joints
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    //if the skeleton is being tracked compute the skleton joints
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();

      //color col  = skeleton.getIndexColor();
      //fill(col);
      //stroke(col);

      //drawBody(joints);
      //drawHandState(joints[KinectPV2.JointType_HandRight]);
      //drawHandState(joints[KinectPV2.JointType_HandLeft]);
      
      //handState(joints[KinectPV2.JointType_HandRight].getState());
      //println(joints[KinectPV2.JointType_HandRight].getX());
      handX = joints[KinectPV2.JointType_HandRight].getX(); 
      handY = joints[KinectPV2.JointType_HandRight].getY();       
      //inFrame = true;
      
      leftHandX = joints[KinectPV2.JointType_HandLeft].getX(); 
      leftHandY = joints[KinectPV2.JointType_HandLeft].getY();   
      
    } 
  }
  
  if ( 5 < handX && handX < 500) { 
    inFrame = true;
  } else { 
    inFrame = false;
  } 
   
  webColor = color(255, ((leftHandX / width) * 255), ((leftHandY / width) * 255)); 
  
//    fill(255);
//    ellipse(handX, handY, 50, 50); 
// Twitter & Position Tracking   


    if (inFrame == true) { 
     xPosition = (handX / 500) * width;
     yPosition = (handY / 400) * height; 
     tweeted = false;
    } else { 
      xPosition = width/2; 
      yPosition = height/2;
       if (tweeted == false && shouldTweet == true) { 
          String tweet = simpletweet.tweetImage(get(), "IDM SHOWCASE 2018");
          println("Posted " + tweet);
       } 
      tweeted = true;
      background(backgroundColor, 10); 
    } 
  
  
  
 // --------  Particles ----- // 
    
    gThres = lerp(gThres, gThresT, 0.001);
    //gBgAlpha = lerp(gBgAlpha, gBgAlphaT, .02);
    //gBgAlpha = 1; 
    gMag = sliderForce.value;
    
    //if (particleCounter > 0) { 
    //  initPtcs(1); 
    //  particleCounter = particleCounter - 1;
    //} else { 
    //  particleCounter = 60;
    //} 
      
   

    //noStroke();
    //fill(255, gBgAlpha);
    //rect(0, 0, width, height);
  
    updatePtcs();
    updateSliders();
  
    drawPtcs();
    drawCnts();
    //drawSliders();
  
    //for when user is not there 
    //if (totalPixels < 20) { 
    //  //saveFrame();
    //  takePic(); 
    //}; 
    file.amp(handY/height * -1);
    println(handX/width);
    //println(webColor);
    
    
     
 } /// END DRAW 

 
boolean pictureTaken = false; 
 void takePic() { 
   
   if (pictureTaken == false) { 
   saveFrame(); 
     pictureTaken = true; 
   } 
   
  
   
 };  
 
