import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class visualizer extends PApplet {

/*
 * Visualizer
 */

/*
import processing.pdf.*;  // Import PDF code

void setup() {
  size(600, 600);
  background(255);
}

void draw() {
  stroke(0, 20);
  strokeWeight(20);
  line(mouseX, 0, width-mouseY, height);
}

void keyPressed() {
  if (key == 'B' || key == 'b') {         // When 'B' or 'b' is pressed,
    beginRecord(PDF, "lines.pdf");        // start recording to the PDF 
    background(255);                      // Set a white background
  } else if (key == 'E' || key == 'e') {  // When 'E' or 'e' is pressed,
    endRecord();                          // stop recording the PDF and
    exit();                               // quit the program
  }
}
*/

float x,y,z;

public void setup() {

background(0);
lights();
}

public void draw() {


pushMatrix();
translate(130, height/2, 0);
rotateY(1.25f);
rotateX(-0.4f);
noStroke();
box(100);
popMatrix();

pushMatrix();
translate(500, height*0.35f, -200);
noFill();
stroke(255);
sphere(280);
popMatrix();

}

  public void settings() { 
size(640,360,P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "visualizer" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
