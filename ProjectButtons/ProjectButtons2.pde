
//Points
ArrayList<PVector> points; 
int numberOfRandomPoints = 3;
PVector changingPoint;

//Convex hull data structures
PVector maxXPoint;
PVector[] CHull;

//PolygonCreation
ArrayList<PVector> polyLines;
PVector minYPPoint, maxYPPoint;


//Triangulation
ArrayList<PVector> rightPath, leftPath;

//kDTree
ArrayList<Float> verticalLines;
ArrayList<Float> horizontalLines;




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
    println("Gift wrapping algorithm ... Convex Hull");
    ArrayList<PVector> tempPoints = new ArrayList<PVector>(points);
    
    CHull = new PVector[tempPoints.size()+1];
    maxXPoint = getMaxXPoints(points).get(0);
    PVector B = CHull[0] = maxXPoint;
    
    //point under maxXPoint 
    PVector basePoint = new PVector(maxXPoint.x, maxXPoint.y + 2);
    PVector A = basePoint;
    
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
      //line( B.x, B.y, A.x, A.y );
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
    maxXPoint = getMaxXPoints(points).get(0);
    ArrayList<GrahamScanPoint> gSPoints = new ArrayList<GrahamScanPoint>();
    
    gSPoints.add(new GrahamScanPoint(maxXPoint, 360));
    
    //point under maxXPoint 
    PVector basePoint = new PVector(maxXPoint.x, maxXPoint.y + 2);
    
    PVector vec1 = new PVector(basePoint.x - maxXPoint.x, basePoint.y - maxXPoint.y);
    float length1 = sqrt(sq(vec1.x) + sq(vec1.y));
    
    
    for(PVector p: points){
      if(p != maxXPoint){
         PVector vec2 = new PVector(p.x - maxXPoint.x, p.y - maxXPoint.y); //Bp ...p possible solution
         float length2 = sqrt(sq(vec2.x) + sq(vec2.y));
         float angle = 180 - degrees(acos((vec1.x * vec2.x + vec1.y * vec2.y)/ (length1 * length2)));
         
         gSPoints.add(new GrahamScanPoint(maxXPoint, angle));
      }
    }
    /*for(GrahamScanPoint p: gSPoints){
      println(p);
    }*/
    
    Collections.sort(gSPoints);
    /*for(GrahamScanPoint p: gSPoints){
      println(p);
    }*/
    
  }else{
    addMode = true;
  }
}

void triangulation(){
  if(polyLines.size()>3){
    ArrayList<PVector> lexiPolyLines =lexiSort(polyLines);
    polyLines = lexiPolyLines;
    ArrayList<PVector> rightP;
    ArrayList<PVector> leftP;
    polyLines = lexiSort(polyLines);
    
    int minPointIndex = polyLines.indexOf(minYPPoint);
    int maxPointIndex = polyLines.indexOf(maxYPPoint);
    Integer[] nearIndices = getNearIndices(polyLines, maxPointIndex);
    PVector a = polyLines.get(nearIndices[0]);
    PVector b = polyLines.get(nearIndices[1]);
    if(a.x < b.x){
      //od max(aj) -> a -> do min je RIGHT PATH
      //od min(aj) -> b -> do max je LEFT PATH
    }else{
      //od max(aj) -> b -> do min je RIGHT PATH
      //od min(aj) -> a -> do max je LEFT PATH
    }
    
    for(PVector p: polyLines){
      
    }
  }
   else{
    createPolyMode = true;
  }
}

Integer[] getNearIndices(ArrayList<PVector>points, int index){
  Integer[] result = new Integer[2];
  if(index == 0){
    result[0] = 1;
    result[1] = points.size() - 1;
    return result;
  }
  if(index == points.size() - 1){
    result[0] = 0;
    result[1] = points.size() - 2;
    return result;
  }
  
  result[0] = index - 1;
  result[1] = index + 1;
  
  return result;
}
void kDTree(){
  float[] xAxes = new float[points.size()];
  float[] yAxes = new float[points.size()];
  for(int i = 0; i < points.size(); i++ ){
    println(points.get(i));
    xAxes[i] = points.get(i).x;
  }
  
  xAxes = sort(xAxes);
  println(xAxes.length/2.0);
  println(xAxes[xAxes.length/2]);
}

ArrayList<PVector> lexiSort(ArrayList<PVector> lines){
  ArrayList<PVector> result = new ArrayList<PVector>();
  float arraySize = lines.size();
  while(result.size() != arraySize){
    ArrayList<PVector> minY = getMinYPoints(lines);
    while(minY.size()>0){
      PVector point = getMinXPoint(minY);
      result.add(point);
      minY.remove(point);
      lines.remove(point);
      println(point);
    }  
  }
  
  return result;
}

ArrayList<PVector> getMinYPoints(ArrayList<PVector> lines){
  ArrayList<PVector> result = new ArrayList<PVector>();
  float min = MAX_FLOAT;
  for(PVector p : lines){
      if(p.y == min){
        result.add(p);
      }
      if(p.y < min){
        min = p.y;
        result.clear();
        result.add(p);
      }
  }
  return result;
}

ArrayList<PVector> getMinXPoints(ArrayList<PVector> lines){
  ArrayList<PVector> result = new ArrayList<PVector>();
  float min = MAX_FLOAT;
  for(PVector p : lines){
      if(p.x == min){
        result.add(p);
      }
      if(p.x < min){
        min = p.x;
        result.clear();
        result.add(p);
      }
  }
  return result;
}

ArrayList<PVector> getMaxXPoints(ArrayList<PVector> points){
  ArrayList<PVector> result = new ArrayList<PVector>();
  float max = 0;
  for(PVector p : points){
      if(p.x == max){
        result.add(p);
      }
      if(p.x > max){
        max = p.x;
        result.clear();
        result.add(p);
      }
  }
  return result;
}

ArrayList<PVector> getMaxYPoints(ArrayList<PVector> points){
  ArrayList<PVector> result = new ArrayList<PVector>();
  float max = 0;
  for(PVector p : points){
      if(p.y == max){
        result.add(p);
      }
      if(p.y > max){
        max = p.y;
        result.clear();
        result.add(p);
      }
  }
  return result;
}

PVector getMinYPoint(ArrayList<PVector> points){
  PVector result = null;
  float min = MAX_FLOAT;
  for(PVector p : points){
      if(p.y < min){
        min = p.y;
        result = p;
      }
  }
  return result;
}

PVector getMinXPoint(ArrayList<PVector> points){
  PVector result = null;
  float min = MAX_FLOAT;
  for(PVector p : points){
      if(p.x < min){
        min = p.x;
        result = p;
      }
  }
  return result;
}

PVector getMaxYPoint(ArrayList<PVector> points){
  PVector result = null;
  float max = 0;
  for(PVector p : points){
      if(p.y > max){
        max = p.y;
        result = p;
      }
  }
  return result;
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
  if(createPolyMode){
    polyLines.add(new PVector(mouseX, mouseY));
  }
  maxYPPoint = getMaxYPoint(polyLines);
  minYPPoint = getMinYPoint(polyLines);
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