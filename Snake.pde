//Snake game written by Jared Penner

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
  strokeWeight(3);
  for(i = 1; i <= snakeSize; i ++){
    att.prepend(i);
  }
  G.createSnake(att);
  G.createAdj();
  
  G.randomWall(percentWalled);
  
}

float percentWalled = .2;
int xSize = 400, ySize = 400;
int high = 15;
int wide = 15;
int squareSize = min(xSize/wide, ySize/high);
int player = high * wide;  //Player starting point (Bottom right corner)
int snakeSize = 5;         //Snake starting size
int snakeCounter = 10;
int score = 0;
boolean playing = true;
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
  
  //if(playing == false)menuScreen();
  
  if(playing) playGame();

  if(played) gameOver();
  playing = true;
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
    if(snakeCounter == 0){  //The snake moves when this condition is true
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
    if(snakeCounter > 0) snakeCounter--;
    createGame();
}

void gameOver(){
  background(0, 0, 0);
  fill(255, 0, 0);
  textSize(40);
  textAlign(CENTER, BOTTOM);
  text("Game Over", xSize/2, ySize/4);
  textAlign(CENTER, CENTER);
  text("Score: " + score, xSize/2, ySize/2);
  println("game over");
  println(score);
  delay(5000);
  reset();
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
  if(played) gameOver();
  
  playing = true;
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
  
  if(G.col[dPowerUpPos] == WHITE && dPowerUpPos != player && dPowerUpPos != G.snake.front() && G.dist[dPowerUpPos] != INF) delayPowerUp = true;
  
}