//Snake game written by Jared Penner and Kaio Barbosa

public static final int NIL = -1;
public static final int INF = -2;
public static final int WHITE = -3;
public static final int GRAY = -4;
public static final int BLACK = -5;
public static final int RED = -6;
public static final int FACE = -7;
public static final int WALL = -8;

void setup(){
  size(400, 400);
  fill(255, 255, 255);
  stroke(0, 0, 0);
  strokeWeight(1);
  for(i = 1; i <= snakeSize; i ++){
    att.prepend(i);
  }
  G.createSnake(att);
  
  G.randomWall(percentWalled);
  
}

float percentWalled = .3;
int xSize = 400, ySize = 400;
int high = 30;
int wide = 30;
int squareSize;
int player = high * wide;  //Player starting point (Bottom right corner)
int snakeSize = 5;         //Snake starting size
int snakeCounter = 10;
int score = 0;
boolean playing = false;
boolean played = false;

int delay = 0;             // Delay counter for the Delay Powerup
boolean delayPowerUp = false;
int dPowerUpPos;
int delayStrength = 100;
int moveCounter = 10;


int i, j, v;
Graph G = new Graph(high, wide);
List att = new List();
List path = new List(); // Path from source to head of snake


void draw(){
  
  if(playing == false)menuScreen();

  
  if(playing) playGame();
  
  //played = false;
 
}

void playGame(){
    background(0, 0, 0);
    fill(255, 255, 255);
 
    if(delayPowerUp == false) delayPowerUp();
    if(keyPressed && moveCounter == 0){
      move();
      if(player == dPowerUpPos && delayPowerUp){
        delay = delayStrength;
        delayPowerUp = false;
      }
      moveCounter = 10;  //Creates a pause between player movements
    }
    if(snakeCounter <= 0){  //The snake moves when this condition is true
      path.clear();
      G.BFS(player);
      G.getPath(path, G.snake.front());
      
      path.moveBack();
      path.movePrev();
      if(path.get() != player && delay == 0) G.moveSnake(path.get());
      snakeCounter = 13;
      if(path.get() == player){
        playing = false;
        played = true;
        return;
      }
    }     
    if(delay > 0) delay --;  //If there is a delay power up in effect, decrement the counter
    if(moveCounter > 0) moveCounter--;  //Creates a pause between the player's moves
    if(snakeCounter > 0) snakeCounter --;
    createGame();
}

void gameOver(){
  background(0, 0, 0);
  fill(255, 0, 0);
  textSize(40);
  textAlign(CENTER, BOTTOM);
  text("Game Over\nClick to Continue", xSize/2, ySize/3);
  textAlign(CENTER, CENTER);
  text("Score: " + score, xSize/2, ySize/2);
  //println("game over");
  //println(score);
  if(mousePressed){
    reset();
    delay(100);
  }
}

void reset(){
  G.removeSnake();
  att.clear();
  for(i = 1; i <= snakeSize; i++)att.prepend(i);
  G.createSnake(att);
  G.removeWalls();
  G.randomWall(percentWalled);
  score = 0;
  player = high*wide;
  played = false;
  
}

void menuScreen(){
  if(played){
    gameOver();
  }else{
    fill(255, 0, 0);
    rect(0, 0, xSize/3, ySize);
    fill(0, 0, 0);
    rect(xSize/3, 0, xSize/3, ySize);
    fill(255, 0, 0);
    rect(2*xSize/3, 0, xSize/3, ySize);
    textSize(25);
    textAlign(CENTER);
    fill(0, 0, 0);
    text("10x10", xSize/6, ySize/8);
    fill(255, 0, 0);
    text("20x20", xSize/2, ySize/8);
    fill(0,0,0);
    text("30x30", 5*xSize/6, ySize/8);
    if(mousePressed && mouseX < xSize/3 && mouseX > 0){
     // println(1);
      percentWalled = .2;
      remake(10, percentWalled);
      playing = true;
    }else if(mousePressed && mouseX > xSize/3 && mouseX < 2*xSize/3){
      //println(2);
      percentWalled = .3;
      remake(20, percentWalled);
      playing = true;
    }else if(mousePressed && mouseX > 2*xSize/3 && mouseX < xSize){
     // println(3);
      percentWalled = .3;
      remake(30, percentWalled);
      playing = true;
    }
  }
}

void remake(int size, float fillPercent){
  if(size >= 50){
    surface.setSize(700, 700);
    xSize = ySize = 700;
  }
  att.clear();
  for(i = 1; i <= snakeSize; i ++){
    att.prepend(i);
  }

  high = size;
  wide = size;
  if(G != null) G.clearGraph();
  G = new Graph(high, wide);
  G.createSnake(att);
  G.randomWall(fillPercent);
  player = high*wide;
  squareSize = min(xSize/wide, ySize/high);
  //println(wide+", " + high);
}


void moveUp(){
  if(player > wide && G.snake.front() != player- wide){
    if(G.col[player - wide] != WALL && G.col[player - wide] != RED)player -= wide;
  }
}

void moveDown(){
  if(player < G.verts - wide && G.snake.front() != player+ wide){
    if(G.col[player + wide] != WALL && G.col[player + wide] != RED)player += wide;
  }
}

void moveRight(){
  if(player % wide != 0 && G.snake.front() != player+ 1){
    if(G.col[player + 1] != WALL && G.col[player + 1] != RED)player ++;
  }
}

void moveLeft(){
  if(player % wide != 1 && G.snake.front() != player- 1){
    if(G.col[player - 1] != WALL && G.col[player - 1] != RED) player --;
  }
}

// Moves the player and increments score
void move(){
  if(keyCode == RIGHT) moveRight();
  if(keyCode == LEFT) moveLeft();
  if(keyCode == UP) moveUp();
  if(keyCode == DOWN) moveDown();
  score ++;
}

// createGame() draws the playing enviornment
void createGame(){
  for(i = 0; i < high; i ++){
    for(j = 0; j < wide; j ++){
      v = i*wide + j + 1;
      
      if(v == player){
        fill(0, 0, 255);
      }else if(G.col[v] == RED){
        fill(255, 0, 0);
      }else if(v == G.snake.front()){
        fill(150, 0, 0);
      }else if(G.col[v] == WALL){
        fill(0, 0, 0);
      }else if(delayPowerUp && v == dPowerUpPos){
        fill(0, 255, 0);
      }
      rect(j*squareSize, i*squareSize, squareSize, squareSize);
      fill(255, 255, 255);
    }
  }
}

void delayPowerUp(){
  dPowerUpPos = floor(random(1, G.getOrder()));
  //println(G.snake.front());
  if(G.col[dPowerUpPos] == WHITE && dPowerUpPos != player && dPowerUpPos != G.snake.front() && G.dist[dPowerUpPos] != INF) delayPowerUp = true;
  
}