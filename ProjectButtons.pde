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
boolean overButtons = false;

color currentColor = color(255);
color highlightButColor = color(204);

//Points
ArrayList<PVector> points; 
int numberOfRandomPoints = 7;
PVector changingPoint;

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
    }
  }
  
  //If you click outside buttons area
  if(!inButtonsArea(mouseX, mouseY)){
    if (addMode == true) {
       addPoint();
    }
    /*if (deleteMode == true) {
        deletePoint();
    }*/
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
  for(int i = 0; i < points.size(); i++){
    float distX = points.get(i).x - mouseX;
    float distY = points.get(i).y - mouseY;
    boolean isPoint = sqrt(sq(distX) + sq(distY)) < pointSize/2 ;
    if(isPoint){
      changingPoint = new PVector(points.get(i).x, points.get(i).y);
      points.remove(points.get(i));
      break;
    }
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
    float x = random(0, width - pointSize );
    float y = random(0, height - pointSize);
    
    if(inButtonsArea(x, y)){
      x = butSizeX + x;
      y = butSizeY + y;
    }
    points.add(new PVector(x, y));
  }
  
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