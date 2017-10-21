PFont font;

//Sizes
 //Button width and height
int butSizeX = 270;
int butSizeY = 30;

int pointSize = 18;

int numOfBut = 7;
int addPointButX, addPointButY;
int clearSceneButX, clearSceneButY;
int randomPointsButX,randomPointsButY;
int movePointButX,movePointButY;
int deletePointButX,deletePointButY;
int giftWrapButX, giftWrapButY;
int grahamScButX, grahamScButY;

//Modes
boolean moveMode = false;
boolean deleteMode = false;
boolean addMode = false;
boolean overButtons = false;

color currentColor = color(255);
color highlightButColor = color(204);

//Points
ArrayList<PVector> points; 
int numberOfRandomPoints = 3;
PVector changingPoint;

//Convex hull data structures
PVector maxXPoint;
PVector[] CHull;
PVector A;
PVector B;
PVector C;
void setup() {
       //size(1280, 800);
       size(960, 540);
       clearSceneButX = 0;
       clearSceneButY = 0;
       
       randomPointsButX =clearSceneButX  ;
       randomPointsButY = clearSceneButY  + butSizeY;
       
       addPointButX = randomPointsButX;
       addPointButY = randomPointsButY+ butSizeY;
       
       movePointButX = addPointButX;
       movePointButY = addPointButY + butSizeY;
       
       deletePointButX = movePointButX;
       deletePointButY = movePointButY + butSizeY;
       
       giftWrapButX = deletePointButX;
       giftWrapButY = deletePointButY + butSizeY;
       
       grahamScButX = giftWrapButX;
       grahamScButY = giftWrapButY + butSizeY;
       
       font = createFont("Courier New Bold", 16);
       textFont(font); 
       
       points = new ArrayList<PVector>();
       
}

