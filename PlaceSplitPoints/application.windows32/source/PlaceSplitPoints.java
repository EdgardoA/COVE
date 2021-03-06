import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 
import java.io.*; 
import java.lang.*; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class PlaceSplitPoints extends PApplet {






public class OBJVertex{
   public float x_pos, y_pos, z_pos;
   public int o_pos, n_pos;
   public OBJVertex(float x, float y, float z, int o){
     x_pos = x; 
     y_pos = y;
     z_pos = z;
     o_pos = o;
     n_pos = -1;
   }
}

public class OBJFace{
   public int v1, v2, v3;
   public OBJFace(int x, int y, int z){
     v1 = x;
     v2 = y;
     v3 = z;
   }
}

public class SplitPoint {
   public float x_pos, y_pos, z_pos;
   public String label;
   public int l;
   public SplitPoint(float x, float y, float z){
     x_pos = x;
     y_pos = y;
     z_pos = z;
     label = "Test";
     l = 0;
   }
}

//Data Elements
ArrayList<SplitPoint> point_list;
ArrayList<OBJVertex> vertex_list;
ArrayList<OBJFace> face_list;
ArrayList<ArrayList<OBJVertex>> new_vertex_list;
ArrayList<String> label_list;
float x_pos, y_pos, z_pos, x_rot, y_rot, z_rot, radius;
int index, label_index;
boolean show_vertex;
String obj_file;
String label_file;
String save_file;
boolean place_mode;                      //if false, label mode
PShape s;

//GUI Elements
ControlP5 cp5;
Button NextPoint, PrevPoint, SetLabel, SwitchMode, Save;
ScrollableList LabelList;

public void writeToFile(int n){
   //Arrange vertices to split
   for(int i = 0; i < point_list.size() - 1; i++){
      new_vertex_list.add(new ArrayList<OBJVertex>()); 
   }
   for(int i = 0; i < vertex_list.size(); i++){
      double min_distance = Double.POSITIVE_INFINITY;
      double cur_distance;
      int min_point = 0;
      for(int j = 0; j < point_list.size() - 1; j++){
          cur_distance = Math.sqrt( 
             Math.pow(point_list.get(j).x_pos - vertex_list.get(i).x_pos , 2) +
             Math.pow(point_list.get(j).y_pos - vertex_list.get(i).y_pos , 2) +
             Math.pow(point_list.get(j).z_pos - vertex_list.get(i).z_pos , 2));
          if(cur_distance < min_distance){
             min_distance = cur_distance;
             min_point = j;
          }
      }
      new_vertex_list.get(min_point).add(vertex_list.get(i));
   }
   
   //Write to file
   PrintWriter out;
   try{
     out = new PrintWriter(save_file);
     int count = 1;
     for(int i = 0; i < new_vertex_list.size(); i++){
        for(int j = 0; j < new_vertex_list.get(i).size(); j++){
            vertex_list.get(new_vertex_list.get(i).get(j).o_pos - 1).n_pos = count;
            count++;
            out.println("v " + new_vertex_list.get(i).get(j).x_pos + " " 
                             + new_vertex_list.get(i).get(j).y_pos + " " 
                             + new_vertex_list.get(i).get(j).z_pos + " "
                             + new_vertex_list.get(i).get(j).o_pos);
        }
     }
     out.println("");
     for(int i = 0; i < face_list.size(); i++){
        out.println("f " + vertex_list.get(face_list.get(i).v1 - 1).n_pos + " " 
                         + vertex_list.get(face_list.get(i).v2 - 1).n_pos + " "
                         + vertex_list.get(face_list.get(i).v3 - 1).n_pos); 
     }
     out.println("");
     count = 0;
     for(int i = 0; i < new_vertex_list.size(); i++){
        out.println("d " + point_list.get(i).label);
        count += new_vertex_list.get(i).size();
        out.println("d " + count);
     }
     out.println("");
     for(int i = 0; i < point_list.size() - 1; i++){
        out.println("p " + point_list.get(i).x_pos + " "
                         + point_list.get(i).y_pos + " "
                         + point_list.get(i).z_pos);
     }
     out.close();
   } catch(IOException e){
      e.printStackTrace(); 
   }
   exit();
}

public void loadFiles(){
  boolean not_done = true;
  Scanner scan;
  BufferedReader reader;
  String line;
  
  reader = createReader(label_file);
  while(not_done){
     try{
        line = reader.readLine();
     } catch(IOException e){
        e.printStackTrace();
        line = null;
     }
     if(line == null){
        break;
     } else{
        if(line.charAt(0) == 'l'){
           label_list.add(line.substring(2));
           LabelList.addItem(line.substring(2), null);
        }
     }
  }
  
  if(obj_file.charAt(obj_file.length() - 1) == 'l'){  
    reader = createReader(obj_file);
    boolean temp = true;
    int l = 0;
    float x, y, z;
    while(true){
       try{
        line = reader.readLine();
       } catch(IOException e){
          e.printStackTrace();
          line = null;
       }
       if(line == null){
          break; 
       } else{
          if(line.length() > 2){
            if(line.charAt(0) == 'd'){
               if(temp) {
                  SplitPoint s = new SplitPoint(0, 0, 0);
                  s.label = line.substring(2);
                  s.l = label_list.indexOf(line.substring(2));
                  point_list.add(s);
               } else {
                  
               }
               temp = !temp;
            }
            if(line.charAt(0) == 'p'){
               scan = new Scanner(line.substring(2));
               x = scan.nextFloat();
               y = scan.nextFloat();
               z = scan.nextFloat();
               point_list.get(l).x_pos = x;
               point_list.get(l).y_pos = y;
               point_list.get(l).z_pos = z;
               l++;
            }
          }
       }
    }
    obj_file = obj_file.substring(0, obj_file.length() - 1);
  }
  
  point_list.add(new SplitPoint(0, 0, 0));
  s = loadShape(obj_file);
  
  reader = createReader(obj_file);
  int l = 1;
  while(not_done){
     try{
        line = reader.readLine();
     } catch(IOException e){
        e.printStackTrace();
        line = null;
     }
     if(line == null){
        break; 
     } else{
        float x, y , z;
        int i = 0, j = 0, k = 0;
        if(line.length() > 2){
          if(line.charAt(0) == 'v' && line.charAt(1) != 'n' && line.charAt(1) != 't'){
              scan = new Scanner(line.substring(1));
              x = scan.nextFloat();
              y = scan.nextFloat();
              z = scan.nextFloat();
              vertex_list.add(new OBJVertex(x, y, z, l));
              l++;
          } else if(line.charAt(0) == 'f'){
              int dummy_count = 0;
              int start = 0;
              int end = 0;
              boolean v_start = true;
              for(int a = 1; a < line.length(); a++){
                 if((!Character.isDigit( line.charAt(a)) || a == line.length() - 1) && start != 0){
                    end = a;
                    String s = line.substring(start, end);
                    switch(dummy_count){
                       case 0: i = Integer.parseInt(s); break;
                       case 1: j = Integer.parseInt(s); break;
                       case 2: k = Integer.parseInt(s); break;
                    }
                    dummy_count++;
                    start = 0;
                    end = 0;
                    v_start = false;
                 }
                 if(Character.isDigit(line.charAt(a)) && v_start && start == 0){
                    start = a;
                 }
                 if(line.charAt(a) == ' '){
                    v_start = true;
                 }
              }
              if(i != 0 && j != 0 && k != 0){
                face_list.add(new OBJFace(i, j, k));
              } else{
                scan = new Scanner(line.substring(2));
                i = scan.nextInt();
                j = scan.nextInt();
                k = scan.nextInt();
                face_list.add(new OBJFace(i, j, k));
              }
          }
        }
     }
  }
}

public void setup()
{
  point_list = new ArrayList<SplitPoint>();
  vertex_list = new ArrayList<OBJVertex>();
  new_vertex_list = new ArrayList<ArrayList<OBJVertex>>();
  face_list = new ArrayList<OBJFace>();
  label_list = new ArrayList<String>();
  
  index = label_index = 0;
  x_pos = y_pos = z_pos = 0;
  x_rot = 180;
  y_rot = z_rot = 0;
  radius = 5;
  show_vertex = false;
  place_mode = true;
  
  cp5 = new ControlP5(this);
  PrevPoint = cp5.addButton("PreviousPoint").setPosition(20, 20).setSize(100, 20).hide();
  NextPoint = cp5.addButton("NextPoint").setPosition(140, 20).setSize(100, 20).hide();
  SetLabel = cp5.addButton("SetLabel").setPosition(20, 50).setSize(100, 20).hide();
  SwitchMode = cp5.addButton("SwitchMode").setPosition(680, 20).setSize(100, 20);
  Save = cp5.addButton("writeToFile").setPosition(680, 760).setSize(100, 20);
  LabelList = cp5.addScrollableList("labelList").setPosition(20, 80).setSize(100, 100)
    .setBarHeight(20).setItemHeight(20).setType(ControlP5.LIST).hide();
  
  obj_file = "H:\\CSCE_482\\COVE\\PlaceSplitPoints\\icosahedron2.obj";
  selectInput("Select an .obj or .objl file to load:", "objSelected");
  //obj_file = "H:\\CSCE_482\\COVE\\PlaceSplitPoints\\icosahedron2";
  label_file = "H:\\CSCE_482\\COVE\\PlaceSplitPoints\\teapot.ld";
  s = loadShape(obj_file);
}

public void keyPressed(){
  if(place_mode){
    switch(key){
      case 9  : index = (index+1) % point_list.size(); break;    //tab 
      case 32 :                                                  //spacebar
        if(index == point_list.size() - 1){
          point_list.add(new SplitPoint(0, 0, 0));
        }
        index = point_list.size() - 1;
        break;
      //case 49 : writeToFile(); break;                            //1
      case 50 : show_vertex = !show_vertex; break;               //2
      case 51 :                                                  //3
        if(point_list.size() > 1){
          place_mode = !place_mode;
          index = 0;
        }
        break;
    }
  } else {
    switch(key){
      case 9  : index = (index+1) % (point_list.size() - 1); break;    //tab 
      //case 49 : writeToFile(); break;                            //1
      case 50 : show_vertex = !show_vertex; break;               //2
      case 51 : place_mode = !place_mode;                        //3
        index = point_list.size() - 1;
        break;
    }
  }
}

public void draw(){
  background(204);
  lights();
  pushMatrix();
  if(place_mode){
    if(keyPressed == true) {
      switch(key){
        case 97 : point_list.get(index).x_pos -= 2; break;       //a
        case 100: point_list.get(index).x_pos += 2; break;       //d
        case 101: point_list.get(index).z_pos += 2; break;       //e
        case 102: x_pos -= 2; break;                             //f
        case 103: y_pos += 2; break;                             //g
        case 104: x_pos += 2; break;                             //h
        case 105: x_rot += 2; break;                             //i
        case 106: z_rot -= 2; break;                             //j
        case 107: x_rot -= 2; break;                             //k
        case 108: z_rot += 2; break;                             //l
        case 111: y_rot += 2; break;                             //o
        case 113: point_list.get(index).z_pos -= 2; break;       //q
        case 114: z_pos -= 2; break;                             //r
        case 115: point_list.get(index).y_pos -= 2; break;       //s
        case 116: y_pos -= 2; break;                             //t
        case 117: y_rot -= 2; break;                             //u
        case 119: point_list.get(index).y_pos += 2; break;       //w
        case 120: radius += .2f; break;                           //x
        case 121: z_pos += 2; break;                             //y
        case 122: radius = max(1, radius - .2f); break;           //z
      }
    }
    translate(400, 400, 400);
    translate(x_pos, y_pos, z_pos);
    rotateX(radians(x_rot));
    rotateY(radians(y_rot));
    rotateZ(radians(z_rot));
    shape(s);
    for(int i = 0; i < point_list.size(); i++) {
      pushMatrix();
      if(show_vertex){
        switch(i){
             case 0: fill(255, 0, 0); break;
             case 1: fill(0, 255, 0); break;
             case 2: fill(0, 0, 255); break;
             case 3: fill(255, 255, 0); break;
             case 4: fill(255, 0, 255); break;
             case 5: fill(0, 255, 255); break;
             case 6: fill(255, 255, 255); break;
             default: fill(0, 0, 0); break;
        }
      } else if(i < point_list.size() - 1){
         fill(20, 20, 100); 
      }
      if(i == point_list.size() - 1){
         fill(100, 20, 20); 
      }
      if(i == index){
         fill(20, 100, 20);
      }
      translate(point_list.get(i).x_pos, point_list.get(i).y_pos, point_list.get(i).z_pos);
      sphere(radius);
      popMatrix();
    }
    if(show_vertex){
      for(int i = 0; i < vertex_list.size(); i++){
          double min_distance = Double.POSITIVE_INFINITY;
          double cur_distance;
          int min_point = 0;
          for(int j = 0; j < point_list.size() - 1; j++){
              cur_distance = Math.sqrt( 
                 Math.pow(point_list.get(j).x_pos - vertex_list.get(i).x_pos , 2) +
                 Math.pow(point_list.get(j).y_pos - vertex_list.get(i).y_pos , 2) +
                 Math.pow(point_list.get(j).z_pos - vertex_list.get(i).z_pos , 2));
              if(cur_distance < min_distance){
                 min_distance = cur_distance;
                 min_point = j;
              }
          }
          pushMatrix();
          switch(min_point){
             case 0: fill(255, 0, 0); break;
             case 1: fill(0, 255, 0); break;
             case 2: fill(0, 0, 255); break;
             case 3: fill(255, 255, 0); break;
             case 4: fill(255, 0, 255); break;
             case 5: fill(0, 255, 255); break;
             case 6: fill(255, 255, 255); break;
             default: fill(0, 0, 0); break;
          }
          translate(vertex_list.get(i).x_pos, vertex_list.get(i).y_pos, vertex_list.get(i).z_pos);
          sphere(1);
          popMatrix();
      }
    }
  } else {
    if(keyPressed == true) {
      switch(key){
        //case 97 : point_list.get(index).x_pos -= 2; break;     //a
        //case 100: point_list.get(index).x_pos += 2; break;     //d
        //case 101: point_list.get(index).z_pos += 2; break;     //e
        case 102: x_pos -= 2; break;                             //f
        case 103: y_pos += 2; break;                             //g
        case 104: x_pos += 2; break;                             //h
        case 105: x_rot += 2; break;                             //i
        case 106: z_rot -= 2; break;                             //j
        case 107: x_rot -= 2; break;                             //k
        case 108: z_rot += 2; break;                             //l
        case 111: y_rot += 2; break;                             //o
        //case 113: point_list.get(index).z_pos -= 2; break;     //q
        case 114: z_pos -= 2; break;                             //r
        //case 115: point_list.get(index).y_pos -= 2; break;     //s
        case 116: y_pos -= 2; break;                             //t
        case 117: y_rot -= 2; break;                             //u
        //case 119: point_list.get(index).y_pos += 2; break;     //w
        case 120: radius += .2f; break;                           //x
        case 121: z_pos += 2; break;                             //y
        case 122: radius = max(1, radius - .2f); break;           //z
      }
    }
    translate(400, 400, 400);
    translate(x_pos, y_pos, z_pos);
    rotateX(radians(x_rot));
    rotateY(radians(y_rot));
    rotateZ(radians(z_rot));
    shape(s);
    for(int i = 0; i < point_list.size() - 1; i++) {
      pushMatrix();
      if(show_vertex){
        switch(point_list.get(i).l){
             case 0: fill(255, 0, 0); break;
             case 1: fill(0, 255, 0); break;
             case 2: fill(0, 0, 255); break;
             case 3: fill(255, 255, 0); break;
             case 4: fill(255, 0, 255); break;
             case 5: fill(0, 255, 255); break;
             case 6: fill(255, 255, 255); break;
             default: fill(0, 0, 0); break;
        }
      } else if(i < point_list.size() - 1){
         fill(20, 20, 100); 
      }
      if(i == point_list.size() - 1){
         fill(100, 20, 20); 
      }
      if(i == index){
         fill(20, 100, 20);
      }
      translate(point_list.get(i).x_pos, point_list.get(i).y_pos, point_list.get(i).z_pos);
      sphere(radius);
      popMatrix();
    }
    if(show_vertex){
      for(int i = 0; i < vertex_list.size(); i++){
          double min_distance = Double.POSITIVE_INFINITY;
          double cur_distance;
          int min_point = 0;
          for(int j = 0; j < point_list.size() - 1; j++){
              cur_distance = Math.sqrt( 
                 Math.pow(point_list.get(j).x_pos - vertex_list.get(i).x_pos , 2) +
                 Math.pow(point_list.get(j).y_pos - vertex_list.get(i).y_pos , 2) +
                 Math.pow(point_list.get(j).z_pos - vertex_list.get(i).z_pos , 2));
              if(cur_distance < min_distance){
                 min_distance = cur_distance;
                 //min_point = j;
                 min_point = point_list.get(j).l;
              }
          }
          pushMatrix();
          switch(min_point){
             case 0: fill(255, 0, 0); break;
             case 1: fill(0, 255, 0); break;
             case 2: fill(0, 0, 255); break;
             case 3: fill(255, 255, 0); break;
             case 4: fill(255, 0, 255); break;
             case 5: fill(0, 255, 255); break;
             case 6: fill(255, 255, 255); break;
             default: fill(0, 0, 0); break;
          }
          translate(vertex_list.get(i).x_pos, vertex_list.get(i).y_pos, vertex_list.get(i).z_pos);
          sphere(1);
          popMatrix();
      }
    }
  }
  popMatrix();
  noStroke();
}

public void SwitchMode(int theValue){
   place_mode = !place_mode;
   if(place_mode){
       index = point_list.size() - 1;
       PrevPoint.hide();
       NextPoint.hide();
       SetLabel.hide();
       LabelList.hide();
   } else{
       index = 0;
       PrevPoint.show();
       NextPoint.show();
       SetLabel.show();
       LabelList.show();
   }
}

public void PreviousPoint(int theValue){
   index = (index-1);
   if(index == -1){
      index = point_list.size() - 2; 
   }
}

public void NextPoint(int theValue){
   index = (index+1) % (point_list.size() - 1);
}

public void SetLabel(int theValue){
   point_list.get(index).label = label_list.get(label_index);
   point_list.get(index).l = label_index;
}

public void labelList(int n){
   label_index = n;
}

//Load function - OBj file
public void objSelected(File obj) {
  if (obj == null) {
    
  } else {
    obj_file = obj.getAbsolutePath();
    label_file = obj.getAbsolutePath();
    if(obj_file.charAt(obj_file.length() - 1) == 'l'){
      label_file = obj_file.substring(0, obj_file.length() - 4) + "ld";
      save_file = obj_file.substring(0, obj_file.length() - 4) + "objl";
    } else{
      label_file = obj_file.substring(0, obj_file.length() - 3) + "ld";
      save_file = obj_file.substring(0, obj_file.length() - 3) + "objl";
    }
    loadFiles();
  }
}
  public void settings() {  size(800,800,P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "PlaceSplitPoints" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
