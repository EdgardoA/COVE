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

void setup() {
size(640,360,P3D);
background(0);
lights();
}

void draw() {


pushMatrix();
translate(130, height/2, 0);
rotateY(1.25);
rotateX(-0.4);
noStroke();
box(100);
popMatrix();

pushMatrix();
translate(500, height*0.35, -200);
noFill();
stroke(255);
sphere(280);
popMatrix();

}
