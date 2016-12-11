//List ADT written by Jared Penner
class List{


   // Fields
   private Node front;
   private Node back;
   private Node cursor;
   private int length;
   private int index;

   // Constructor
   List() { 
      front = back = null; 
      length = 0;
   }


   // Access Functions --------------------------------------------------------

   // isEmpty()
   // Returns true if this Queue is empty, false otherwise.
   boolean isEmpty() { 
      return length==0; 
   }

   // length()
   // Returns length of this List.
   int length() { 
      return length; 
   }

   // front() 
   // Returns front element.
   // Pre: !this.isEmpty()
   int front(){
      if( this.isEmpty() ){
         throw new RuntimeException(
            "List Error: front() called on empty List");
      }
      return front.data;
   }

   // back()
   //returns back element.
   //pre: !this.isEmpty()
   int back(){
      if( this.isEmpty() ){
         throw new RuntimeException(
            "List Error: back() called on empty List");
      }
      return back.data;
   }

   // get()
   // Returns cursor element.
   //Pre: length()>0, index >=0
   int get(){
      if( this.isEmpty()){
         throw new RuntimeException(
            "List Error: get() called on an empty List");
      }
      if(index == -1){
         throw new RuntimeException(
            "List Error: get() called on an undefined cursor");
      }
      return cursor.data;
   }

   // index()
   // If cursor is defined, returns the index of the cursor element,
   // otherwise returns -1
   int index(){
      if(cursor == null){
         return -1;
      }
      index = 0;
      Node temp;
      temp = front;
      while(temp != cursor){
         temp = temp.next;
         index ++;
      }
      return index;
   }

   // equals(List L)
   // Returns true if this List and L are the same integer sequence.
   boolean equals(List L){
      Node temp1;
      Node temp2;

      temp1 = this.front;
      temp2 = L.front;

      while(temp1 != null){
         if(temp1.data != temp2.data){
            return false;
         }
         temp1 = temp1.next;
         temp2 = temp2.next;
      }
      if(temp2 != null){
         return false;
      }
      return true;
   }

   // Manipulation Procedures -------------------------------------------------

   // append()
   // Appends data to back of this Queue.
   void append(int data){
      Node N = new Node(data);
      if( this.isEmpty() ) { 
         front = back = N;
      }else{ 
         back.next = N; 
         N.prev = back;
         back = N;
      }
      length++;
   }

   // prepend()
   //Insert a new element into this List.  If List is non-empty,
   // insertion takes place before front element.
   void prepend(int data){
      Node N = new Node(data);
      if(this.isEmpty()){
         front = back = N;
      }else{
         N.next = front;
         front.prev = N;
         front = N;
      }
      length ++;
   }

   // insertBefore(int data)
   // Insert new element before cursor.
   // Pre: length()>0, index()>=0
   void insertBefore(int data){
      if(length == 0){
         throw new RuntimeException(
            "List Error: insertBefore() called on an empty List");
      }
      if(index == -1){
         throw new RuntimeException(
            "List Error: insertBefore() called on an undefined cursor");
      }

      if(index() > 0){
         Node temp;
         Node N = new Node(data);
         temp = cursor.prev;
         temp.next = N;
         N.prev = temp;
         cursor.prev = N;
         N.next = cursor;
         length ++;
      }else{
         prepend(data);

      }
   }

   // insertAfter(int data)
   // Insert new element after cursor.
   // Pre: length()>0, index()>=0
   void insertAfter(int data){
      if(length == 0){
         throw new RuntimeException(
            "List Error: insertAfter() called on an empty List");
      }
      if(index == -1){
         throw new RuntimeException(
            "List Error: insertAfter() called on an undefined cursor");
      }
      if(cursor.next != null){
         Node temp;
         Node N = new Node(data);
         temp = cursor.next;
         temp.prev = N;
         N.next = temp;
         cursor.next = N;
         N.prev = cursor;
         length ++;
      }else{
         append(data);
      }
   }

   // deleteFront()
   // Deletes the front element.
   // Pre: length()>0
   void deleteFront(){
      if(length == 0){
         throw new RuntimeException(
            "List Error: deleteFront() called on an empty List");
      }
      if(length > 0){
        if(index() == 0){
          cursor = null;
          index = -1;
        }
        if(back == front) front = back = null;
        if(front != null) front = front.next;
        if(front != null) front.prev = null;
        length --;
      }
   }

   // deleteBack()
   // Deletes the back element
   // Pre: length()>0
   void deleteBack(){
      if(length == 0){
         throw new RuntimeException(
            "List Error: deleteBack() called on an empty List");
      }
      if(length() > 0){
        if(index() == length - 1){
          cursor = null;
          index = -1;
        }
        if(back == front) front = back = null;
        if(back != null) back = back.prev;
        if(back != null) back.next = null;
        length --;
      }
   }

   // delete()
   // Deletes the cursor element, making cursor undefined
   // Pre: length()>0, index()>=0
   void delete(){
      if(length == 0){
         throw new RuntimeException(
            "List Error: delete() called on an empty List");
      }
      if(index == -1){
         throw new RuntimeException(
            "List Error: delete() called on an undefined cursor");
      }
      cursor.prev.next = cursor.next;
      cursor.next.prev = cursor.prev;
      cursor = null;
      length --;
   }

   // clear()
   // Resets this List to its original empty state
   void clear(){
      front = back = cursor = null;
      length = 0;
   }

   // moveFront()
   // If List is non-empty, places the cursor under the front element,
   // otherwise does nothing
   void moveFront(){
      cursor = front;
   }

   // moveBack()
   // If List is non-empty, places the cursor under the back element,
   // otherwise does nothing
   void moveBack(){
      cursor = back;
   }

   //void movePrev() 
   // If cursor is defined and not at front, moves cursor one step toward
   // front of this List, if cursor is defined and at front, cursor becomes
   // undefined, if cursor is undefined does nothing.
   void movePrev(){
       cursor = cursor.prev;
   }

   // moveNext()
   // If cursor is defined and not at back, moves cursor one step toward
   // back of this List, if cursor is defined and at back, cursor becomes
   // undefined, if cursor is undefined does nothing.
   void moveNext(){
      cursor = cursor.next;
   }

   // Other Functions ---------------------------------------------------------

   // toString()
   // Overides Object's toString() method.
   public String toString(){
      StringBuffer sb = new StringBuffer();
      Node N = front;
      while(N!=null){
         sb.append(" ");
         sb.append(N.toString());
         N = N.next;
      }
      return new String(sb);
   }

   // copy()
   // Returns a new List identical to this List.
   List copy(){
      List Q = new List();
      Node N = this.front;

      while( N!=null ){
         Q.append(N.data);
         N = N.next;
      }
      return Q;
   }
   
   //concat(List L)
   // Returns a new List which is the concatenation of
   // this list followed by L. The cursor in the new List
   // is undefined, regardless of the states of the cursors
   // in this List and L. The states of this List and L are
   // unchanged.
   List concat(List L){
      List Q = new List();
      Q = copy();
      Node temp;
      temp = L.front;
      while(temp != null){
         Q.append(temp.data);
         temp = temp.next;
      }
      return Q;
   }  
}