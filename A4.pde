/*
COMP 3490 Assignment4_Q1

          Name: Han Wen           
Student number: 7879607

-What is the porpose of this program:
-A P3D/OpenGL program that will allow your walking robot 
from assignment 3 to move through a fully-3D 
texture-mapped and animated world.

*/
//***************************************************


// This program contains a "custom" OBJ file reader.
// If you are using it for assignment 4, please feel free to remove that code
// if you don't need it.

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;


void setup() {
  size(640, 640, P3D);
  frameRate(60);
  colorMode(RGB, 1.0f);
  
  cow = loadShape("cow.obj");
  frustum(-1.0f, 1.0f, 1.0f, -1.0f, 2.0f, 15.0f);

  Rotator head = new Rotator(new float[]{0,180,0}, new float[]{0,0,0}, new float[]{0,1,0}, 0, -30, 30, 1);
  Rotator rightShoulder = new Rotator(new float[]{0,90,0}, new float[]{0,0,0}, new float[]{1,0,0}, 30, -30, 30, 1);
  Rotator rightElbow = new Rotator(new float[]{0,-90,0}, new float[]{0,0.075f,0}, new float[]{1,0,0}, 30, -30, 30, 1);
  Rotator leftShoulder = new Rotator(new float[]{0,90,0}, new float[]{0,0,0}, new float[]{1,0,0}, -30, -30, 30, 1);
  Rotator leftElbow = new Rotator(new float[]{0,-90,0}, new float[]{0,0.075f,0}, new float[]{1,0,0}, -30, -30, 30, 1);
  Rotator rightThigh = new Rotator(new float[]{90,0,0}, new float[]{0,0.15f,0}, new float[]{1,0,0}, -30, -30, 30, 1);
  Rotator rightKnee = new Rotator(new float[]{-90,0,0}, new float[]{0,0.15f,0}, new float[]{1,0,0}, 0, 0, 45, 0.75f);
  Rotator leftThigh = new Rotator(new float[]{90,0,0}, new float[]{0,0.15f,0}, new float[]{1,0,0}, 30, -30, 30, 1);
  Rotator leftKnee = new Rotator(new float[]{-90,0,0}, new float[]{0,0.15f,0}, new float[]{1,0,0}, 45, 0, 45, 0.75f);
  rotators = new Rotator[] {
    head,
    rightShoulder,
    rightElbow,
    leftShoulder,
    leftElbow,
    rightThigh,
    rightKnee,
    leftThigh,
    leftKnee
  };
  robot = new Structure(
            new Shape[] {
              new Shape(new float[] {0.1f,0.15f,0.1f}, head),
              //new Shape("dodecahedron.obj", new float[] {0.2, 0.2, 0.2}, head),
              new Structure(new Shape[] {
                  new Shape(new float[] {0.06f, -0.125f, 0.06f}, rightElbow)},
                  new float[][] {{-0.058f, -0.15f, -0.001f}},
                  new float[] {0.125f, 0.075f, 0.075f}, rightShoulder),
              new Structure(new Shape[] {
                  new Shape(new float[] {0.06f, -0.125f, 0.06f}, leftElbow)},
                  new float[][] {{0.058f, -0.15f, -0.001f}},
                  new float[] {0.125f, 0.075f, 0.075f}, leftShoulder),
              new Structure(new Shape[] {
                  new Shape(new float[] {0.1f, 0.15f, 0.1f}, rightKnee)},
                  new float[][] {{0.0f, -0.3f, 0.0f}},
                  new float[] {0.1f, 0.15f, 0.1f}, rightThigh),
              new Structure(new Shape[] {
                  new Shape(new float[] {0.1f, 0.15f, 0.1f}, leftKnee)},
                  new float[][] {{0.0f, -0.3f, 0.0f}},
                  new float[] {0.1f, 0.15f, 0.1f}, leftThigh)
            }, new float[][] {
              {0, 0.4f, 0 },
              {-0.25f, 0.15f, 0},
              {0.25f, 0.15f, 0},
              {-0.15f, -0.3f, 0 },
              {0.15f, -0.3f, 0 }
            },
            new float[] {0.15f,0.25f,0.15f}, null);
            
            
  texture01 = loadImage("texture01.jpg");
  texture02 = loadImage("texture02.jpg");
  texture03 = loadImage("texture03.jpg");
  texture04 = loadImage("texture04.jpg");
  textureMode(NORMAL);
  textureWrap(REPEAT);

}

int projection = 0;
int cameraAngle = 0;
boolean viewChanged = true, jump = false, up = true, firstView = false, stop = false;
boolean stop1 = false, stop2 = false, stop3 = false, stop4 = false, right = true;
PImage texture01, texture02, texture03, texture04;

Structure robot;
Rotator[] rotators;
float floorZ = 0, floorX = 0, robotY = 0;
float t = 1, jumpHeight = -0.5, jumpSpeed = 0.02, floorDeltaZ = 0.01;
float viewX = 0, viewY = 0;
float origX = 0, origY = 0;
int lastKeyPress = 0;
final float SQSIZE = 0.5f;
float box1Z = -10, box2Z = -5, box3Z = -7, cowZ = -12;
PShape cow;
float cowX = -1.0, cowDeltaX = 0.01;

