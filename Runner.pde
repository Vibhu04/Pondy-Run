
import cassette.audiofiles.SoundFile;
import android.os.Environment;
SoundFile sound;
String[] score_text = new String[1];
String dataFile;
boolean writeable = false;
float ground_height;
boolean jumped = false;
float obstacle_gap;
int score = 0;
int obstacle_index = 0;
int high_score;
int gameState = 1;
PFont score_font;
PFont pause_font;
PImage step1;
PImage step2;
PImage jump;
PImage vib_char;
int count;
int o_speed = 20;
float sticks_gap;
FloatList pause = new FloatList();
boolean dead = false;
boolean paused = false;
int screen = 1;


class Person {
  String name;
  float mass, person_height, reaction_time, char_height, char_width, x, y, initY, face_height, face_x, face_y;
  float thrust = 35;
  float gravity = 2;
  int step = 1;
  int imgCount = 0;
  
  Person(String _name, float _mass, float _person_height, float _reaction_time) {
    name = _name;
    mass = _mass;
    person_height = _person_height;
    reaction_time = _reaction_time;
    
    
     
  }
  
  void create() {
    //fill(0);
    
    //rect(x,y, char_width, char_height);
    //fill(100);
    //pushMatrix();
    //translate(x+char_width/2,y);
    //rotate(0.2);
    ////translate(0,0);
    //rect(0,0,x/4,char_height*0.6);
    ////translate(-x/8,-char_height/4);
    ////rotate(0);
    //popMatrix();
    
    //pushMatrix();
    //translate(x+char_width/2-char_height*0.6*sin(0.2),y+char_height*0.6*cos(0.2));
    //rotate(0.2);
    //rect(0,0,x,x/4);
    //popMatrix();
    ////rotate(0);
    if(jumped == false) {
      imgCount++;
      if(step == 1) {
        image(step1, x, y);
        step1.resize(0, int(char_height));
      } else {
        image(step2, x, y);
        step2.resize(0, int(char_height));
      }
      
      if(imgCount % 10 == 0) {
         if(step == 1) {
            step = 2; 
         } else {
            step = 1; 
         }
      }
      
    } else {
      image(jump, x, y);
      jump.resize(0, int(char_height));
    }
    
    if(jumped) {
      face_y = y - char_height*0.4;
    }
     
    image(vib_char, face_x, face_y);
    vib_char.resize(0, int(face_height));
    
    
    
    
    
  }
  
  void jump() {
    
    
    y -= thrust;
    thrust -= gravity;
    if(thrust < 0) {
      if(y >= initY) {
        jumped = false;
        thrust = 35;
        gravity = 2;
        char_height /= 0.6;
        face_x = x*1.1;
        face_y = y - char_height*0.25;
      }
    }
    
  }
  
  void checkCollision() {
    if(y + char_height >= obstacles.get(0).y) {
       fill(70);
       rect(displayWidth/2, displayHeight/2, 40, 40); 
       dead = true;
       
    }
  }
  
}

class Obstacle {
  float x,y,o_height,o_width;
  
  Obstacle(float _o_height, float _o_width) {
   
   
   o_height = _o_height;
   o_width = _o_width;
  }
  
  void create() {
     fill(200);
     rect(x,y,o_width,o_height);
  }
  
  void move() {
    
     x -= o_speed;
     
  }
  
}

Person player = new Person("Vibhu",65,183,0);

ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();


