
import cassette.audiofiles.SoundFile;
import android.os.Environment;

// jumping sound effect
SoundFile jump_sound;
// game over sound effect
SoundFile game_over;

int players = 2; // total number of characters
int selected = 0; // the first player is selected by default

float min_oheight;
String png = ".png";
// all the fonts used 
PFont score_font;
PFont pause_font;
PFont title_font;
PFont attr_font;
// images of the different parts
PImage limbs1, limbs2;
PImage shorts;
PImage tshirt;
PImage jLimbs, jTshirt, jShorts;
// images of the two steps
PImage step1;
PImage step2;
// image of the autorickshaw
PImage auto;
// moving background
PImage bg;
// image of the jump position
PImage jump;
// check button image
PImage check;
// crow flaps
PImage crow1, crow2;
// images for the characters while running
PImage[] photos = new PImage[players];
// images on display for choosing character
PImage[] small = new PImage[players];
// images to be shown when showing the details of character
PImage[] big = new PImage[players];
// images of obstacles
PImage[] obstacle_imgs = new PImage[2];
// counts every iteration
int count;
// obstacle speed
int o_speed = 20;
// gap between the sticks of pause button
float sticks_gap;
// coordinates  of pause button
FloatList pause = new FloatList();
boolean dead = false;
boolean paused = false;
// begin at the first screen
int screen = 1;
// for shifting the bg
int x = 0;
// 1 - auto, 2 - crow
int o_choice;
// difference of height between auto and crow
int crow_auto_dif;




String[] score_text = new String[1];
String dataFile;
boolean writeable = false;
float ground_height;
boolean jumped = false;
float obstacle_gap;
int score = 0;
int obstacle_index = 0;
int high_score;

// names of characters
String[] names = {"Vibhu", "Khushi"};
// qualities of characters (height, jump, stamina)
float[][] attributes = {{183, 45, 20}, {167, 40, 10}};

// auto rickshaw height and width
int auto_height;
int auto_width;
// crow height and width
int crow_height, crow_width;


class Person {
  String name;
  float mass, person_height, reaction_time, char_height, char_width, x, y, initY, face_height, face_x, face_y;
  float thrust;
  float gravity = 2;
  int step = 1;
  PImage photo;
  int imgCount = 0;
  
  Person(int index) {
    
    
    name = names[index];
    //mass = attributes[index][0];
    person_height = attributes[index][0];
    //reaction_time = attributes[index][2];
    thrust = attributes[index][1];
    
     
  }
  
  void create() {
    
    if(jumped == false) {
      imgCount++;
      //image(tshirt, x, y);
      //image(shorts, x, y);
      tint(207,27,27);
      image(tshirt, x, y);
      noTint();
      
      
      if(step == 1) {
        image(limbs1, x, y);
        //image(step1, x, y);
        //step1.resize(0, int(char_height));
      } else {
        image(limbs2, x, y);
        //image(step2, x, y);
        //step2.resize(0, int(char_height));
      }
      
      image(shorts, x, y);
      
      if(imgCount % 10 == 0) {
         if(step == 1) {
            step = 2; 
         } else {
            step = 1; 
         }
      }
      
    } else {
      //image(jump, x, y);
      image(jLimbs, x, y);
      tint(207,27,27);
      image(jTshirt, x, y);
      noTint();
      image(jShorts, x, y);
      
      //jump.resize(0, int(char_height));
    }
    
    if(jumped) {
      face_y = y - char_height*0.5;
    }
     
    image(photos[selected], face_x, face_y);
    
  }
  
  void jump() {
    
    
    y -= thrust;
    
    thrust -= gravity;
    if(thrust < 0) {
      if(y >= initY) {
        jumped = false;
        thrust = attributes[selected][1];
        gravity = 2;
        char_height /= 0.6;
        face_x = x*1.1;
        face_y = y - char_height*0.25;
      }
    }
    
  }
  
  void checkCollision() {
    if(y + char_height >= obstacles.get(obstacle_index).y && y <= obstacles.get(obstacle_index).y + obstacles.get(obstacle_index).o_height) {
       //println("y: ", y);
       //println("o.y + o_height:", obstacles.get(obstacle_index).y + obstacles.get(obstacle_index).o_height);
       fill(70);
       rect(displayWidth/2, displayHeight/2, 40, 40); 
       dead = true;
       game_over.play();
       
    }
  }
  
}

class Obstacle {
  float x,y,o_height,o_width;
  int type;
  int crow_count = 1;
  int stroke = 1;
  
