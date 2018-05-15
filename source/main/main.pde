
import processing.sound.*;
SoundFile file;


// ------- TWITTER ------------------ //
// SimpleTweet Library for posting images to Twitter
import gohai.simpletweet.*;
SimpleTweet simpletweet;
boolean tweeted;
boolean shouldTweet; // turns on/off tweeting functionality


// -------  KINECT (ONE - Depth Tracking) ------------------ //
// Uses OpenKinkect, for MacOS only
// Uses depth tracking (mix & max Threshold)
import org.openkinect.processing.*;
Kinect2 kinect2;
float minThresh = 800;
float maxThresh = 1200;
PImage img;


// -------  KINECT (TWO - HAND TRACKING) ------------------ //

float handX;  // X & Y positions of right & left hands
float handY;
float leftHandX;
float leftHandY;


// -------  Custom Variables ------------------ //
float xPosition = 0;   // final X & y position of brush
float yPosition = 0;

int particleSize = 32;
boolean inFrame;  // detects if person is within frame
int particleCounter = 60; //Creates new particle every 2 seconds
PImage crosshair;


// -------  Colors  ------------------ //
color backgroundColor = color(#72B9FF);
color foregroundColor = color(80,33,59);

void setup() {

  size(800, 600);
  //fullScreen();
  surface.setResizable(true); // Makes reziable screen
  background(100);
  frameRate(120);
  textSize(15);

  inFrame = false;
  tweeted = false;

// -------  KINECT (DEPTH) ------------------ //
  // Initialize kinect for Depth tracking
  //kinect2 = new Kinect2(this);
  //kinect2.initDepth();
  //kinect2.initDevice();
  //img = createImage(kinect2.depthWidth, kinect2.depthHeight,HSB);


// -------  KINECT (HAND) ------------------ //
  // Initialize Kinect for hand tracking
  kinect = new KinectPV2(this);

  //Enables depth and Body tracking (mask image)
  kinect.enableDepthMaskImg(true);
  kinect.enableSkeletonDepthMap(true);

  kinect.init();


// -------  CROSSHAIR ------------------ //
// Cross hair shows real time feedback of hand location

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
//using SimpleTweet library

  simpletweet = new SimpleTweet(this);
  shouldTweet = false;  //turns on/off twitter functionality

// TOKENS:
  simpletweet.setOAuthConsumerKey("qpAc2YnhQlX1KMrDZqWERDrQC");
  simpletweet.setOAuthConsumerSecret("erm7RNrJsJcrGgJxCBgmU5E7AwQlstNHfnSpceL6gqHyanl7ts");
  simpletweet.setOAuthAccessToken("992478298323279872-JPCoLqs89NT9Pu1YV2OVinacmEyMF34");
  simpletweet.setOAuthAccessTokenSecret("0nrvpROB43evlkEsmvVEvrkvnmUjcilUQvc4NcLSrBbEN");


  // -------  PARTICLES  ------------------ //

  // loads & plays music sound file
  file = new SoundFile(this, "music.mp3");
  file.loop();

// intialize particles
  initPtcs(30);



}

void draw(){

  onPressed = true;
  //background(255);
  //println(frameRate);
  //background(0, 0.01);

// -------  KINECT (DEPTH) ------------------ //
  //int[] depth = kinect2.getRawDepth(); // Gets depth of all pixels
  //img.loadPixels();
  //float sumX = 0;
  //float sumY = 0;
  //float totalPixels = 0;  //total number of pixels

  //  for (int x =0; x< kinect2.depthWidth; x++){
  //  for (int y =0; y<kinect2.depthHeight; y++){
  //    int offset = x + y * kinect2.depthWidth;
  //    int d = depth[offset];

  // // if within depth Threshold
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
  //  //image(img,0,0, width, height);  // Display Depth Image
  //  float avgX = sumX / totalPixels;
  //  float avgY = sumY /totalPixels;

  // // Detects & Updates inFrame pixels based on pixel count
    //  if (totalPixels > 20) {
    //  inFrame = true;
    //} else {
    //  inFrame = false;
    //}

// -------  KINECT (DEPTH) ------------------ //

  //image(kinect.getDepthMaskImage(), 0, 0); //display depth image

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

      // Store X & Y coordinates of left & right hands
      handX = joints[KinectPV2.JointType_HandRight].getX();
      handY = joints[KinectPV2.JointType_HandRight].getY();

      leftHandX = joints[KinectPV2.JointType_HandLeft].getX();
      leftHandY = joints[KinectPV2.JointType_HandLeft].getY();

    }
  }

// Tracks if person is in frame, based on X coordinates of hand
  if ( 5 < handX && handX < 500) {
    inFrame = true;
  } else {
    inFrame = false;
  }

// Sets the colors of web based on position of left hand
webColor = color(255, ((leftHandX / width) * 255), ((leftHandY / width) * 255));

//    fill(255);
//    ellipse(handX, handY, 50, 50);  // Draw circle at hand position

// Twitter & Position Tracking
    if (inFrame == true) {
     xPosition = (handX / 500) * width;  //Map hand coordinates to screen
     yPosition = (handY / 400) * height;
     tweeted = false;
    } else {
      xPosition = width/2;  // default positio to center if no one in frame
      yPosition = height/2;
       if (tweeted == false && shouldTweet == true) {
         // Tweets image to account
          String tweet = simpletweet.tweetImage(get(), "My CANVAS:");
          println("Posted " + tweet);
       }
      tweeted = true; // tweeted flag to prevent duplicate tweets
      background(backgroundColor, 10);  // stops drawing when no one in frame
    }



 // --------  Particles ----- //

    gThres = lerp(gThres, gThresT, 0.001);
    //gBgAlpha = lerp(gBgAlpha, gBgAlphaT, .02);
    //gBgAlpha = 1;
    gMag = 1;

    // Adds new particles
    //if (particleCounter > 0) {
    //  initPtcs(1);
    //  particleCounter = particleCounter - 1;
    //} else {
    //  particleCounter = 60;
    //}

    updatePtcs();


    drawPtcs();
    drawCnts();


    // Saves image to local dir instead of tweeting
    //if (totalPixels < 20) {
      //  takePic();
    //};

    // Changes music volume & left/right panning based on hand height
    file.amp( 1 - handY/height );
    //file.pan(1 - handX/height);


    //println(handX/width);
    //println(webColor);

 } /// END DRAW


boolean pictureTaken = false;
 void takePic() {
   if (pictureTaken == false) {
   saveFrame();
   pictureTaken = true;
}


 };
