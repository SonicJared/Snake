class Graph{
  
  public static final int NIL = -1;
  public static final int INF = -2;
  public static final int WHITE = -3;
  public static final int GRAY = -4;
  public static final int BLACK = -5;
  public static final int RED = -6;
  public static final int FACE = -7;
  public static final int WALL = -8;
  
  int verts, edges, source;
  List[] adj;
  List snake;
  int[] col, parent, dist;
  
  
  // Constructor---------------
  Graph(int high, int wide){
    verts = high * wide;
    edges = 0;
    source = NIL;
    
    adj = new List[verts + 1];
    col = new int[verts + 1];
    parent = new int[verts + 1];
    dist = new int[verts + 1];
    
    for(i = 1; i <= verts; i++){
      col[i] = WHITE;
      parent[i] = NIL;
      dist[i] = INF;
      adj[i] = new List();
    }
    
  }
  
  // Access Functions
  
  int getOrder(){ //Returns the order of the graph
    return verts;
  }
  
  int getSize(){  //Returns the size of the graph
    return edges;
  }
  
  int getSource(){ //Returns the vertex s most recently used in BFS
    return source;
  }
  
  int getParent(int u){ // Returns the parent vertex of u
    return parent[u];
  }
  
  int getDist(int u){ // Returns the shortest path from source to u
    return dist[u];
  }
  
  void getPath(List L, int u){ // Appends the shortest path from s to u on the list L
    L.prepend(u);
    if(parent[u] != NIL){
      getPath(L, parent[u]);
    }
  }
  
  /*** Manipulation procedures ***/
  void addEdge(int u, int v){  //Adds an edge from u to v
    addArc(u, v);
    addArc(v, u);
    edges --;
  }
  
  void addArc(int u, int v){   //Adds a directed edge from u to v
    if(adj[u].length() == 0){
      adj[u].prepend(v);
    }else{
      adj[u].moveBack();
      while(adj[u].index() >= 0){
              if(adj[u].get() < v){
                adj[u].insertAfter(v);
                break;
              }
              adj[u].movePrev();
      }
      if(adj[u].index() == -1) adj[u].prepend(v);
    }
    edges ++;
  }
  
  void BFS(int s){ //Performs Breadth First Search with s as the source
    List Q = new List();
    for(int i = 1; i <= verts; i++){
        if(col[i] != RED){
          col[i] = WHITE;
          dist[i] = INF;
          parent[i] = NIL;
      }
    }
    Q.append(s);
    int d = 0;
    int u, v;
    source = s;
    col[s] = GRAY;
    dist[s] = d;
  
    while(Q.length() > 0){
          Q.moveFront();
          Q.index();
          u = Q.get();
          Q.deleteFront();
          adj[u].moveFront();
          while(adj[u].index() != -1){
              v = adj[u].get();
              if(col[v] == WHITE){
                col[v] = GRAY;
                dist[v] = dist[u] + 1;
                parent[v] = u;
                Q.append(v);
              }
              adj[u].moveNext();
              col[u] = BLACK;
          }
    }
  }
  
  void createAdj(){  //Initializes adjacencies for a rectangular graph
    for(i = 1; i <= verts; i++){
      if(i <= verts - wide){
        addEdge(i, i + wide);
      }
      if(i % wide != 0){
        addEdge(i, (i + 1));
      }
    }
  }
  
  void createSnake(List L){ // Sets the vertecies in L to red, and makes them the "Snake"
                            // The head of the snake is not red, because it must be recognized by BFS
    snake = L;
    snake.moveFront();
    col[snake.get()] = FACE;
    snake.moveNext();
    while(snake.index() != -1){
      col[snake.get()] = RED;
      snake.moveNext();
    }
  }
  
  void moveSnake(int v){ // Moves the snake to v, and deletes the back end of the snake. Turns v red and the deleted
                         // vertex white
    snake.prepend(v);
    col[v] = FACE;
    snake.moveFront();
    snake.moveNext();
    col[snake.get()] = RED;
    
    col[snake.back()] = WHITE;
    snake.deleteBack();
  }
  
  /*** Other operations ***/
  void printGraph(){  //Prints the adjacency list of G
    for(i = 1; i <= verts; i++){
      System.out.println(i + ": " + adj[i]); 
    }
  
  }
  //Graph copyGraph();
  
  
}