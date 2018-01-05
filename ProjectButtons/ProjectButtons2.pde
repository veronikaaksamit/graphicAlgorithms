
//Points
ArrayList<PVector> points; 
int numberOfRandomPoints = 3;
PVector changingPoint;

//New structure for polygon created by Graham Scan, Gift Wrapping or just Create Polygon Mode
//later used for triangulation, ...
LinkedList<PVector> polygons;

//Convex hull data structures
PVector maxXPoint;

ArrayList<GrahamScanPoint> gSPoints;

//PolygonCreation

PVector minYPPoint, maxYPPoint;


//Triangulation
ArrayList<PVector> rightPath, leftPath;

//kDTree
ArrayList<Float> verticalLines;
ArrayList<Float> horizontalLines;

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

void grahamScan(){
  removeLinesAndPolygons();
  if(points.size() >= 3){
    gSPoints = new ArrayList<GrahamScanPoint>();
    maxXPoint = getMaxXPoints(points).get(0);
    //added maxX point to structure ...1.point
    gSPoints.add(new GrahamScanPoint(maxXPoint, 360));
    
    //point under maxXPoint 
    PVector basePoint = new PVector(maxXPoint.x, maxXPoint.y + 2);
    
    PVector vec1 = new PVector(basePoint.x - maxXPoint.x, basePoint.y - maxXPoint.y);
    float length1 = sqrt( sq(vec1.x) + sq(vec1.y) );
    
    //calculating angle between maxXPoint, basePoint and every point in the area
    for(PVector p : points){
      if(p != maxXPoint){
         PVector vec2 = new PVector(p.x - maxXPoint.x, p.y - maxXPoint.y); //Bp ...p possible solution
         float length2 = sqrt( sq(vec2.x) + sq(vec2.y) );
         float angle = 180 - degrees(acos((vec1.x * vec2.x + vec1.y * vec2.y) / (length1 * length2)));
         
         gSPoints.add(new GrahamScanPoint(p, angle));
      }
    }
    
    //sorting all point by angle from min to max angle
    Collections.sort(gSPoints);
    for(GrahamScanPoint p : gSPoints){
      println(p);
    }
    
    for(int i = 0; i < gSPoints.size(); i ++){
      while(leftCriterion(gSPoints, i) && gSPoints.size() >1){
         println("removing " + gSPoints.get(i) + " from Graham Scan Structure");
         gSPoints.remove(i);
         if(i != 0){
           //need to compare previous point (not the new i point)
           i = i-1;
         }
      }
    }
    
    for(int i = 0; i < gSPoints.size(); i ++){
       println("Zostal " + gSPoints.get(i) );
    }
    
  }else{
    addMode = true;
  }
  
}

void giftWrapping(){
  removeLinesAndPolygons();
  if(points.size() >= 3){
    println("Gift wrapping algorithm ... Convex Hull");
    ArrayList<PVector> tempPoints = new ArrayList<PVector>(points);
    
    polygons = new LinkedList<PVector>();
    
    maxXPoint = getMaxXPoints(points).get(0);
    PVector B = maxXPoint;
    polygons.add(0, maxXPoint);
    
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
      if(polygons.size() >= counter + 1 && counter >= 1){
        B = polygons.get(counter);
        A = polygons.get(counter-1);
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
      }else{
        tempPoints.remove(pointMinAngle);
        polygons.add(counter, pointMinAngle); 
      }
      
    }    
     printPVectorList(polygons);
    
  }else{
    addMode = true;
  }
}

void createPolygon(){
  for(int i = 0; i < polygons.size(); i++){
    if(isPoint(polygons.get(i).x, polygons.get(i).y)){
      println("CREATED POLYGON");
      createPolyMode = false;
      println("Same points");
    }
  }
  if(createPolyMode){
    polygons.add(new PVector(mouseX, mouseY));
  }
  maxYPPoint = getMaxYPoint(polygons);
  minYPPoint = getMinYPoint(polygons);
}

//Removes point on specific possition if there is ont
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

//Just removes point, 
//and moveMode is already set, so after mouse release point is created
void movePoint(){
  deletePoint();
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
  removeLinesAndPolygons();
  println("CLEARING THE SCENE");
}

void removeLinesAndPolygons(){
  polygons.clear();
  gSPoints.clear();
}