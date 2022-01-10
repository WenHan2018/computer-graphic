void drawUnitCube() {
  float[][] verts = {
      { -1, -1, -1 },  // llr
      { -1, -1, 1 },  // llf
      { -1, 1, -1 },  // lur
      { -1, 1, 1 },  // luf
      { 1, -1, -1 },  // rlr
      { 1, -1, 1 },  // rlf
      { 1, 1, -1 },  // rur
      { 1, 1, 1 }     // ruf
  };
  
  int[][] faces = {
      { 1, 5, 7, 3 }, // front
      { 4, 0, 2, 6 }, // rear
      { 3, 7, 6, 2 }, // top
      { 0, 4, 5, 1 }, // bottom
      { 0, 1, 3, 2 }, // left
      { 5, 4, 6, 7 }, // right
  };
  
  beginShape(QUADS);
  for (int[] face: faces) {
    for (int i: face) {
      vertex(verts[i][0], verts[i][1], verts[i][2]);
    }
  }
  endShape();
}

void drawFloor() {
  boolean textureChangeZ = true, textureChangeX = true;
  for (float x = -1.5; x < 1.5; x+=SQSIZE) {
    textureChangeZ = textureChangeX;
    for (float z = floorZ; z > -floorZ-20 ; z-=SQSIZE) {

      beginShape(QUADS);
      if (textureChangeZ) {
        texture(texture01);
      } else {
        texture(texture02);
      }
      
      vertex(x, 0, z, 0, 0);
      vertex(x+SQSIZE, 0, z, 1, 0);
      vertex(x+SQSIZE, 0, z+SQSIZE, 1, 1);
      vertex(x, 0, z+SQSIZE, 0, 1);
      endShape();
      textureChangeZ = !textureChangeZ;
    }
    textureChangeX = !textureChangeX;
  }
}

//if the robot needs to jump, edit robotY value to achieve this
void jumpDeltaY() {
  if(jump){  
     if(robotY > jumpHeight && up){  
      robotY -= jumpSpeed;
    }
    else{
      up = false;
      robotY += jumpSpeed;
    }
    
    if(robotY > 0){
      jump = false;
      up = true;
      robotY = 0;
    }  
  }
}

void drawBox(){
    stroke(0);
  strokeWeight(1);

  beginShape(QUADS);
  texture(texture04);
  vertex(0, 0, 0);
  vertex(SQSIZE, 0, 0);
  vertex(SQSIZE, 0, SQSIZE);
  vertex(0, 0, SQSIZE);
  
  vertex(0, 0, 0, 0, 1);
  vertex(0, SQSIZE, 0, 0, 0);
  vertex(0, SQSIZE, SQSIZE, 1, 0);
  vertex(0, 0, SQSIZE, 1,1);
  
  vertex(0, 0, 0);
  vertex(SQSIZE, 0, 0);
  vertex(SQSIZE, SQSIZE, 0);
  vertex(0, SQSIZE, 0);   
  
  vertex(SQSIZE, 0, 0, 1, 1);
  vertex(SQSIZE, SQSIZE, 0, 1, 0);
  vertex(SQSIZE, SQSIZE, SQSIZE, 0, 0);
  vertex(SQSIZE, 0, SQSIZE, 0, 1);
  
  vertex(0, 0, SQSIZE, 0, 1);
  vertex(SQSIZE, 0, SQSIZE, 1, 1);
  vertex(SQSIZE,SQSIZE,SQSIZE, 1, 0);
  vertex(0, SQSIZE, SQSIZE, 0, 0);
  endShape();
  
  beginShape(QUADS);
  texture(texture03);
  vertex(0, SQSIZE, SQSIZE, 0, 1);
  vertex(SQSIZE,SQSIZE,SQSIZE, 1, 1);
  vertex(SQSIZE,SQSIZE,0, 1, 0);
  vertex(0,SQSIZE,0, 0, 0);
  endShape();
}

void keyPressed() {
    if(key == 'd'){
      floorX -= 0.15;
    }
    if(key == 'a'){
      floorX += 0.15;
    }
    if(key == ' '){
      jump = true;
      stop = false;
      stop3 = false;
    }
    lastKeyPress = millis();
  
  if(key == 10){
   firstView = !firstView; 
  }

}

void mousePressed(){
  origX = mouseX;
  origY = mouseY;
}

void mouseReleased(){
  viewX = 0;
  viewY = 0;
}

void mouseDragged(){
  float deltaX, deltaY;
  
  deltaX = mouseX - origX;
  deltaY = mouseY - origY;
  
  if(abs(deltaX) > 320){
    viewX = deltaX / abs(deltaX);
  }
  else{
    viewX = deltaX / 320;
  }
  
  if(abs(deltaY) > 320){
    viewY = -deltaY / abs(deltaY);
  }
  else{
    viewY = -deltaY / 320;
  }
  
}
