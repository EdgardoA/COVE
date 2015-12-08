import saito.objloader.*;

import java.util.*;
import java.io.*;
import java.lang.*;
import processing.dxf.*;
import processing.pdf.*;

import controlP5.*;

ControlP5 cp5;

Button SAVE, KEY;

PShape m;
PShape o;
int zoomFactor = 0;
int displacement = 0;

Boolean first = false;

float rotXval, rotYval;

float xVal = 0;
float yVal = 0;

PImage keylay;

void setup()
{
  
  cp5 = new ControlP5(this);
  
  keylay = loadImage("KeyLayout.png");
    
  //Save Frame
  SAVE = cp5.addButton("SAVE")
    .setCaptionLabel("CAPTURE STILL")
    .setPosition(700,25)
    .setSize(75,20)
    ;
    
  //Key Button - For loading image of keyboard
  KEY = cp5.addButton("KEY")
    .setPosition(0,0)
    .setSize(425,281)
    .setImages(keylay, keylay, keylay)
    ;
  
  size(800,800,P3D);
  
  m = loadShape("rocket.obj"); //Modified - Right
  o = loadShape("teapot.obj"); //Original - Left
  
}
  
public void ZOOM_IN(){
  zoomFactor+=5;
  //println("zoomFactor: " + zoomFactor);
}

public void ZOOM_OUT(){
  zoomFactor-=5;
  //println("zoomFactor: " + zoomFactor);
}

public void ROTATECW(){
  rotYval = radians(yVal) * PI;
  //println("rotYval: " + rotYval);
  yVal = yVal + 1;

}

public void ROTATECCW(){
  rotYval = radians(yVal) * PI;
  //println("rotYval: " + rotYval);
  yVal = yVal - 1;
  
}

public void ROTATEB(){
  rotXval = radians(xVal) * PI;
  println("rotXval: " + rotXval + ", " + "xVal: " + xVal);
  xVal = xVal + 1;
}

public void ROTATEF(){
  rotXval = radians(xVal) * PI;
  println("rotXval: " + rotXval + ", " + "xVal: " + xVal);
  xVal = xVal - 1;
}

public void MOVELEFT(){
 displacement-=10; 
}

public void MOVERIGHT(){
 displacement+=10; 
}

public void SAVE(){
  textSize(32);
  fill(0, 102, 255);
  text("Modified", 20, 20);
  
  o.setVisible(false); //Show Modified
  
  xVal=0;
  yVal=0;
  
  xVal=90;
  rotXval = radians(xVal) * PI;
  
  //redraw();
  
  saveFrame("view1.png");
  
  //redraw();
  
  xVal=-90;
  rotXval = radians(xVal) * PI;
  
  //redraw();
  saveFrame("view2.png");
  //redraw();
  
  yVal=90;
  rotYval = radians(yVal) * PI;
  
  //redraw();
  saveFrame("view3.png");
  //redraw();
  
  yVal=-90;
  rotYval = radians(yVal) * PI;
  
  //redraw();
  saveFrame("view4.png");
  //redraw();
  
  zoomFactor=-200;
  
  //redraw();
  saveFrame("view5.png");
  //redraw();
  
  zoomFactor=50;
  
  //redraw();
  saveFrame("view6.png");
  //redraw();
}

void draw(){
  
  background(255); //White Background
   lights();
 
  //Loading Modified
  pushMatrix();
  
    //Lighting Modifying Functions
    directionalLight(102, 102, 126, 0, 0, 1);
    ambientLight(102, 102, 102);
    lightSpecular(156, 255, 204);
   
    //Center Right for Modified
    translate(width/2 + 150 + displacement, height/2, zoomFactor); 
   
    rotateX(rotXval);
    rotateY(rotYval);

    //Keyboard Functionality
    if(keyPressed == true) {
      switch(key){
        case 49:   // 1 - Save Image
          SAVE();
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
        case 120: //x - Right
          MOVERIGHT();
          break;
        case 122: //z - Left
          MOVELEFT();
          break;
      }
    }
    
    shape(m);
 
  popMatrix();
  
  
  //Loading Original
  pushMatrix();
    
    //Center Left for Original
    translate(width/2 - 150 + displacement, height/2, zoomFactor); 
   
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
    
    shape(o);
    
  popMatrix();
  
}