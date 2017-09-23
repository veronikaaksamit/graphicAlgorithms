PFont font;

 //Button width and height
int butSizeX = 170;
int butSizeY = 25;

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
}

void draw(){
  background(currentColor);
  stroke(0);
  
  if (moveMode) {
    fill(highlightButColor);
  } else {
    fill(currentColor);
  }
  
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
  
  fill(0);
  text("Clear scene", clearSceneButX + 5,clearSceneButY+20);
  text("Random points", randomPointsButX + 5,randomPointsButY+20);
  text("Add point mode", addPointButX + 5,addPointButY+20);
  text("Move point mode", movePointButX + 5,movePointButY+20);
  text("Delete point mode", deletePointButX + 5,deletePointButY+20);
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
  }else if ( overBut(randomPointsButX, randomPointsButY) 
            || overBut(clearSceneButX, clearSceneButY)) {
    addMode = false;
    deleteMode = false;
    moveMode = false;
  }
}

boolean overBut(int x, int y) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (mouseX >= x && mouseX <= x + butSizeX
      && mouseY >= y && mouseY <= y + butSizeY) {
    return true;
  } else {
    return false;
  }
}