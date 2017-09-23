PFont font;

//Sizes
 //Button width and height
int butSizeX = 170;
int butSizeY = 25;

int pointSize = 15;

int numOfBut = 5;
int addPointButX, addPointButY;
int clearSceneButX, clearSceneButY;
int randomPointsButX,randomPointsButY;
int movePointButX,movePointButY;
int deletePointButX,deletePointButY;

//Modes
boolean moveMode = false;
boolean deleteMode = false;
boolean addMode = false;

color currentColor = color(255);
color highlightButColor = color(204);

//Points
ArrayList<PVector> points; 
int numberOfRandomPoints = 7;

void setup() {
       size(640, 360);
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
  
  //Adding names to buttons
  fill(0);
  text("Clear scene", clearSceneButX + 5,clearSceneButY+20);
  text("Random points", randomPointsButX + 5,randomPointsButY+20);
  text("Add point mode", addPointButX + 5,addPointButY+20);
  text("Move point mode", movePointButX + 5,movePointButY+20);
  text("Delete point mode", deletePointButX + 5,deletePointButY+20);
  
  //Printing points
  for (PVector p : points) {
      ellipse(p.x, p.y, pointSize, pointSize);
  }
}

void mousePressed() {
  if ( overBut(addPointButX, addPointButY) ) {
    addMode = true;
    deleteMode = false;
    moveMode = false;
  } else if ( overBut(movePointButX, movePointButY) ) {
    addMode = false;
    deleteMode = false;
    moveMode = true;
  } else if ( overBut(deletePointButX, deletePointButY) ) {
    addMode = false;
    deleteMode = true;
    moveMode = false;
  }else if (overBut(clearSceneButX, clearSceneButY)) {
    addMode = false;
    deleteMode = false;
    moveMode = false;
    removeAllPoints();
  }else if (overBut(randomPointsButX, randomPointsButY)) {
    addMode = false;
    deleteMode = false;
    moveMode = false;
    addRandomPoints();
  }else if (addMode == true) {
    addPoint();
  }/*else if (deleteMode == true) {
    deletePoint();
  }else if (moveMode == true) {
    movePoint();
  }*/
  
  
}

boolean overBut(int x, int y) {
  if (mouseX >= x && mouseX <= x + butSizeX
      && mouseY >= y && mouseY <= y + butSizeY) {
    return true;
  } else {
    return false;
  }
}

//Adding single point
void addPoint(){
  points.add(new PVector(mouseX, mouseY));
}

//Removing points from screnn
void removeAllPoints(){
  points.clear();
}

//Adding multiple random points to screen
void addRandomPoints(){
  for(int i = 1; i <= numberOfRandomPoints; i++){
    float x = random(0, width);
    float y = random(0, height);
    if(x < butSizeX + pointSize && y < butSizeY * numOfBut + pointSize){
      x = butSizeX + x;
      y = butSizeY + y;
    }
    points.add(new PVector(x, y));
  }
  
}