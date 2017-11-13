import java.util.*;

PFont font;

//Sizes
 //Button width and height
int butSizeX = 270;
int butSizeY = 30;

int pointSize = 18;

int numOfBut = 12;
int addPointButX, addPointButY;
int clearSceneButX, clearSceneButY;
int randomPointsButX,randomPointsButY;
int movePointButX,movePointButY;
int deletePointButX,deletePointButY;
int createPolyButX,createPolyButY;
int removePolyButX, removePolyButY;
int giftWrapButX, giftWrapButY;
int grahamScButX, grahamScButY;
int triangulationButX, triangulationButY;
int kDTreeButX, kDTreeButY;
int delaunayTButX, delaunayTButY;

//Modes
boolean moveMode = false;
boolean deleteMode = false;
boolean addMode = false;
boolean createPolyMode = false;
boolean overButtons = false;

color currentColor = color(255);
color highlightButColor = color(204);

void setup() {
       //size(1280, 800);
       size(960, 540);
       clearSceneButX = 0;
       clearSceneButY = 0;
       
       randomPointsButX = clearSceneButX  ;
       randomPointsButY = clearSceneButY  + butSizeY;
       
       addPointButX = randomPointsButX;
       addPointButY = randomPointsButY+ butSizeY;
       
       movePointButX = addPointButX;
       movePointButY = addPointButY + butSizeY;
       
       deletePointButX = movePointButX;
       deletePointButY = movePointButY + butSizeY;
       
       createPolyButX = deletePointButX;
       createPolyButY = deletePointButY + butSizeY;
       
       removePolyButX = createPolyButX;
       removePolyButY = createPolyButY + butSizeY;
        
       giftWrapButX = removePolyButX;
       giftWrapButY = removePolyButY + butSizeY;
       
       grahamScButX = giftWrapButX;
       grahamScButY = giftWrapButY + butSizeY;
       
       triangulationButX = grahamScButX;
       triangulationButY = grahamScButY + butSizeY;
       
       kDTreeButX = triangulationButX;
       kDTreeButY = triangulationButY + butSizeY;
       
       delaunayTButX = kDTreeButX;
       delaunayTButY = kDTreeButY + butSizeY;
       
       font = createFont("Courier New Bold", 16);
       textFont(font); 
       
       //Adding, deleting, moving points ...used for Graham Scan + Gift Wrapping
       points = new ArrayList<PVector>();
       
       //GrahamScan structure
       gSPoints = new ArrayList<GrahamScanPoint>();
       
       //Triangulation
       polyLines = new ArrayList<PVector>();
       rightPath = new ArrayList<PVector>();
       leftPath = new ArrayList<PVector>();
       
       verticalLines = new ArrayList<Float>();
       horizontalLines = new ArrayList<Float>();
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
  
  if (createPolyMode) {
    fill(highlightButColor);
  }else {
    fill(currentColor);
  }
  rect(createPolyButX, createPolyButY, butSizeX, butSizeY);
  
  fill(currentColor);
  rect(removePolyButX, removePolyButY, butSizeX, butSizeY);
  rect(giftWrapButX, giftWrapButY, butSizeX, butSizeY);
  rect(grahamScButX, grahamScButY, butSizeX, butSizeY);
  rect(triangulationButX, triangulationButY, butSizeX, butSizeY);
  rect(kDTreeButX, kDTreeButY, butSizeX, butSizeY);
  rect(delaunayTButX, delaunayTButY, butSizeX, butSizeY);
  
  //Adding names to buttons
  fill(0);
  text("Clear scene", clearSceneButX + 5,clearSceneButY+20);
  text("Random points", randomPointsButX + 5,randomPointsButY+20);
  text("Add point mode", addPointButX + 5,addPointButY+20);
  text("Move point mode", movePointButX + 5,movePointButY+20);
  text("Delete point mode", deletePointButX + 5,deletePointButY+20);
  text("Create polygon = POLY MODE", createPolyButX + 5, createPolyButY + 20);
  text("Remove polygon by POLY MODE", removePolyButX + 5, removePolyButY + 20);
  text("Gift Wrapping - convex hull", giftWrapButX + 5,giftWrapButY+20);
  text("Graham Scan   - convex hull", grahamScButX + 5,grahamScButY+20);
  text("Triangulation sweep line", triangulationButX + 5, triangulationButY + 20);
  text("k-D tree", kDTreeButX + 5, kDTreeButY + 20);
  text("Delaunay triangulation", delaunayTButX + 5, delaunayTButY + 20);
  
 
  
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
  
  if(gSPoints != null){
    for (int i = 0; i< gSPoints.size() - 1; i++) {
      if(gSPoints.get(i).getCoordinates() != null && gSPoints.get(i+1).getCoordinates() != null){
         line(gSPoints.get(i).getCoordinates().x, gSPoints.get(i).getCoordinates().y, 
             gSPoints.get(i+1).getCoordinates().x, gSPoints.get(i+1).getCoordinates().y );
      }
    }
    if(gSPoints.size()>1){
      line(gSPoints.get(0).getCoordinates().x, gSPoints.get(0).getCoordinates().y, 
             gSPoints.get(gSPoints.size() - 1).getCoordinates().x, gSPoints.get(gSPoints.size() - 1).getCoordinates().y );
     }
    }
  
  
  if(polyLines != null){
    for (int i = 0; i< polyLines.size(); i++) {
      if(minYPPoint == polyLines.get(i) || maxYPPoint == polyLines.get(i)){
        fill(color(#2BFA94));
      }else{
        fill(color(#3FCBF0));
      }
      ellipse(polyLines.get(i).x, polyLines.get(i).y, pointSize, pointSize);
      fill(0);
      text(i, polyLines.get(i).x - 3, polyLines.get(i).y+3);
      if(polyLines.get(i) != null && polyLines.size()>i+1){
         line( polyLines.get(i).x, polyLines.get(i).y, polyLines.get(i+1).x, polyLines.get(i+1).y );
      }else{
        line( polyLines.get(0).x, polyLines.get(0).y, polyLines.get(i).x, polyLines.get(i).y );
      }
    }
  }
  
}

//setting modes + calling functions when button pressed
void mousePressed() {
  
  //If you click into Buttons area
  if(inButtonsArea(mouseX, mouseY)){
    
    if (overBut(addPointButX, addPointButY) ) {
      setModes(true, false, false, false);
      polyLines.clear();
    } else if ( overBut(movePointButX, movePointButY) ) {
      setModes(false, false, true, false);
      polyLines.clear();
    } else if ( overBut(deletePointButX, deletePointButY) ) {
      setModes(false, true, false, false);
      polyLines.clear();
    } else if ( overBut(createPolyButX, createPolyButY) ) {
      setModes(false, false, false, true);
      removeAllPoints();
    }else if ( overBut(removePolyButX, removePolyButY) ) {
      setModes(false, false, false, false);
      polyLines.clear();
    }else if (overBut(clearSceneButX, clearSceneButY)) {
      setModes(false, false, false, false);
      removeAllPoints();
    }else if (overBut(randomPointsButX, randomPointsButY)) {
      setModes(false, false, false, false);
      polyLines.clear();
      addRandomPoints();
    }else if (overBut(giftWrapButX, giftWrapButY)) {
      setModes(false, false, false, false);
      giftWrapping();
    }else if (overBut(grahamScButX, grahamScButY)) {
      setModes(false, false, false, false);
      grahamScan();
    }else if (overBut(triangulationButX, triangulationButY)) {
      setModes(false, false, false, false);
      triangulation();
    }else if (overBut(kDTreeButX, kDTreeButY)) {
      setModes(false, false, false, false);
      kDTree();
    }else if (overBut(delaunayTButX, delaunayTButY)) {
      setModes(false, false, false, false);
      delaunayTriangulation();
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
    if(createPolyMode == true){
        createPolygon();
    }
  }
  
}