
import cassette.audiofiles.SoundFile;

SoundFile sound;
float ground_height;
boolean jumped = false;
float obstacle_gap;
int score = 0;
int high_score = 0;
int gameState = 1;
PFont score_font;
PFont pause_font;
int count;
int o_speed = 20;
float sticks_gap;
FloatList pause = new FloatList();
boolean dead = false;
boolean paused = false;
int screen = 1;


class Person {
  String name;
  float mass, person_height, reaction_time, char_height, char_width, x, y, initY;
  float thrust = 35;
  float gravity = 2;
  
  Person(String _name, float _mass, float _person_height, float _reaction_time) {
    name = _name;
    mass = _mass;
    person_height = _person_height;
    reaction_time = _reaction_time;
    
    
     
  }
  
  void create() {
    fill(0);
    rect(x,y, char_width, char_height);
    fill(100);
    rect(x,y+char_height/3,x/4,char_height/3);
  }
  
  void jump() {
    
    
    y -= thrust;
    thrust -= gravity;
    if(thrust < 0) {
      if(y >= initY) {
        jumped = false;
        thrust = 35;
        gravity = 2;
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
  player.char_height = height*0.25;
  player.x = width/20;
  player.y = height - ground_height - player.char_height;
  player.initY = height - ground_height - player.char_height;
  player.char_width = width/10;
  obstaclesInit();
  
  sound = new SoundFile(this, "Jumping.mp3");
  
  score_font = createFont("Helvetica.ttf", height/20);
  pause_font = createFont("Helvetica-light.ttf", height*0.06);
  count = 0;
  sticks_gap = width/40;
  
  pause.append(width/2 - sticks_gap*0.5);
  pause.append(height/20);
  pause.append(sticks_gap);
  pause.append(height/15);
  
 
  
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
  obstacle_gap = random(width*0.33, width*0.75);
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
    
    if(i == 0) {
       if(obstacles.get(i).x <= width/20 + width/10 && obstacles.get(i).x + obstacles.get(i).o_width >= width/20) {
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
     }
     if((score + 1) % 20 == 0) {
       
       o_speed += 5; 
      
     }
    }
}

void adjust_obstacles() {
    if(width - obstacles.get(obstacles.size()-1).x > obstacle_gap) {
      obstacles.add(new Obstacle(random(100,200), random(100,150)));
      obstacles.get(obstacles.size()-1).x = width;
      obstacles.get(obstacles.size()-1).y = height - ground_height - obstacles.get(obstacles.size()-1).o_height;
      obstacle_gap = random(width*0.4, width*0.8);
    }
    
    if(obstacles.size() > 0 && obstacles.get(0).x + obstacles.get(0).o_width < 0) {
        obstacles.remove(0); 
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
        
            jumped = true;
            
            sound.play();
            
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
