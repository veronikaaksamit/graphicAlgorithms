import java.util.*;

  
//PrintWriter output;
PFont font;

//Sizes
 //Button width and height
int butSizeX = 270;
int butSizeY = 30;

int pointSize = 18;

int maxX, maxY;

int numOfBut = 13;
int butXCoord = 0;
int butXNameCoord =  butXCoord + 5;

//Y coordinates for creating buttons
int addPointButY;
int clearSceneButY;
int randomPointsButY;
int movePointButY;
int deletePointButY;
int createPolyButY;
int removePolyButY;
int giftWrapButY;
int grahamScButY;
int triangulationButY;
int kDTreeButY;
int delaunayTButY;
int voronoiDiagButY;

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
       //output = createWriter("output from DT.txt"); 
       maxX = 960;
       maxY = 540;
       clearSceneButY = 0;
       
       randomPointsButY = clearSceneButY  + butSizeY;
       addPointButY = randomPointsButY+ butSizeY;
       movePointButY = addPointButY + butSizeY;
       deletePointButY = movePointButY + butSizeY;
       createPolyButY = deletePointButY + butSizeY;
       removePolyButY = createPolyButY + butSizeY;
       giftWrapButY = removePolyButY + butSizeY;
       grahamScButY = giftWrapButY + butSizeY;
       triangulationButY = grahamScButY + butSizeY;
       kDTreeButY = triangulationButY + butSizeY;
       delaunayTButY = kDTreeButY + butSizeY;
       voronoiDiagButY = delaunayTButY + butSizeY;
       
       font = createFont("Courier New Bold", 16);
       textFont(font); 
       
       //Adding, deleting, moving points ...used for Graham Scan + Gift Wrapping
       points = new ArrayList<PVector>();
       
       //New structure for polygon created by Graham Scan, Gift Wrapping or just Create Polygon Mode
       //later used for triangulation, ...
       polygons = new LinkedList<PVector>();
       
       //GrahamScan structure
       gSPoints = new ArrayList<GrahamScanPoint>();
       
       //Triangulation
       rightPath = new ArrayList<PVector>();
       leftPath = new ArrayList<PVector>();
       triangulation = new ArrayList<PVector>();
       
       //DelaunayTriangulation
       activeEdgesL = new ArrayList<ActiveEdge>();
       DT = new ArrayList<ActiveEdge>();
       c = new Circle();
        
}

