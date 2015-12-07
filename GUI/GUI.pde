/*
**  GUI Testing with controlP5
*/
 
import controlP5.*;
import java.util.*;

ControlP5 cp5;
Button OBJ, EVAL, LABEL, MKLABEL, addButton, NEW, MODIFY, LOGO, CONTINUE;
Textlabel objLabel, evalLabel, labelLabel;
Textlabel headerLBL, subheaderLBL, newLBL, modifyLBL;
ScrollableList functionsList, selectedList;
Textfield newLabel ;

int myColor = color(255);

float n,n1;

String objfile, evalfile, labelfile;

Boolean first = false;

String functions[];

String labels[];

Textarea myTextarea;
Println console;

PImage logo;

void setup() {
  size(600,400);
  noStroke();
  
  logo = loadImage("logo.png");
  
  cp5 = new ControlP5(this);
   
  LOGO = cp5.addButton("LOGO")
    .setPosition(172,0)
    .setSize(256,110)
    .setImages(logo,logo,logo)
    ;
     
  newLBL = cp5.addTextlabel("newLBL")
    .setText("Provide an object, evaluation and label file to create  a new rendering")
    .setPosition(150,135)
    .setColorValue(000000)
    ;
  
  //OBJ Button
  OBJ = cp5.addButton("OBJ")
     .setCaptionLabel("Load OBJ File")
     .setPosition(25,175)
     .setSize(100,20)
     ;
  
  //OBJ Label
  objLabel = cp5.addTextlabel("objLbl")
    .setText("No Object Loaded")
    .setPosition(40,200)
    .setColorValue(000000)
    .hide()
    ;
  
  //EVAL Button
  EVAL = cp5.addButton("EVAL")
    .setCaptionLabel("Load Eval file")
    .setPosition(150,175)
    .setSize(100,20)
    .hide()
    ;
  
  //EVAL Label
  evalLabel = cp5.addTextlabel("evalLbl")
    .setText("No Eval Loaded")
    .setPosition(165,200)
    .setColorValue(000000)
    .hide()
    ;
    
  //LABEL Button
  LABEL = cp5.addButton("LABEL")
    .setCaptionLabel("Load Label file")
    .setPosition(275,175)
    .setSize(100,20)
    .hide()
    ;
    
  //Label Label
  labelLabel = cp5.addTextlabel("labelLbl")
    .setText("No Label Loaded")
    .setPosition(290,200)
    .setColorValue(000000)
    .hide()
    ;
  
  //Clear Button
  cp5.addButton("Clear")
      .setPosition(400,25)
      .setSize(50,20)
      .hide();
      ;
    
     /*
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
     
   //Selected functions for labels
   selectedList = cp5.addScrollableList("selectList")
     .setCaptionLabel("Labels & Functions...")
     .setPosition(25,200)
     .setSize(200,100)
     .setBarHeight(20)
     .setItemHeight(20)
     .setType(ControlP5.LIST)
     .hide()
     ;
     */
     
     CONTINUE = cp5.addButton("CONTINUE")
       .setCaptionLabel("Continue...")
       .setPosition(250,350)
       .setSize(100,20)
       .hide()
       ;
}

void draw() {
  background(myColor);
  /*
  if (functionsList.isOpen() == false) {
    functionsList.open();
  }  */
}

public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
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
  println("Prompting user for eval file location");
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
  CONTINUE.show();
}

//Starts the whole program again - useful for debugging
public void Clear(int theValue) {
  
  OBJ.hide();
  objLabel.setText("No Object Loaded");
  objLabel.hide();
  EVAL.hide();
  evalLabel.setText("No Eval Loaded");
  evalLabel.hide();
  LABEL.hide();
  labelLabel.setText("No Label Loaded");
  labelLabel.hide(); 
  MKLABEL.hide();
  functionsList.hide();
  newLabel.hide();
  selectedList.hide();
  addButton.hide();
  objfile = null;
  
  objSelected(null);
  evalfile = "";
  evalSelected(null);
  labelfile = "";
  
  labelSelected(null);
  println("Some Error---");
  selectedList.clear();
  functionsList.clear();
  
}



void functionsFunc (int n) {
  
  functionsList.getItem(n).put("value",true);
  println(n,functionsList.getItem(n));
}

//Modify the Label Dropdown list
void selectList(int n) {
 
  println(n,selectedList.getItem(n));
  
  CColor selectedColor = new CColor();
  selectedColor.setBackground(color(255,0,0));
  selectedList.getItem(n).put("color", selectedColor);
  
}


//Load function - OBj file
void objSelected(File obj) {
  if (obj == null) {
    println("Window was closed or the user hit cancel.");
    EVAL.hide();
    evalLabel.hide();
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
  //functions = setFunctions(lines);
  //functionsList.addItems(functions);
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
    
    String labelInput[] = loadStrings(label.getAbsolutePath());
    println("There are " + labelInput.length + " lines.");
    for (int i = 0 ; i < labelInput.length; i++) {
    println(labelInput[i]);
    }
    //labels = setLabels(labelInput); //setLabels function not in use
    //selectedList.addItems(labelInput);
    //selectedList.setSize(200,(20*labelInput.length + 20)); //Expand list to show everything
    
    
  }
}

//As eval file is function - score, this gets a list of all the functions, without the score to be displayed for the label maker
public String[] setFunctions(String[] input) {
  String[] newList = new String[(input.length)/2];
  for ( int i = 0 ; i < newList.length; i++){
    newList[i] = input[(2*i)];
  }
  return newList;
}


//Read in a label file - and truncate the 'l' and the 'f' tag - CURRENTLY NOT USED
public String[] setLabels(String[] rawLabels) {
  String[] newlabels = new String[(rawLabels.length)];
  for ( int i = 0; i < newlabels.length; i++) {
    if (rawLabels[i].substring(0,1).equals("f")) {
      newlabels[i] = rawLabels[i].substring(2);
    } else if (rawLabels[i].substring(0,1).equals("l")) {
      newlabels[i] = rawLabels[i].substring(2);
    }
  }
  return newlabels;
}