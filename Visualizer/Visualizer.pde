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

PShape s;
PShape o;
int zoomFactor = 0;

Boolean first = false;

float rotXval, rotYval;

float xVal = 0;
float yVal = 0;

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
    
  // Rotate CW - Clockwise - Towards Right
  ROTATECW = cp5.addButton("ROTATECW")
    .setCaptionLabel("Rotate Clockwise")
    .setPosition(25,50)
    .setSize(125,20)
    ;
    
  // Rotate CCW - CounterClockwise - Towards Left
  ROTATECCW = cp5.addButton("ROTATECCW")
    .setCaptionLabel("Rotate Counter Clockwise")
    .setPosition(175,50)
    .setSize(125,20)
    ;
  
  //Rotate Forward - Towards Users View
  ROTATEF = cp5.addButton("ROTATEF")
    .setCaptionLabel("Rotate Forward")
    .setPosition(25,75)
    .setSize(100,20)
    ;
    
  //Rotate Backwards - Away Users View
  ROTATEB = cp5.addButton("ROTATEB")
    .setCaptionLabel("Rotate Backwards")
    .setPosition(150,75)
    .setSize(100,20)
    ;
    
  //Save Frame
  SAVE = cp5.addButton("SAVE")
    .setPosition(500,25)
    .setSize(75,20)
    ;
    
  helpLabel = cp5.addTextlabel("Label");
  
  size(800,800,P3D);
  
  s = loadShape("teapot.obj");
  o = loadShape("teapot.obj");
  
}
  
public void ZOOM_IN(){
  zoomFactor+=5;
  println("zoomFactor: " + zoomFactor);
}

public void ZOOM_OUT(){
  zoomFactor-=5;
  println("zoomFactor: " + zoomFactor);
}

public void ROTATECW(){
  rotYval = radians(yVal) * PI;
  println("rotYval: " + rotYval);
  yVal = yVal + 1;

}

public void ROTATECCW(){
  rotYval = radians(yVal) * PI;
  println("rotYval: " + rotYval);
  yVal = yVal - 1;
  
}

public void ROTATEB(){
  rotXval = radians(xVal) * PI;
  println("rotXval: " + rotXval);
  xVal = xVal + 1;
}

public void ROTATEF(){
  rotXval = radians(xVal) * PI;
  println("rotXval: " + rotXval);
  xVal = xVal - 1;
  
}

public void SAVE(){
  saveFrame("test-####.png");
}

void draw(){
  lights();
  background(0); //Black Background
  
  //Mesh Grid
  pushMatrix();
  
    //Translation functions to make a the 3D perspective of the grid
    translate(0,300,-800);
    //rotateY(PI/2);
    rotateX(radians(59));
    
    //Empty Square with white border
    fill(0);
    stroke(255);
    
    /*
    //6x6 mesh grid
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
 
  //Loading Modified
  pushMatrix();
  
    //Lighting Modifying Functions
    directionalLight(51, 102, 126, 0, 0, 1);
    ambientLight(102, 102, 102);
    lightSpecular(204, 204, 204);
   
    //Center
    translate(width/2 + 150, height/2, zoomFactor); 
   
    rotateX(rotXval);
    rotateY(rotYval);

    //Keyboard Functionality
    if(keyPressed == true) {
      switch(key){
        case 49:   // 1 - Save Image
          saveFrame("test-####.png");
          break;
        case 119:  // w - Rotate UP - X Axis
          ROTATEB();
          break; 
        case 115:  // s - Rotate DOWN - X Axis
          ROTATEF();
          break;
        case 97:  // a - Rotate LEFT - Y Axis
          ROTATECCW();
          break;
        case 100:  // d - Rotate RIGHT - X Axis
          ROTATECW();
          break;
        case 113: //q - Zoom Out
          ZOOM_OUT();
          break;
        case 101: //e - Zoom In
          ZOOM_IN();
          break;
      }
    }
    
    shape(s);
 
  popMatrix();
  
  
  //Loading Original
  pushMatrix();
  
   translate(width/2 - 150, height/2, zoomFactor); 
   
    rotXval = PI/3 + mouseY/float(height) * PI;
    rotateX(rotXval);
    println("RotateX Value: " + rotXval);
    rotYval = PI/3 + mouseX/float(height) * PI;
    rotateY(rotYval);
    println("RotateY Value: " + rotYval);
    
    shape(o);
    
  popMatrix();
  
}