  Obstacle(float _o_height, float _o_width, int i) {
   
   
   o_height = _o_height;
   o_width = _o_width;
   type = i;
   
  }
  
  void create() {
     //fill(200);
     //rect(x,y,o_width,o_height);
     if(type == 1) {
       image(auto, x, y);
     } else {
        if(crow_count % 15 == 0) { // toggle stroke images
          if(stroke == 1) {
            stroke = 2;
          } else {
            stroke = 1;
          }
          
        }
        
        if(stroke == 1) {
          image(crow1, x, y);
          
        } else {
          image(crow2, x, y); 
        }
        
        if(!dead && !paused) {
          crow_count++;
        }
        
    }
   
     
     
  }
  
  void move() {
    
     x -= o_speed;
     
  }
  
}


//Person player = new Person(0);
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Person> player = new ArrayList<Person>();


void setup() {
  
  orientation(LANDSCAPE);
  frameRate(150);
  size(displayWidth, displayHeight);
  ground_height = height/10;
  auto_height = round(height*0.35);
  auto_width = round(auto_height * 1.56); // ratio is: 1:1.56
  
  crow_width = round(auto_width * 0.4);
  crow_height = round(crow_width / 1.6);
  
  step1 = loadImage("Step1.png");
  step2 = loadImage("Step2.png");
  jump = loadImage("Jump.png");
  
  limbs1 = loadImage("Limbs1.png");
  limbs2 = loadImage("Limbs2.png");
  shorts = loadImage("Shorts.png");
  tshirt = loadImage("T-shirt.png");
  jLimbs = loadImage("JLimbs.png");
  jTshirt = loadImage("JTshirt.png");
  jShorts = loadImage("JShorts.png");
  
  
  for(int i = 0; i < players; i++) {
     player.add(new Person(i));
     set_parameters(i);
  }
  
  min_oheight = height - ground_height - player.get(0).y - player.get(0).char_height*0.6 + player.get(0).thrust;
  
  load_images();
  
  obstaclesInit();
  
  jump_sound = new SoundFile(this, "Jumping.mp3");
  game_over = new SoundFile(this, "GameOver.mp3");
  
  score_font = createFont("Helvetica.ttf", height/20);
  pause_font = createFont("Helvetica-light.ttf", height*0.06);
  title_font = createFont("Helvetica-light.ttf", height*0.08);
  attr_font = createFont("Helvetica-light.ttf", height*0.04);
  
  count = 0;
  sticks_gap = width/40;
  score_text = loadStrings("High_score.txt");
  
  high_score = int(score_text[0]);
  pause.append(width/2 - sticks_gap*0.5);
  pause.append(height/20);
  pause.append(sticks_gap);
  pause.append(height/15);
  
  auto = loadImage("Auto.png");
  crow1 = loadImage("Stroke1.png");
  crow2 = loadImage("Stroke2.png");
  bg = loadImage("Background.png");
  bg.resize(0, 1125);
  auto.resize(0, auto_height);
  crow1.resize(crow_width, 0);
  crow2.resize(crow_width, 0);
  
  
  check = loadImage("check.png");  
  
  
  
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


void set_parameters(int i) {
  
    player.get(i).char_height = (height*0.3*attributes[i][0])/183;
    
    player.get(i).x = width/20;
    player.get(i).y = height - ground_height - player.get(i).char_height;
    player.get(i).initY = height - ground_height - player.get(i).char_height;
    player.get(i).char_width = width/10;
    player.get(i).face_height = player.get(i).char_height * 0.4;
    player.get(i).face_x = player.get(i).x*1.1;
    player.get(i).face_y = player.get(i).y-player.get(i).char_height*0.25;
    
    step1.resize(0, int(player.get(i).char_height));
    step2.resize(0, int(player.get(i).char_height));
    
    limbs1.resize(0, int(player.get(i).char_height));
    limbs2.resize(0, int(player.get(i).char_height));
    shorts.resize(0, int(player.get(i).char_height));
    tshirt.resize(0, int(player.get(i).char_height));
    
    jLimbs.resize(0, int(player.get(i).char_height*0.6));
    jShorts.resize(0, int(player.get(i).char_height*0.6));
    jTshirt.resize(0, int(player.get(i).char_height*0.6));
    
}


void load_images() {
  
  for(int i = 0; i < players; i++) {
      photos[i] = loadImage(names[i] + png);
      photos[i].resize(0, int(player.get(i).face_height));
      small[i] = loadImage(names[i] + png);
      small[i].resize(0, int(height*0.18));
      big[i] = loadImage(names[i] + png);
      big[i].resize(int(width*0.25*0.6), 0); 
  }
  
}

void draw() {
  
  if(screen == 4) {
    
    background(204,238,238);
    
  } else {
    background(255); 
  }
  
  show_screen(screen);
  
  
}

void show_screen(int x) {
  
  switch(x) {
     case 1:
       main_menu();
       break;
     case 2:
       select_char();
       break;
     case 3:
       select_dress();
       break;
     case 4:
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

void select_char() {
  
  make_grid();
  show_details(selected);
  put_title("Select your character");
  
}



void put_title(String title) {
  
  textAlign(CENTER,CENTER);
  fill(0);
  stroke(0);
  textFont(title_font);
  text(title, width*0.375, height*0.1);
  textAlign(LEFT);
  line(0, height*0.2, width*0.75, height*0.2);
  line(width*0.75, 0, width*0.75, height);
  
}

void make_grid() {
  
  
  float indent = width*0.125;
  float top_gap = height*0.3;
  float pic_padding = height*0.01;
  float pic_height = height*0.15;
  float rect_h = height*0.2;

  
  fill(255);
  stroke(0);
  for(int j = 0; j < 12; j++) {
    if(j != selected) {
    
     rect(indent + (j % 4)* indent, top_gap + int(j / 4) * rect_h, indent, rect_h);
     
    }
  }
  
  stroke(0,252,14);
  rect(indent + (selected % 4)* indent, top_gap + int(selected / 4) * rect_h, indent, rect_h);
  stroke(0);
  
  //circle(indent + width*0.028, top_gap + int(pic_height)*0.5, pic_height + pic_padding);
  imageMode(CENTER);
  for(int i = 0; i < players; i++) {
    image(small[i], indent*(i+1) + indent/2, top_gap + rect_h/2);
  }
  imageMode(CORNER);
  //pic.resize(0, int(pic_height));
  
  
}

void show_details(int x) {
  
  float pic_x = width*0.75 + width*0.25*0.2;
  float pic_y = height*0.06;
  float txt_y = height*0.53;
  float txt_x = width*0.75 + width*0.0625;
  float rect_h = height*0.07;
  
  image(big[x], pic_x, pic_y);
  //big[x].resize(int(width*0.25*0.6), 0); 
  
  
  for(int i = 0; i < 4; i++) {
     stroke(255);
     fill(0);
     rect(width*0.75, txt_y + rect_h * i, width*0.125, rect_h);
     stroke(0);
     fill(255);
     rect(width*0.875, txt_y + rect_h * i, width*0.125, rect_h);
  }
  stroke(0);
  fill(255);
  textFont(attr_font);
  textAlign(CENTER, CENTER);
  text("Name", txt_x, txt_y + rect_h*0.5);
  text("Height", txt_x, txt_y + rect_h*1.5);
  text("Jump", txt_x, txt_y + rect_h*2.5);
  text("Stamina", txt_x, txt_y + rect_h*3.5);
  fill(0);
  text(names[x], txt_x + width*0.125, txt_y + rect_h*0.5);
  text(str(attributes[x][0]) + " cms", txt_x + width*0.125, txt_y + rect_h*1.5);
  text(str(attributes[x][1] * 3) + " cms", txt_x + width*0.125, txt_y + rect_h*2.5);
  text(str(attributes[x][2]) + " s", txt_x + width*0.125, txt_y + rect_h*3.5);
  textAlign(LEFT);
  imageMode(CENTER);
  image(check, width*0.875, height*0.9);
  check.resize(0, int(height*0.1));
  imageMode(CORNER);
}


void select_dress() {
  
   
   put_title("Select the clothes");
  // put_char();

}


void put_char() {
  
   float face_x = width*0.75 + width*0.25*0.2;
   float face_y = height*0.06;
   float body_x = face_x/1.1;
   //float body_y = player.get(y-player.get(i).char_height*0.25; 
   
}

void start_game() {
  
  if(!dead && !paused) {
    
    adjust_score();
    adjust_obstacles();
    
    
    if(jumped == true) {
      player.get(selected).jump(); 
    }
    
  }
  
  draw_ground();
  
  movebg();
  
  add_pause();
  
  show_score();
  
  move_obstacles();
  
  player.get(selected).create();
  
  
  
  if(paused) {
   show_options();
   
  }
  
  
}

void obstaclesInit() {
  
  o_speed = 30;
  obstacle_index = 0;
  obstacle_gap = random(width*0.75, width*1.5);
  obstacles.add(new Obstacle(auto_height, auto_width, 1));
  obstacles.get(0).x = width;
  //obstacles.get(0).y = height - ground_height - obstacles.get(0).o_height;
  obstacles.get(0).y = height - ground_height - auto_height;
  
  
}

void show_score() {
  fill(0);
  
  textFont(score_font);
  text(str(score), width/20, height/10);
  
  text(str(high_score), width*0.9, height/10);
}

void draw_ground() {
  fill(105);
  stroke(105);
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
         w = player.get(selected).char_height;
       } else {
         w = player.get(selected).char_height*0.375; 
       }
       if(obstacles.get(i).x <= player.get(selected).x + w && obstacles.get(i).x + obstacles.get(i).o_width >= player.get(selected).x) {
         player.get(selected).checkCollision();
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
     if((score + 1) % int(attributes[selected][2]) == 0) {
       
       o_speed += 5; 
      
     }
    }
}

void adjust_obstacles() {
  
    
    if(width - obstacles.get(obstacles.size()-1).x > obstacle_gap) {
      o_choice = int(random(1,3));
      if(o_choice == 1) {
        obstacles.add(new Obstacle(auto_height, auto_width, o_choice));
        obstacles.get(obstacles.size()-1).y = height - ground_height - auto_height;
      } else {
        obstacles.add(new Obstacle(crow_height, crow_width, o_choice));
        o_choice = int(random(1,3));
        if(o_choice == 1) {
          crow_auto_dif = -200;
        } else {
          crow_auto_dif = 100;
        }
          
        obstacles.get(obstacles.size()-1).y = height - ground_height - auto_height + crow_auto_dif;
      }
      obstacles.get(obstacles.size()-1).x = width;
      
      obstacle_gap = random(width*0.75, width*1.5);
      
      if(obstacles.get(0).x + obstacles.get(0).o_width < 0) {
          obstacles.remove(0); 
          obstacle_index = 0;
      }
      
      
    }
    
    if(obstacles.get(0).x + obstacles.get(0).o_width < 0) {
           
          obstacle_index = 1;
    }
  
}


void movebg() {
  
  //tint(255, 200);
    image(bg, 0 - x, 50);
    image(bg, bg.width - x, 50);
    //tint(255,255);
    if(!dead && !paused) {
      x += 10;
    }
    
    if(bg.width - x < 0) {
      
      x = 0;
      
    }
    
}
  
  

void add_pause() {
   
   fill(0);
   rect(pause.get(0), pause.get(1), width/150, pause.get(3));
   rect(pause.get(0) + sticks_gap - width/150, pause.get(1), width/150, pause.get(3));
   
}

void show_options() {
  
  fill(255,255,255,150);
  strokeWeight(2);
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
    
    // check button
    
     if(mouseX >= width*0.875 - 0.55*int(height*0.1) && mouseX <= width*0.875 + 0.55*int(height*0.1) && mouseY >= height*0.9 - 0.5*int(height*0.1) && mouseY <= height*0.9 + 0.5*int(height*0.1)) {
        
       
        jumped = false;
        set_parameters(selected);
        player.get(selected).thrust = attributes[selected][1];
        x = 0;
        screen = 3;
        
     } else {
        
        float indent = width*0.125;
        float top_gap = height*0.3;
        float rect_h = height*0.2;
        float box_x;
        float box_y;

        for(int j = 0; j < players; j++) {
          box_x = indent + (j % 4)* indent;
          box_y = top_gap + int(j / 4);
          
          if(mouseX >= box_x && mouseX < box_x + indent && mouseY >= box_y && mouseY < box_y + rect_h) {
             
            selected = j;
            
            break;
           
          }
        }
       
       
     }
     
     
      
      break;
      
    case 3:
    
      screen = 4;
      break;
    
    case 4:
    
      
      // pause button
      if(mouseX >= pause.get(0) && mouseX <= pause.get(0) + pause.get(2) && mouseY >= pause.get(1) && mouseY <= pause.get(1) + pause.get(3)) {
        
        paused = true;
        
      }
      
      if(!paused) {
        
        if(!dead) {
          
          if(player.get(selected).y >= player.get(selected).initY) {
            
            jumped = true;
            
            player.get(selected).face_x = player.get(selected).x + player.get(selected).char_height*0.45;
            player.get(selected).char_height *= 0.6;
            jump_sound.play();
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
