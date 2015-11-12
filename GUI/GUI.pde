/*
**  GUI Testing with controlP5
*/
 
import controlP5.*;
import java.util.*;

ControlP5 cp5;
Button OBJ, EVAL, LABEL, MKLABEL;
Textlabel objLabel, evalLabel, labelLabel;
ScrollableList functionsList, selectedList;
Textfield newLabel ;


int myColor = color(255);

float n,n1;

String objfile, evalfile, labelfile;

Boolean first = false;

String functions[];

void setup() {
  size(300,300);
  noStroke();
  surface.setResizable(true);
  cp5 = new ControlP5(this);
  
  //OBJ Button
  OBJ = cp5.addButton("OBJ")
     .setCaptionLabel("Load OBJ File")
     .setPosition(25,50)
     .setSize(100,20)
     .hide()
     ;
  
  //OBJ Label
  objLabel = cp5.addTextlabel("objLbl")
    .setText("No Object Loaded")
    .setPosition(150,55)
    .setColorValue(000000)
    .hide()
    ;
  
  //EVAL Button
  EVAL = cp5.addButton("EVAL")
    .setCaptionLabel("Load Eval file")
    .setPosition(25,75)
    .setSize(100,20)
    .hide()
    ;
  
  //EVAL Label
  evalLabel = cp5.addTextlabel("evalLbl")
    .setText("No Eval Loaded")
    .setPosition(150,80)
    .setColorValue(000000)
    .hide()
    ;
    
  //LABEL Button
  LABEL = cp5.addButton("LABEL")
    .setCaptionLabel("Load Label file")
    .setPosition(25,100)
    .setSize(100,20)
    .hide()
    ;
    
  //Label Label
  labelLabel = cp5.addTextlabel("labelLbl")
    .setText("No Label Loaded")
    .setPosition(150,105)
    .setColorValue(000000)
    .hide()
    ;
    
  //MAKE LABEL Button
  MKLABEL = cp5.addButton("MKLABEL")
    .setCaptionLabel("Create Labels")
    .setPosition(25,125)
    .setSize(100,20)
    .hide()
    ;
  
  //New Button
  cp5.addButton("New")
     .setPosition(25,25)
     .setSize(100,20)
     ;

  //Modify Button
  cp5.addButton("Modify")
     .setPosition(150,25)
     .setSize(100,20)
     ;
     
   //Function List
   functionsList = cp5.addScrollableList("functionsFunc")
     .setCaptionLabel("Available Functions...")
     .setPosition(25,200)
     .setSize(100,100)
     .setBarHeight(20)
     .setItemHeight(20)
     .setType(ControlP5.CHECKBOX) //To select multiple entries
     .hide();
     ;
     
   //New Label Textbod
   newLabel = cp5.addTextfield("newLabel")
     .setPosition(200,200)
     .setSize(100,20)
     .hide()
     ;
     
   //Selected functions for labels
   selectedList = cp5.addScrollableList("selectList")
     .setCaptionLabel("Enter Label Name")
     .setPosition(150,230)
     .setSize(200,100)
     .setBarHeight(20)
     .setItemHeight(20)
     .setType(ControlP5.LIST)
     .hide()
     ;
}

void draw() {
  background(myColor);
  
  if (functionsList.isOpen() == false) {
    functionsList.open();
  }
}

public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
}

//Show the buttons for making a new rendering - OBJ file, Eval File.
public void New(int theValue) {
  println("Unlocking OBJ button");
  OBJ.show();
  objLabel.show();
 
  //MKLABEL.show();

  surface.setSize(300,300);
}

//Opens dialog to load .obj file
public void OBJ(int theValue) {
  println("Prompting user for obj file location");
  if (first) ;
  else selectInput("Select an obj file to load:", "objSelected");
  EVAL.show();
  evalLabel.show();
}

//Opens dialog to load .eval file
public void EVAL(int theValue) {
  println("Prompting user for obj file location");
  if (first) ;
  else selectInput("Select an eval file to load:", "evalSelected");
  LABEL.show();
  labelLabel.show(); 
}

//Opens dialog to load .ld file
public void LABEL(int theValue) {
  println("Prompting user for label file location");
  if (first) ;
  else selectInput("Select a label file to load:", "labelSelected");
}

//Creates Label Maker
public void MKLABEL(int theValue) {
 println("Loads up Label Maker GUI");
 
 functionsList.show();
 newLabel.show();
 selectedList.show();
 surface.setSize(500,600);
}

//Show the buttons for modifying an objl file to make corrections before visualization
public void Modify(int theValue) {
  println("a button event from colorC: "+theValue);
  
}

void functionsFunc (int n) {
  
}

//Load function - OBj file
void objSelected(File obj) {
  if (obj == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + obj.getAbsolutePath());
    objfile = obj.getName();
    objLabel.show().setText(objfile + "...loaded");
    println("Obj file: " + objfile);
  }
}

//Load Function - EVAL file
void evalSelected(File eval) {
  if (eval == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + eval.getAbsolutePath());
    evalfile = eval.getName();
    evalLabel.show().setText(evalfile + "...loaded");
    println("Eval file: " + evalfile);
  }
  
  String lines[] = loadStrings(eval.getAbsolutePath());
  println("There are " + lines.length + " lines.");
  for (int i = 0 ; i < lines.length; i++) {
  println(lines[i]);
  }
  
  functions = setFunctions(lines);

  functionsList.addItems(functions);
  
}

//Load function - LABEL file
void labelSelected(File label) {
  if (label == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + label.getAbsolutePath());
    labelfile = label.getName();
    labelLabel.show().setText(labelfile + "...loaded");
    println("Label file: " + labelfile);
  }
}

//As eval file is function - score, this gets a list of all the functions, without the score to be displayed for the label maker
public String[] setFunctions(String[] input) {
  String[] newList = new String[(input.length)/2];
  for ( int i = 0 ; i < newList.length; i++){
    newList[i] = input[(2*i)];
    //println("List Item #" + i + ", " + newList[i]);
  }
  return newList;
}