void setup() {
  
  orientation(LANDSCAPE);
  frameRate(100);
  size(displayWidth, displayHeight);
  ground_height = height/10;
  player.char_height = height*0.3;
  player.x = width/20;
  player.y = height - ground_height - player.char_height;
  player.initY = height - ground_height - player.char_height;
  player.char_width = width/10;
  player.face_height = player.char_height * 0.4;
  player.face_x = player.x*1.1;
  player.face_y = player.y-player.char_height*0.25;
  obstaclesInit();
  
  sound = new SoundFile(this, "Jumping.mp3");
  
  score_font = createFont("Helvetica.ttf", height/20);
  pause_font = createFont("Helvetica-light.ttf", height*0.06);
  count = 0;
  sticks_gap = width/40;
  score_text = loadStrings("High_score.txt");
  println(score_text[0]);
  high_score = int(score_text[0]);
  pause.append(width/2 - sticks_gap*0.5);
  pause.append(height/20);
  pause.append(sticks_gap);
  pause.append(height/15);
  
  step1 = loadImage("Step1.png");
  step2 = loadImage("Step2.png");
  jump = loadImage("Jump.png");
  vib_char = loadImage("Vib_char.png");
  
  
  dataFile = getSdWritableFilePathOrNull("High_score.txt");
  if (dataFile == null ){
        String errorMsg = "There was error getting SD card path. Maybe your device doesn't have SD card mounted at the moment";
        println(errorMsg);
        //msgToDraw = errorMsg;
  }
  else{
      
      writeable = true;
      println(dataFile);
      
      
      
  }
  
  
  
 
  
}

void draw() {
  
  background(255);
  
  show_screen(screen);
  
  
}

void show_screen(int x) {
  
  switch(x) {
     case 1:
       main_menu();
       break;
     case 2:
       start_game();
       break;
  }
  
}

void main_menu() {
  
  rectMode(CENTER);
  fill(255);
  strokeWeight(2);
  
  rect(width/2, height*0.5 , width/4, height/6);
  rect(width/2, height*0.7 , width/4, height/6);
  fill(0);
  textAlign(CENTER,CENTER);
  textFont(pause_font);
  text("Play", width/2, height*0.5);
  text("Exit", width/2, height*0.7);
  rectMode(CORNER);
  textAlign(LEFT);
  
}

void start_game() {
  
  if(!dead && !paused) {
    
    adjust_score();
    adjust_obstacles();
    
    if(jumped == true) {
      player.jump(); 
    }
    
  }
  
  show_score();
  
  draw_ground();
  
  add_pause();
  
  move_obstacles();
  
  player.create();
  
  
  
  if(paused) {
   show_options();
   
  }
  
  
}

void obstaclesInit() {
  o_speed = 20;
  obstacle_index = 0;
  obstacle_gap = random(width*0.6, width*1.5);
  obstacles.add(new Obstacle(random(100,200), random(100,150)));
  obstacles.get(0).x = width;
  obstacles.get(0).y = height - ground_height - obstacles.get(0).o_height;
  
}

void show_score() {
  fill(0);
  
  textFont(score_font);
  text(str(score), width/20, height/10);
  
  text(str(high_score), width*0.9, height/10);
}

void draw_ground() {
  fill(100);
  rect(0, height - ground_height, width, ground_height);
}

void move_obstacles() {
  
  for(int i = 0; i < obstacles.size(); i++) {
    obstacles.get(i).create();
    if(!paused && !dead) {
      obstacles.get(i).move();
    }
    
    if(i == obstacle_index) {
       float w;
       if(jumped) {
         w = player.char_height;
       } else {
         w = player.char_height*0.375; 
       }
       if(obstacles.get(i).x <= player.x + w && obstacles.get(i).x + obstacles.get(i).o_width >= player.x) {
         player.checkCollision();
       } 
    }
    
  }
  
}

void adjust_score() {
    count++;
    if(count % 60 == 0) {
     score++; 
     if(score > high_score) {
        high_score = score;
        score_text[0] = str(high_score);
        if(writeable) {
          //saveStrings(dataFile, score_text);
        }
        
     }
     if((score + 1) % 20 == 0) {
       
       o_speed += 5; 
      
     }
    }
}

