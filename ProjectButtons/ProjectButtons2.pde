
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
PVector minYPoint, maxYPoint;


void grahamScan(){
  println("Graham scan algorithm for convex hull");
  removeLinesAndPolygons();
  //printPVectorList(points);
  
  if (points.size() >= 3){
    gSPoints = new ArrayList<GrahamScanPoint>();
    maxXPoint = getMaxXPoints(points).get(0);
    //added maxX point to structure ...1.point
    gSPoints.add(new GrahamScanPoint(maxXPoint, 360));
    
    //point under maxXPoint ...TO COMPUTE ANGLE WITH NEXT POINT
    PVector basePoint = new PVector(maxXPoint.x, maxXPoint.y + 2);
    
    PVector vec1 = new PVector(basePoint.x - maxXPoint.x, basePoint.y - maxXPoint.y);
    float length1 = sqrt( sq(vec1.x) + sq(vec1.y) );
    
    //calculating angle between maxXPoint, basePoint and every point in the area
    for (PVector p : points){
      
      if (p != maxXPoint){
         PVector vec2 = new PVector(p.x - maxXPoint.x, p.y - maxXPoint.y); //Bp ...p possible solution
         float length2 = sqrt( sq(vec2.x) + sq(vec2.y) );
         float angle = 180 - degrees(acos((vec1.x * vec2.x + vec1.y * vec2.y) / (length1 * length2)));
         
         gSPoints.add(new GrahamScanPoint(p, angle));
      }
    }
    
    //sorting all point by angle from min to max angle
    Collections.sort(gSPoints);
    gSPoints.add(0, gSPoints.get(gSPoints.size() - 1));
    gSPoints.remove(gSPoints.size() - 1);
    
    ArrayList<GrahamScanPoint> tempGSP = new ArrayList<GrahamScanPoint>(gSPoints);
    /*for (GrahamScanPoint p : tempGSP){
      println(p);
    }*/
    
    //Cycle which removes points which does not fulfill leftCriterion
    for (int i = 1; i <  tempGSP.size(); i ++){
      if ( tempGSP.size() >=3){
        while (leftCriterion( tempGSP, i) ){
         //println("removing " + tempGSP.get(i) + " from Graham Scan Structure");
          tempGSP.remove(i);
          i = i - 1;
          if (i == tempGSP.size())
            break;
        }
      }
    }
    
    //Setting LinkedList which contains data about polygon on the screen
    polygons = new LinkedList<PVector>();
    //print("Zostali: ");
    for (int i = 0; i < tempGSP.size(); i ++){
       //print(gSPoints.indexOf(tempGSP.get(i))+":" + tempGSP.get(i) + "; ");
       polygons.add(tempGSP.get(i).getCoordinates());
    }
   //println();
    findMinAndMaxYPointForPolygons();
    
  }else{
    addMode = true;
  }
  
}

void giftWrapping(){
  removeLinesAndPolygons();
  
  if (points.size() >= 3){
    
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
    
    while (tempPoints.size()>0){
      //when using A and B for the first time, specific values are already set
      if (polygons.size() >= counter + 1 && counter >= 1){
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
      for (int i = 0; i < tempPoints.size(); i++){
        PVector p = tempPoints.get(i);
        
        //getting vector(Bp) with p point at the end and his length + angle (Bp angle BA)
        vec2 = new PVector(p.x - B.x, p.y - B.y); //Bp ...p possible solution
        float length2 = sqrt(sq(vec2.x) + sq(vec2.y));
        angle = 180 - degrees(acos((vec1.x * vec2.x + vec1.y * vec2.y)/ (length1 * length2)));
        
        //Do we get the smallest angle with this point?
        if (angle <= minAngle){
          pointMinAngle = new PVector(p.x, p.y);
          minAngle= angle;
        }
         
      }
      
      // stopping values ...when the smallest angle is with the first point 
      float maxXAngle = 360;
      
      //getting maxXAngle just when we are not working with first point(the maxXPoint) ...no maxXPoint- maxXPoint - A angle
      if (counter > 1){
        vec2 = new PVector(maxXPoint.x - B.x, maxXPoint.y - B.y); //BMaxXPoint 
        float length2 = sqrt(sq(vec2.x) + sq(vec2.y));
        maxXAngle = 180 - degrees(acos((vec1.x * vec2.x + vec1.y * vec2.y)/ (length1 * length2)));
      }
      
      //when the condition for stopping is fullfilled (smallest angle is with the first point of hull)
      if (maxXAngle < minAngle){
        tempPoints.clear();
      }else{
        tempPoints.remove(pointMinAngle);
        polygons.add(counter, pointMinAngle); 
      }
      
    }    
    
    //printPVectorList(polygons);
    findMinAndMaxYPointForPolygons();
  }else{
    addMode = true;
  }
}

void createPolygon(){
  
  for (int i = 0; i < polygons.size(); i++){
    if (isPoint(polygons.get(i).x, polygons.get(i).y)){
      println("CREATED POLYGON");
      createPolyMode = false;
     //println("Same points");
    }
  }
  
  if (createPolyMode){
    points.add(new PVector(mouseX, mouseY));
    polygons.add(new PVector(mouseX, mouseY));
  }
  
  findMinAndMaxYPointForPolygons();
}

//Removes point on specific possition if there is ont
void deletePoint(){
  for (int i = 0; i < points.size(); i++){
    
    if (isPoint(points.get(i).x, points.get(i).y)){
      if (moveMode){
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
  for (int i = 1; i <= numberOfRandomPoints; i++){
    int x = (int)random(pointSize/2, width - pointSize );
    int y = (int)random(pointSize/2, height - 2* pointSize);
    
    if (inButtonsArea(x, y)){
      x = (int)(butSizeX + x);
      y = (int)(butSizeY + y);
    }
    //y = 250;
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
  triangulation.clear();
  gSPoints.clear();
}

void removePolyByPolygonsMode(){
  polygons.clear();
  triangulation.clear();
}