void draw(){
  background(currentColor);
  stroke(0);
  
  //Rendering rectangles as buttons
  fill(currentColor);
  rect(clearSceneButX, clearSceneButY, butSizeX, butSizeY);
  rect(randomPointsButX, randomPointsButY, butSizeX, butSizeY);
  
  if (addMode) {
    fill(highlightButColor);
  }else {
    fill(currentColor);
  }
  rect(addPointButX, addPointButY, butSizeX, butSizeY);
  
  if (moveMode) {
    fill(highlightButColor);
  }else {
    fill(currentColor);
  }
  rect(movePointButX, movePointButY, butSizeX, butSizeY);
  
  if (deleteMode) {
    fill(highlightButColor);
  }else {
    fill(currentColor);
  }
  rect(deletePointButX, deletePointButY, butSizeX, butSizeY);
  
  fill(currentColor);
  rect(giftWrapButX, giftWrapButY, butSizeX, butSizeY);
  rect(grahamScButX, grahamScButY, butSizeX, butSizeY);
  
  //Adding names to buttons
  fill(0);
  text("Clear scene", clearSceneButX + 5,clearSceneButY+20);
  text("Random points", randomPointsButX + 5,randomPointsButY+20);
  text("Add point mode", addPointButX + 5,addPointButY+20);
  text("Move point mode", movePointButX + 5,movePointButY+20);
  text("Delete point mode", deletePointButX + 5,deletePointButY+20);
  text("Gift Wrapping - convex hull", giftWrapButX + 5,giftWrapButY+20);
  text("Graham Scan   - convex hull", grahamScButX + 5,grahamScButY+20);
  
 
  
  
  //Printing points
  for (PVector p : points) {
      if(maxXPoint != null && p == maxXPoint){
        fill(color(#2BFA94));
        ellipse(p.x, p.y, pointSize, pointSize);
      }else{
        fill(color(#3FCBF0));
        ellipse(p.x, p.y, pointSize, pointSize);
      }
  }
  
  if(CHull != null){
    for (int i = 0; i< CHull.length - 1; i++) {
      if(CHull[i] != null && CHull[i+1] != null){
         line( CHull[i].x, CHull[i].y, CHull[i+1].x, CHull[i+1].y );
      }
    }
  }
  fill(0);
  if(A!= null){
    text("A", A.x,A.y);
  }
  if(B!= null){
    text("B", B.x, B.y);
  }
  if(C!= null){
     text("C", C.x, C.y);
  }
  
  
}

void mousePressed() {
  
  //If you click into Buttons area
  if(inButtonsArea(mouseX, mouseY)){
    if ( overBut(addPointButX, addPointButY) ) {
      setModes(true, false, false);
    } else if ( overBut(movePointButX, movePointButY) ) {
      setModes(false, false, true);
    } else if ( overBut(deletePointButX, deletePointButY) ) {
      setModes(false, true, false);
    }else if (overBut(clearSceneButX, clearSceneButY)) {
      setModes(false, false, false);
      removeAllPoints();
    }else if (overBut(randomPointsButX, randomPointsButY)) {
      setModes(false, false, false);
      addRandomPoints();
    }else if (overBut(giftWrapButX, giftWrapButY)) {
      setModes(false, false, false);
      giftWrapping();
    }else if (overBut(grahamScButX, grahamScButY)) {
      setModes(false, false, false);
    }
  }
  
  
  
  //If you click outside buttons area
  if(!inButtonsArea(mouseX, mouseY)){
    if (addMode == true) {
       addPoint();
    }
    if (deleteMode == true) {
        deletePoint();
    }
    if (moveMode == true) {
        movePoint();
    }
  }
  
}

void giftWrapping(){

  if(points.size() >= 3){
    println("Gift wrapping algorithm for Convex Hull");
    ArrayList<PVector> tempPoints = new ArrayList<PVector>(points);
    
    CHull = new PVector[tempPoints.size()+1];
    maxXPoint = getMaxPointX();
    A = CHull[0] = maxXPoint;
    
    PVector basePoint = new PVector(maxXPoint.x, 1);
    B = basePoint;
    
    int counter = 1;
    
    tempPoints.remove(maxXPoint);
    
    PVector pointMinAngle = null;
    float minAngle = 360;
    
    PVector vec1 = new PVector(basePoint.x - maxXPoint.x, basePoint.y - maxXPoint.y);
    float length1 = sqrt(sq(vec1.x) + sq(vec1.y));
    
    PVector vec2 = null;
        
    for(int i = 0; i < tempPoints.size(); i++){
      PVector p = tempPoints.get(i);
      vec2 = new PVector(p.x - maxXPoint.x, p.y - maxXPoint.y);

      float length2 = sqrt(sq(vec2.x) + sq(vec2.y));
      float angle = degrees(acos((vec1.x * vec2.x + vec1.y * vec2.y)/ (length1 * length2)));
      
      if(angle <= minAngle){
        pointMinAngle = new PVector(p.x, p.y);
        minAngle= angle;
      }
      CHull[counter] = pointMinAngle;   
      
    }
    tempPoints.remove(pointMinAngle);
      
    println("New part");
    
    while(tempPoints.size()>0){
      B = CHull[counter];
      A = CHull[counter-1];
      counter++;
      
      pointMinAngle = null;
      minAngle = 360;
      
      vec1 = new PVector(A.x - B.x, A.y - B.y  );//BA
      line( B.x, B.y, A.x, A.y );
      length1 = sqrt(sq(vec1.x) + sq(vec1.y));
      
      float angle = 360;
      
      for(int i = 0; i < tempPoints.size(); i++){
        PVector p = tempPoints.get(i);
        
        vec2 = new PVector(p.x - B.x, p.y - B.y); //Bp ...p possible solution
        float length2 = sqrt(sq(vec2.x) + sq(vec2.y));
        angle = 180 - degrees(acos((vec1.x * vec2.x + vec1.y * vec2.y)/ (length1 * length2)));
        
        if(angle <= minAngle){
          pointMinAngle = new PVector(p.x, p.y);
          minAngle= angle;
        }
         
      }
      // stopping values ...when the smallest angle is with the first point 
      vec2 = new PVector(maxXPoint.x - B.x, maxXPoint.y - B.y); //BMaxXPoint 
      float length2 = sqrt(sq(vec2.x) + sq(vec2.y));
      float maxXAngle = 180 - degrees(acos((vec1.x * vec2.x + vec1.y * vec2.y)/ (length1 * length2)));
      
      //when the condition for stopping is fullfilled
      if(maxXAngle < minAngle){
        tempPoints.clear();
        CHull[counter] = maxXPoint;
      }else{
        CHull[counter] = pointMinAngle; 
        tempPoints.remove(pointMinAngle);
      }
    }    
    
  }
  
}


void mouseReleased(){
  //NEED to have point to be moved, can not move it to button area
  if(moveMode == true &&  changingPoint != null && !inButtonsArea(mouseX, mouseY)){
    points.add(new PVector(mouseX, mouseY));
    
    //setting changingPoint to null after editation of point
    changingPoint = null;
  }
}

void movePoint(){
  deletePoint();
}

void deletePoint(){
  for(int i = 0; i < points.size(); i++){
    float distX = points.get(i).x - mouseX;
    float distY = points.get(i).y - mouseY;
    boolean isPoint = sqrt(sq(distX) + sq(distY)) < pointSize/2 ;
    if(isPoint){
      if(moveMode){
        changingPoint = new PVector(points.get(i).x, points.get(i).y);
      }
      points.remove(points.get(i));
      println("DELETING POINT");
      break;
    }
  }  
}

//Adding single point
void addPoint(){
  println("ADDING POINT");
  points.add(new PVector(mouseX, mouseY));
}

//Adding multiple random points to screen
void addRandomPoints(){
  for(int i = 1; i <= numberOfRandomPoints; i++){
    float x = random(pointSize/2, width - pointSize/2 );
    float y = random(pointSize/2, height - pointSize/2);
    
    if(inButtonsArea(x, y)){
      x = butSizeX + x;
      y = butSizeY + y;
    }
    points.add(new PVector(x, y));
  }
  println("ADDING RANDOM POINTS");
  
}

//Removing points from screnn
void removeAllPoints(){
  points.clear();
  println("CLEARING THE SCENE");
}

//Are you over button?
boolean overBut(int x, int y) {
  if (mouseX >= x && mouseX <= x + butSizeX
      && mouseY >= y && mouseY <= y + butSizeY) {
    return true;
  } else {
    return false;
  }
}

//Whether you are in Buttons area 
boolean inButtonsArea(float x, float y){
  if(x < butSizeX + pointSize && y < butSizeY * numOfBut + pointSize){
    return true;
  }
  return false;
}

//Setting modes of app 
void setModes(boolean add, boolean delete, boolean move){
  addMode = add;
  deleteMode = delete;
  moveMode = move;
}

PVector getMaxPointX(){
  float max = 0;
  PVector pointMaxX = null;
  for(int i = 0; i < points.size(); i++){
      if(points.get(i).x > max){
        pointMaxX = points.get(i);
        max = points.get(i).x;
      }
  }
  return pointMaxX;
}