void adjust_obstacles() {
  
  
    if(width - obstacles.get(obstacles.size()-1).x > obstacle_gap) {
      obstacles.add(new Obstacle(random(100,200), random(100,200)));
      obstacles.get(obstacles.size()-1).x = width;
      obstacles.get(obstacles.size()-1).y = height - ground_height - obstacles.get(obstacles.size()-1).o_height;
      obstacle_gap = random(width*0.6, width*1.5);
      
      if(obstacles.get(0).x + obstacles.get(0).o_width < 0) {
          obstacles.remove(0); 
          obstacle_index = 0;
      }
      
      
    }
    
    if(obstacles.get(0).x + obstacles.get(0).o_width < 0) {
           
          obstacle_index = 1;
    }
    
    
    
    
  
}

void add_pause() {
   
   fill(0);
   rect(pause.get(0), pause.get(1), width/150, pause.get(3));
   rect(pause.get(0) + sticks_gap - width/150, pause.get(1), width/150, pause.get(3));
   
}

void show_options() {
  
  fill(255,255,255,150);
  rect(0,0,width,height); 
  rectMode(CENTER);
  fill(255);
  strokeWeight(2);
  rect(width/2, height/2, width/3, (height*2)/3);
  
  rect(width/2, height*0.35 , width/4, height/6);
  rect(width/2, height*0.65 , width/4, height/6);
  fill(0);
  textAlign(CENTER,CENTER);
  textFont(pause_font);
  text("Resume", width/2, height*0.35);
  text("Main Menu", width/2, height*0.65);
  
  rectMode(CORNER);
  textAlign(LEFT);
  
}

String getSdWritableFilePathOrNull(String relativeFilename){
   File externalDir = Environment.getExternalStorageDirectory();
   if ( externalDir == null ){
      return null;
   }
   String sketchName = this.getClass().getSimpleName();
   //println("simple class (sketch) name is : " + sketchName );
   File sketchSdDir = new File(externalDir, sketchName);
   
   File finalDir =  new File(sketchSdDir, relativeFilename);
   return finalDir.getAbsolutePath();
   
}

void start_afresh() {
  
   score = 0;
   count = 0;
   obstacles.clear();
   obstaclesInit();
   dead = false;
  
}


void mousePressed() {
  
  switch(screen) {
    
    case 1:
    
    // play button
    if(mouseX >= width/2 - width/8 && mouseX <= width/2 + width/8 && mouseY >= height*0.5 - height/12 && mouseY <= height*0.5 + height/12) {
        
      paused = false;
      start_afresh();
      screen = 2;
        
    }
    
    // exit button
    if(mouseX >= width/2 - width/8 && mouseX <= width/2 + width/8 && mouseY >= height*0.7 - height/12 && mouseY <= height*0.7 + height/12) {
        
        exit();
        
     }
     
      break;
    
    case 2:
    
      
      // pause button
      if(mouseX >= pause.get(0) && mouseX <= pause.get(0) + pause.get(2) && mouseY >= pause.get(1) && mouseY <= pause.get(1) + pause.get(3)) {
        
        paused = true;
        
      }
      
      if(!paused) {
        
        if(!dead) {
          
          if(player.y >= player.initY) {
            
            jumped = true;
            
            player.face_x = player.x + player.char_height*0.45;
            player.char_height *= 0.6;
            sound.play();
          }
        
            
            
        } else {
          
          start_afresh();
         
           
        }
        
         
        
      } else {
        
        // resume button
        if(mouseX >= width/2 - width/8 && mouseX <= width/2 + width/8 && mouseY >= height*0.35 - height/12 && mouseY <= height*0.35 + height/12) {
          
          paused = false;
          
        } 
        
        // main menu
        if(mouseX >= width/2 - width/8 && mouseX <= width/2 + width/8 && mouseY >= height*0.65 - height/12 && mouseY <= height*0.65 + height/12) {
          
          screen = 1;
          
        } 
        
      }
    
      

      
      break;
      
      
    
  }
  
 
}
