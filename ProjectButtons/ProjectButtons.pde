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

void setup() {
       size(1280, 800);
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
      fill(color(#3FCBF0));
      ellipse(p.x, p.y, pointSize, pointSize);
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
      break;
    }
  }  
}

//Adding single point
void addPoint(){
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
  
}

//Removing points from screnn
void removeAllPoints(){
  points.clear();
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