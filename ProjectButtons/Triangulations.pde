//Triangulation
ArrayList<PVector> rightPath, leftPath;
boolean isOnRightPath = false;
ArrayList<PVector> triangulation;

void voronoiDiagrams(){
}


void delaunayTriangulation(){
}

void triangulation(){
  if(points.size()>3 && polygons.size() < 3){
    grahamScan();
  }
  
  println("Triangulation by sweep line");
  if (polygons.size()>3){
      removePointsInsidePolygon();
      ArrayList<PVector> lexipolygons = lexiSort(polygons);
      rightPath = new  ArrayList<PVector>();
      leftPath = new  ArrayList<PVector>();
      
      int upperPointIndex = polygons.indexOf(minYPoint);
      Integer[] nearIndices = getNearIndices(polygons.size(), upperPointIndex);
      PVector nextPoint = polygons.get(nearIndices[1]);
      PVector previousPoint = polygons.get(nearIndices[0]);
      int iterator = nearIndices[1];
      println("iterator could be " + nearIndices[0] + " or ...IS " + nearIndices[1]);
      
      if (nextPoint.x > previousPoint.x){
        isOnRightPath = true;
      }else{
        isOnRightPath = false;
      }
      
      leftPath.add(minYPoint);
      rightPath.add(maxYPoint);
      
      while (iterator != upperPointIndex){
        if(hasChanged(iterator)){
          //println("Has changed path " + isOnRightPath + " on point " + polygons.get(iterator));
        }else{
          //println("iterator = " + iterator + " point = "+polygons.get(iterator));
          if(isOnRightPath){
            //println("adding to right " + polygons.get(iterator));
            rightPath.add(polygons.get(iterator));
          }else{
            //println("adding to left " + polygons.get(iterator));
            leftPath.add(polygons.get(iterator));
          }
        }
      
        iterator++;
        
        if(iterator >= polygons.size()){
          //println("need to change interator to 0 "+ iterator );
          iterator = 0;
        }
    }
    
    println("left path");
    printPVectorList(leftPath);
    println("right path");
    printPVectorList(rightPath);
    
    println("START OF REAL TRIANGULATION");
    triangulation = new ArrayList<PVector>();
    printPVectorList(lexipolygons);
  
    for (PVector lp : lexipolygons){
      PVector A = lexipolygons.get(0);
      PVector B = lexipolygons.get(1);
      PVector C = lexipolygons.get(2);
      
      if(!onSamePath(B,C)){
        triangulation.add(B);
        triangulation.add(C);
      }
      
      if(!onSamePath(A,C)){
        triangulation.add(A);
        triangulation.add(C);
      }
    } 
  }else{
    removeAllPoints();
    createPolyMode = true;
  }
}

boolean onSamePath(PVector A, PVector B){
  boolean aIsThere = false;
  boolean bIsThere = false;
  for(PVector p : rightPath){
    if(p == A){
      aIsThere = true;
    }
    if(p == B){
      bIsThere = true;
    }
  }
  
  if(aIsThere == bIsThere){
    return true;
  }
  return false;
}

boolean hasChanged(int iterator){
  if(polygons.get(iterator) == minYPoint || polygons.get(iterator) == maxYPoint){
    if(isOnRightPath){      
       isOnRightPath  = false;
    }else{
      isOnRightPath  = true;
    }
    return true;
  }
  return false;
}