
/*
KINECT HAND TRACKING

Based on:
KinectPV2, Kinect for Windows v2 library for processing
by: Thomas Sanchez Lengeling.
*/

import java.util.ArrayList;
import KinectPV2.KJoint;
import KinectPV2.*;

KinectPV2 kinect;

//draw a single joint
void drawJoint(KJoint[] joints, int jointType) {
  pushMatrix();
    translate(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
    ellipse(0, 0, 25, 25);
  popMatrix();
}

//draw a bone from two joints
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  pushMatrix();
    translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
    ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}

//draw a ellipse depending on the hand state
void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
    translate(joint.getX(), joint.getY(), joint.getZ());
    ellipse(0, 0, 70, 70);
  popMatrix();
}

/*
Different hand state
 KinectPV2.HandState_Open
 KinectPV2.HandState_Closed
 KinectPV2.HandState_Lasso
 KinectPV2.HandState_NotTracked
 */

//Depending on the hand state change the color
void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    //println("sound file 1");
    fill(0, 255, 0);
    break;
  case KinectPV2.HandState_Closed:
    //println("sound file 2");
    fill(255, 0, 0);
    break;
  case KinectPV2.HandState_Lasso:
    fill(0, 0, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(100, 100, 100);
    break;
  }
}