void draw() {
  background(0.05, 0.05, 0.1);
  fill(1, 0, 0);
  stroke(1, 1, 1);
  strokeWeight(5.5);
  resetMatrix();

//-------------------------this part keep the robot at the center of the scene-------------------
//|--------------------------------only moving part is the floor---------------------------------|
  jumpDeltaY();   //perform Jump calculation of floorY
  
  //----------   //below block is used to change view angle
  if(firstView){  //this block is used to change view
    camera(0.0f, 0.5f-robotY, -1.05f,  viewX, viewY-robotY, -5.0f,  0.0, 10, 0.0);
  }
  else{
    camera(0.0f, 2.0f, -0.8f,  0.0f, 0.0f, -3.5f,  0.0, 10, 0.0);
  }
  //---------- 
  
  pushMatrix();
 

  
    translate(0,  -robotY, -2.5f);
    scale(0.5);
    robot.draw();
    popMatrix();
  
  for (Rotator r: rotators) {  //make robot rotat
    r.update(1);
  }
//|-----------------------------------------------------------------------------------------------|

//-----------------------------this part is the moving floor----------------------------- 
  
  pushMatrix();
  
  if(stop1 || stop2 || stop3 || stop4){
    floorDeltaZ = 0;
  }
  else{
    floorDeltaZ = 0.01;
  }
  
  if(abs(floorZ - SQSIZE) <0.001){  //this if-else set make sure the floor only has limited length
    floorZ = 0;
  }
  else{
    floorZ += floorDeltaZ;  //this is the floor moving speed at Z axis
  }

  translate(floorX, -0.75f, floorZ);
  drawFloor();
  popMatrix();
  
//----------------------------this part is to draw obstables-------------------------------

//---------------------------------------------obstables1
  pushMatrix();  
  if(box1Z < 0){
  box1Z += 2*floorDeltaZ;
  translate(floorX, -0.74f, box1Z); 
  drawBox();
  if(box1Z > -3.5 && box1Z < -3 && floorX < 0.3 && floorX > -0.75 && !jump){
   stop1 = true; 
  }
  else{
    stop1 = false;
  }
  //println(floorX, box1Z, stop);
  }
  else{
    box1Z = -10;
  }
  popMatrix();
//---------------------------------------------obstables2
  pushMatrix();  
  if(box2Z < 0){
  box2Z += 2*floorDeltaZ;
  translate(floorX - 1.0, -0.74f, box2Z); 
  drawBox();
  if(box2Z > -3.5 && box2Z < -3 && floorX > 0.3 && floorX <= 1.05 && !jump){  //first box2Z is the Z value stops moving
   stop2 = true; 
  }
  else{
    stop2 = false;
  }
  //println(floorX, box2Z, stop);
  }
  else{
    box2Z = -5;
  }
  popMatrix();
//---------------------------------------------obstables3
  pushMatrix();  
if(box3Z < 0 && !stop){
  box3Z += 2*floorDeltaZ;

  pushMatrix();
    translate(floorX+1, -0.74f, box3Z); 
    drawBox();
  popMatrix();
  pushMatrix();
    translate(floorX+0.5, -0.74f, box3Z); 
    drawBox();
  popMatrix();
  pushMatrix();
    translate(floorX, -0.74f, box3Z); 
    drawBox();
  popMatrix();
  pushMatrix();
    translate(floorX - 0.5, -0.74f, box3Z); 
    drawBox();
  popMatrix();
  pushMatrix();
    translate(floorX - 1.0, -0.74f, box3Z); 
    drawBox();
  popMatrix();
  pushMatrix();
    translate(floorX - 1.5, -0.74f, box3Z); 
    drawBox();
  popMatrix();
  
  if(box3Z > -3.5 && box3Z < -3 && !jump){  //first box2Z is the Z value stops moving
   stop3 = true; 
  }
  //println(floorX, box2Z, stop);
  }
  
  else{
    box3Z = -7;
  }
  popMatrix();
//---------------------------------------------obstables4
  pushMatrix();
  if(cowZ < 0){
    cowZ += 2*floorDeltaZ;  //cow Z data
    
    if(cowX < 1.5 && right){  //cow X data, makes cow moving
      cowX += cowDeltaX;
    }
    else{
      cowX -= cowDeltaX;
      if(cowX < -1){
        right = true; 
      }
      else{
        right = false;
      }
    }
    
    
    translate(floorX + cowX, -0.74f, cowZ);    
    scale(0.001,0.001,0.001);
    if(!right){
      rotateY(PI); 
    }
    rotateX(-HALF_PI);
    shape(cow);
  if(cowZ > -3.5 && cowZ < -3 && abs(floorX + cowX) < 0.5 && !jump){  //same Z level of robot
      stop4 = true; 
  }
  else{
    stop4 = false;
  }
  //println(floorX, box2Z, stop);
  }
  else{
    cowZ = -12;
  }
   
  popMatrix();
}
