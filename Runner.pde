
import cassette.audiofiles.SoundFile;
SoundFile sound;
float ground_height;
boolean jumped = false;
float obstacle_gap;
int score = 0;
int gameState = 1;
PFont font;
int count;
int o_speed = 20;


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
       
       o_speed = 0; 
       
       gameState = 0;
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
  
  font = createFont("Helvetica.vlw", height/20);
  count = 0;
  
 
  
}

void draw() {
  background(255);
  if(gameState == 1) {
    count++;
    if(count % 60 == 0) {
     score++; 
     //println(count,"count");
     if((score + 1) % 20 == 0) {
       
       o_speed += 5; 
      
     }
    } 
    
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
  
  fill(0);
  textAlign(CENTER);
  textFont(font);
  text(str(score), displayWidth/2, displayHeight/10);
  fill(100);
  rect(0, height - ground_height, width, ground_height);
  
  player.create();
  if(jumped == true) {
    player.jump(); 
  }
  for(int i = 0; i < obstacles.size(); i++) {
    obstacles.get(i).create();
    obstacles.get(i).move();
    if(i == 0) {
       if(obstacles.get(i).x <= width/20 + width/10 && obstacles.get(i).x + obstacles.get(i).o_width >= width/20) {
         player.checkCollision();
       } 
    }
    
  }  
  
  
  
}

void obstaclesInit() {
  o_speed = 20;
  obstacle_gap = random(width*0.33, width*0.75);
  obstacles.add(new Obstacle(random(100,200), random(100,150)));
  obstacles.get(0).x = width;
  obstacles.get(0).y = height - ground_height - obstacles.get(0).o_height;
  
}

void mousePressed() {
  if(gameState == 1) {
    jumped = true;
    //sound.stop();
    sound.play();
  } else {
   
   score = 0;
   count = 0;
   obstacles.clear();
   obstaclesInit();
   gameState = 1; 
   
  }
 
}
