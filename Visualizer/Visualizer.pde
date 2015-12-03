import java.util.*;
import java.io.*;
import java.lang.*;
import processing.dxf.*;
import processing.pdf.*;

import controlP5.*;

ControlP5 cp5;

Button ZOOMIN, ZOOMOUT, SAVE, ROTATECW, ROTATECCW, ROTATEF, ROTATEB;
Toggle objectToggle;
Textlabel helpLabel;

boolean toggleValue = false;

String obj_file;
PShape s;
int zoomFactor = 0;

void setup()
{
  
  cp5 = new ControlP5(this);
  
  //Control Object
  objectToggle = cp5.addToggle("Control Object")
     .setPosition(25,25)
     .setSize(75,20)
     .hide();
     ;
     
  //Zoom In Object
  ZOOMIN = cp5.addButton("ZOOM_IN")
    .setCaptionLabel("Zoom In")
    .setPosition(25,25)
    .setSize(75,20)
    ;
    
  //Zoom Out Object
  ZOOMOUT = cp5.addButton("ZOOM_OUT")
  .setCaptionLabel("Zoom Out")
    .setPosition(100,25)
    .setSize(75,20)
    ;
    
  
    
  //Save Frame
  SAVE = cp5.addButton("SAVE")
    .setPosition(200,25)
    .setSize(75,20)
    ;
    
  helpLabel = cp5.addTextlabel("Label");
  
  size(800,800,P3D);
  
  s = loadShape("teapot.obj");
  
}
  
public void ZOOM_IN(){
  zoomFactor+=20;
  redraw();
  println("zoomFactor: " + zoomFactor);
}

public void ZOOM_OUT(){
  zoomFactor-=20;
  redraw();
  println("zoomFactor: " + zoomFactor);
}

public void SAVE(){
  saveFrame("test-####.png");
}

void draw(){
  lights();
  background(0); //Black Background
  
  //Mesh Grid Floow
  pushMatrix();
    translate(0,300,-800);
    //rotateY(PI/2);
    rotateX(radians(59));
    
    fill(0);
    stroke(255);
    /*
    rect(100,100,100,100);
    rect(200,100,100,100);
    rect(300,100,100,100);
    rect(400,100,100,100);
    rect(500,100,100,100);
    rect(600,100,100,100);
    
    
        rect(100,200,100,100);
    rect(200,200,100,100);
    rect(300,200,100,100);
    rect(400,200,100,100);
    rect(500,200,100,100);
    rect(600,200,100,100);
    
        rect(100,300,100,100);
    rect(200,300,100,100);
    rect(300,300,100,100);
    rect(400,300,100,100);
    rect(500,300,100,100);
    rect(600,300,100,100);
    
    
        rect(100,400,100,100);
    rect(200,400,100,100);
    rect(300,400,100,100);
    rect(400,400,100,100);
    rect(500,400,100,100);
    rect(600,400,100,100);
        rect(100,500,100,100);
    rect(200,500,100,100);
    rect(300,500,100,100);
    rect(400,500,100,100);
    rect(500,500,100,100);
    rect(600,500,100,100);
        rect(100,600,100,100);
    rect(200,600,100,100);
    rect(300,600,100,100);
    rect(400,600,100,100);
    rect(500,600,100,100);
    rect(600,600,100,100);
    */
    
    
    
  popMatrix();
    

    
  pushMatrix();
  
  directionalLight(51, 102, 126, 0, 0, 1);
  ambientLight(102, 102, 102);
  lightSpecular(204, 204, 204);
 
  
  float cameraY = height/2.0;
  float fov = mouseX/float(width) * PI/2;
  //println("FOV: " + fov);
  float cameraZ = cameraY / tan(fov / 2.0);
  float aspect = float(width)/float(height);
  
  if (fov >= 0.3 && fov <= 1.5) {
    //perspective(fov, aspect, cameraZ/10.0, cameraZ*10.0);
  }
  

  
  translate(width/2, height/2, zoomFactor); //Center
  
  rotateX(PI/3 + mouseY/float(height) * PI);
  rotateY(PI/3 + mouseX/float(height) * PI);
  
  shape(s);
  
  //translate(width/2, mouseY, 0);
 
  popMatrix();
  
    pushMatrix();
    rotateY(PI/3 + mouseX/float(height) * PI);
    popMatrix();

   
 
}

// Hit 'c' to record a single frame
void keyPressed() {
  switch(key) {
    case 49  :  break; // 1 - Rotate Object
    case 50  :  break; // 2 - 
    
    
  }
  
  
  
  
  if (key == 'c') {
    saveFrame("test-####.png");
  } else if (key == 'p') {
    //println("Pressed P key for print");
  }
  
}