void draw(){
  background(currentColor);
  stroke(0);
  
  //Rendering rectangles as buttons
  fill(currentColor);
  rect(butXCoord, clearSceneButY, butSizeX, butSizeY);
  rect(butXCoord, randomPointsButY, butSizeX, butSizeY);
  
  if (addMode) {
    fill(highlightButColor);
  }else {
    fill(currentColor);
  }
  rect(butXCoord, addPointButY, butSizeX, butSizeY);
  
  if (moveMode) {
    fill(highlightButColor);
  }else {
    fill(currentColor);
  }
  rect(butXCoord, movePointButY, butSizeX, butSizeY);
  
  if (deleteMode) {
    fill(highlightButColor);
  }else {
    fill(currentColor);
  }
  rect(butXCoord, deletePointButY, butSizeX, butSizeY);
  
  if (createPolyMode) {
    fill(highlightButColor);
  }else {
    fill(currentColor);
  }
  rect(butXCoord, createPolyButY, butSizeX, butSizeY);
  
  fill(currentColor);
  rect(butXCoord, removePolyButY, butSizeX, butSizeY);
  rect(butXCoord, giftWrapButY, butSizeX, butSizeY);
  rect(butXCoord, grahamScButY, butSizeX, butSizeY);
  rect(butXCoord, triangulationButY, butSizeX, butSizeY);
  rect(butXCoord, kDTreeButY, butSizeX, butSizeY);
  rect(butXCoord, delaunayTButY, butSizeX, butSizeY);
  rect(butXCoord, voronoiDiagButY, butSizeX, butSizeY);
  
  //Adding names to buttons
  fill(0);
  
  text("Clear scene", butXNameCoord,clearSceneButY+20);
  text("Random points", butXNameCoord,randomPointsButY+20);
  text("Add point mode", butXNameCoord,addPointButY+20);
  text("Move point mode",butXNameCoord,movePointButY+20);
  text("Delete point mode", butXNameCoord,deletePointButY+20);
  text("Create polygon = POLY MODE", butXNameCoord, createPolyButY + 20);
  text("Remove polygon by POLY MODE", butXNameCoord, removePolyButY + 20);
  text("Gift Wrapping - convex hull", butXNameCoord,giftWrapButY+20);
  text("Graham Scan   - convex hull",butXNameCoord,grahamScButY+20);
  text("Triangulation sweep line",butXNameCoord, triangulationButY + 20);
  text("k-D tree", butXNameCoord, kDTreeButY + 20);
  text("Delaunay triangulation", butXNameCoord, delaunayTButY + 20);
  text("Voronoi diagrams", butXNameCoord, voronoiDiagButY + 20);
  
 
  
  //Printing points
  for (PVector p : points) {
      if (maxXPoint != null && p == maxXPoint){
        fill(color(#2BFA94));
        ellipse(p.x, p.y, pointSize, pointSize);
      }else{
        fill(color(#3FCBF0));
        ellipse(p.x, p.y, pointSize, pointSize);
      }
      fill(0);
      text(p.x + " " + p.y, p.x - 25, p.y +25);
  }
  fill(0);
    
  
  if (polygons != null){
    for (int i = 0; i< polygons.size(); i++) {
      if (minYPoint == polygons.get(i) || maxYPoint == polygons.get(i)){
        fill(color(#F70710));
      }else{
        fill(color(#3FCBF0));
      }
      ellipse(polygons.get(i).x, polygons.get(i).y, pointSize, pointSize);
      fill(0);
      //text(i, polygons.get(i).x - 3, polygons.get(i).y + 3);
      if (polygons.get(i) != null && polygons.size()> i + 1){
         line( polygons.get(i).x, polygons.get(i).y, polygons.get(i+1).x, polygons.get(i+1).y );
      }else{
        line( polygons.get(0).x, polygons.get(0).y, polygons.get(i).x, polygons.get(i).y );
      }
    }
  }
  
  if (triangulation != null){
    for (int i = 0; i < triangulation.size(); i += 2) {
      stroke(color(#FFF81A));
      line(triangulation.get(i).x, triangulation.get(i).y, triangulation.get(i+1).x, triangulation.get(i+1).y );
    }
  }
  
  if(root != null){
    printTree();    
  }
  
  
  
  if(DT!= null){
    for (int i = 0; i < DT.size(); i ++) {
      stroke(color(#FFF81A));
      line(DT.get(i).getP1().getX(), DT.get(i).getP1().getY(), DT.get(i).getP2().getX(), DT.get(i).getP2().getY());
      /*if(i % 3 == 2){
        c.circumCircle(DT.get(i-2).getP1(), DT.get(i-1).getP1(), DT.get(i).getP1());
        if(c!= null && c.getCenter() != null){
          stroke(0);
          noFill();
          ellipse(c.getCenter().x, c.getCenter().y, c.getRadius()*2,  c.getRadius()*2);
        }
      }*/
    }
  }
  
}

void printTree(){
  
  paintTree(root);
}

void paintTree(KdNode node){
  Line line = node.getLine();
  
  if(line != null){
    if(line.isVertical()){
      stroke(color(#2DEA64));
    }else{
      stroke(color(#2DD9EA));
    }
    
    line(line.getPoint1().x,line.getPoint1().y, line.getPoint2().x, line.getPoint2().y);
    
    if(node.getRight() != null){
      paintTree(node.getRight());
    }
    
    if(node.getLeft() != null){
      paintTree(node.getLeft());
    }
  }
}




//setting modes + calling functions when button pressed
void mousePressed() {
  
  //If you click into Buttons area
  if (inButtonsArea(mouseX, mouseY)){
    
    if (overBut(butXCoord, addPointButY) ) {
      setModes(true, false, false, false);
      removePolyByPolygonsMode();
    } else if ( overBut(butXCoord, movePointButY) ) {
      setModes(false, false, true, false);
    } else if ( overBut(butXCoord, deletePointButY) ) {
      setModes(false, true, false, false);
      removePolyByPolygonsMode();
    } else if ( overBut(butXCoord, createPolyButY) ) {
      setModes(false, false, false, true);
      removePolygonsKdTreeTriangulations();
      removeAllPoints();
    }else if (overBut(butXCoord, removePolyButY) ) {
      setModes(false, false, false, false);
      removePolyByPolygonsMode();
    }else if (overBut(butXCoord, clearSceneButY)) {
      setModes(false, false, false, false);
      removeAllPoints();
      removePolygonsKdTreeTriangulations();
    }else if (overBut(butXCoord, randomPointsButY)) {
      setModes(false, false, false, false);
      removePolyByPolygonsMode();
      addRandomPoints();
    }else if (overBut(butXCoord, giftWrapButY)) {
      setModes(false, false, false, false);
      removePolygonsKdTreeTriangulations();
      giftWrapping();
    }else if (overBut(butXCoord, grahamScButY)) {
      setModes(false, false, false, false);
      removePolygonsKdTreeTriangulations();
      grahamScan();
    }else if (overBut(butXCoord, triangulationButY)) {
      setModes(false, false, false, false);
      removePolygonsKdTreeTriangulations();
      triangulation();
    }else if (overBut(butXCoord, kDTreeButY)) {
      setModes(false, false, false, false);
      removePolygonsKdTreeTriangulations();
      kDTree();
    }else if (overBut(butXCoord, delaunayTButY)) {
      setModes(false, false, false, false);
      removePolygonsKdTreeTriangulations();
      delaunayTriangulation();
    }else if (overBut(butXCoord, voronoiDiagButY)) {
      setModes(false, false, false, false);
      removePolygonsKdTreeTriangulations();
      delaunayTriangulation();
      voronoiDiagrams();
    }
  }
  
  //If you click outside buttons area
  if (!inButtonsArea(mouseX, mouseY)){
    if (addMode == true) {
       addPoint();
    }
    if (deleteMode == true) {
        deletePoint();
    }
    if (moveMode == true) {
        movePoint();
    }
    if (createPolyMode == true){
        createPolygon();
    }
  }
  
}