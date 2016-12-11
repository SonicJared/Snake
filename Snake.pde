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
  
  G.createHorWall(13, 17);
  G.createHorWall(35, 40);
  G.createHorWall(42, 43);
  G.createVertWall(22, 32);
  
}

int xSize = 400, ySize = 400;
int high = 10;
int wide = 10;
int squareSize = min(xSize/wide, ySize/high);
int player = high * wide;  //Player starting point (Bottom right corner)
int snakeSize = 5;         //Snake starting size
int score = 0;


int i, j, v;
Graph G = new Graph(high, wide);
List att = new List();
List path = new List(); // Path from source to head of snake


void draw(){
  
    background(0, 0, 0);
    fill(255, 255, 255);
 
    if(keyPressed) move();
    path.clear();
    G.BFS(player);
    G.getPath(path, G.snake.front());
    
    path.moveBack();
    path.movePrev();

    if(path.get() != player) G.moveSnake(path.get());
    delay(500);      
    createGame();

}

void moveUp(){
  if(player > wide && G.snake.front() != player- wide){
    if(G.col[player - wide] != WALL)player -= wide;
  }
}

void moveDown(){
  if(player < G.verts - wide && G.snake.front() != player+ wide){
    if(G.col[player + wide] != WALL)player += wide;
  }
}

void moveRight(){
  if(player % wide != 0 && G.snake.front() != player+ 1){
    if(G.col[player + 1] != WALL)player ++;
  }
}

void moveLeft(){
  if(player % wide != 1 && G.snake.front() != player- 1){
    if(G.col[player - 1] != WALL) player --;
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
      
      if(v == G.source){
        fill(0, 0, 255);
      }else if(G.col[v] == RED){
        fill(255, 0, 0);
      }else if(v == G.snake.front()){
        fill(150, 0, 0);
      }else if(G.col[v] == WALL){
        fill(0, 0, 0);
      }
      rect(j*squareSize, i*squareSize, squareSize, squareSize);
      fill(255, 255, 255);
    }
  }
}