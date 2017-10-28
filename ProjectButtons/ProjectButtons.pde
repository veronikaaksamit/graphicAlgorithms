PFont font;

//Sizes
 //Button width and height
int butSizeX = 270;
int butSizeY = 30;

int pointSize = 18;

int numOfBut = 9;
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

//Modes
boolean moveMode = false;
boolean deleteMode = false;
boolean addMode = false;
boolean createPolyMode = false;
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

//PolygonCreation
ArrayList<PVector> polyLines;

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
       
       font = createFont("Courier New Bold", 16);
       textFont(font); 
       
       points = new ArrayList<PVector>();
       polyLines = new ArrayList<PVector>();
       
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
  
  
  fill(color(#3FCBF0));
  if(polyLines != null){
    for (int i = 0; i< polyLines.size(); i++) {
      if(i == 0 || i != polyLines.size() -1){
        ellipse(polyLines.get(i).x, polyLines.get(i).y, pointSize, pointSize);
      }
      if(polyLines.get(i) != null && polyLines.size()>i+1){
         line( polyLines.get(i).x, polyLines.get(i).y, polyLines.get(i+1).x, polyLines.get(i+1).y );
      }
    }
  }
  
  /*fill(0);
  if(A!= null){
    text("A", A.x,A.y);
  }
  if(B!= null){
    text("B", B.x, B.y);
  }
  if(C!= null){
     text("C", C.x, C.y);
  }*/
  
  
}

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




void giftWrapping(){

  if(points.size() >= 3){
    println("Gift wrapping algorithm for Convex Hull");
    ArrayList<PVector> tempPoints = new ArrayList<PVector>(points);
    
    CHull = new PVector[tempPoints.size()+1];
    maxXPoint = getMaxPointX();
    B = CHull[0] = maxXPoint;
    
    //point under maxXPoint 
    PVector basePoint = new PVector(maxXPoint.x, maxXPoint.y + 2);
    A = basePoint;
    
    int counter = 1;
    
    //removing first point from tempPoints which we are solving
    tempPoints.remove(maxXPoint);
    
    PVector pointMinAngle = null;
    float minAngle = 360;
    
    PVector vec1 = new PVector(basePoint.x - maxXPoint.x, basePoint.y - maxXPoint.y);
    float length1 = sqrt(sq(vec1.x) + sq(vec1.y));
    
    PVector vec2 = null;
    
    while(tempPoints.size()>0){
      //when using A and B for the first time, specific values are already set
      if(CHull[counter]!= null && CHull[counter - 1]!= null){
        B = CHull[counter];
        A = CHull[counter-1];
        counter++;
      }
      
      pointMinAngle = null;
      minAngle = 360;
      
      //values about BA vector
      vec1 = new PVector(A.x - B.x, A.y - B.y  );//BA
      line( B.x, B.y, A.x, A.y );
      length1 = sqrt(sq(vec1.x) + sq(vec1.y));
      
      float angle = 360;
      
      //checking all possible points
      for(int i = 0; i < tempPoints.size(); i++){
        PVector p = tempPoints.get(i);
        
        //getting vector(Bp) with p point at the end and his length + angle (Bp angle BA)
        vec2 = new PVector(p.x - B.x, p.y - B.y); //Bp ...p possible solution
        float length2 = sqrt(sq(vec2.x) + sq(vec2.y));
        angle = 180 - degrees(acos((vec1.x * vec2.x + vec1.y * vec2.y)/ (length1 * length2)));
        
        //Do we get the smallest angle with this point?
        if(angle <= minAngle){
          pointMinAngle = new PVector(p.x, p.y);
          minAngle= angle;
        }
         
      }
      // stopping values ...when the smallest angle is with the first point 
      float maxXAngle = 360;
      //getting maxXAngle just when we are not working with first point(the maxXPoint) ...no maxXPoint- maxXPoint - A angle
      if(counter > 1){
        vec2 = new PVector(maxXPoint.x - B.x, maxXPoint.y - B.y); //BMaxXPoint 
        float length2 = sqrt(sq(vec2.x) + sq(vec2.y));
        maxXAngle = 180 - degrees(acos((vec1.x * vec2.x + vec1.y * vec2.y)/ (length1 * length2)));
      }
      
      //when the condition for stopping is fullfilled (smallest angle is with the first point of hull)
      if(maxXAngle < minAngle){
        tempPoints.clear();
        CHull[counter] = maxXPoint;
      }else{
        CHull[counter] = pointMinAngle; 
        tempPoints.remove(pointMinAngle);
      }
      
      //connecting last points when there is no point left
      if(tempPoints.size()==0){
        CHull[counter+1] = maxXPoint;
      }
    }    
    
  }else{
    addMode = true;
  }
}

void grahamScan(){
  if(points.size() >= 3){
  }else{
    addMode = true;
  }
}

void triangulation(){
  if(polyLines.size()>3){
    
    
  }else{
    createPolyMode = true;
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
    
    if(isPoint(points.get(i).x, points.get(i).y)){
      if(moveMode){
        changingPoint = new PVector(points.get(i).x, points.get(i).y);
      }
      points.remove(points.get(i));
      println("DELETING POINT");
      break;
    }
  }  
}

boolean isPoint(float x, float y){
  float distX = x - mouseX;
  float distY = y - mouseY;
  return sqrt(sq(distX) + sq(distY)) < pointSize/2 ;
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

void createPolygon(){
  for(int i = 0; i < polyLines.size(); i++){
    if(isPoint(polyLines.get(i).x, polyLines.get(i).y)){
      println("CREATED POLYGON");
      createPolyMode = false;
      println("Same points");
    }
  }
  polyLines.add(new PVector(mouseX, mouseY));
}

//Removing points from screnn
void removeAllPoints(){
  points.clear();
  polyLines.clear();
  CHull = new PVector[]{};
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
void setModes(boolean add, boolean delete, boolean move, boolean createPoly){
  addMode = add;
  deleteMode = delete;
  moveMode = move;
  createPolyMode = createPoly;
}

PVector getMaxPointYOnPolygon(){
  float max = 0;
  PVector pointMaxY = null;
  for(int i = 0; i < polyLines.size(); i++){
      if(polyLines.get(i).y > max){
        pointMaxY = points.get(i);
        max = points.get(i).y;
      }
  }
  return pointMaxY;
}

PVector getMinPointYOnPolygon(){
  float min = MAX_FLOAT;
  PVector pointMinY = null;
  for(int i = 0; i < polyLines.size(); i++){
      if(polyLines.get(i).y < min){
        pointMinY = points.get(i);
        min = points.get(i).y;
      }
  }
  return pointMinY;
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