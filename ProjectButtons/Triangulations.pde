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
  
    iterator = 2;
    ArrayList<PVector> stack = new ArrayList<PVector> ();
      
    stack.add(lexipolygons.get(0));
    stack.add(lexipolygons.get(1));
    stack.add(lexipolygons.get(iterator));
    
    for (int j = 2; j < lexipolygons.size() - 1 ; j++){
      
      PVector B = stack.get(stack.size() - 2);
      PVector C = lexipolygons.get(j);
      PVector A;
      
      //println(" B=" + B + " C=" + C );
      print("STACK: ");
      printPVectorList(stack);
      
      if(!onSamePath(B, C)){
        for(int i = stack.size() - 1; i >= 1 ; i--){
            addEdge(B, C);
            println("adding " + stack.get(i) + " "+ C);
        }
        stack.clear();
        stack.add(B);
        stack.add(C);
      }else{
        A = stack.get(stack.size() - 2);
        println("We are here"+ A +" B="+B+" C="+C );
        
        if(bothOnPath(B, C, rightPath)){
          if(leftCrit(A, B, C)){
            println("left crit right path = OK");
            stack.add(C);
          }else{
            addEdge(A,C);
            println("left crit right path = NOK");
            println ("added edge both on 1 side " + A + " " + C);
            stack.remove(B);
            stack.add(C);
          }
        }
        
        if(bothOnPath(B, C, leftPath)){
          if(!leftCrit(A, B, C)){
            println("left crit  left path = NOK");
            stack.add(C);
          }else{
            addEdge(A,C);
            println("left crit  left path = OK");
            println ("added edge both on 1 side " + A+ " " + C);
            stack.remove(B);
            stack.add(C);
          }
        }
      }
    }

  }else{
    removeAllPoints();
    createPolyMode = true;
  }
}

void addEdge(PVector A, PVector B){
    triangulation.add(A);
    triangulation.add(B);
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

boolean bothOnPath(PVector A, PVector B, ArrayList<PVector> path){
  boolean aIsThere = false;
  boolean bIsThere = false;
  for(PVector p : path){
    if(p == A){
      aIsThere = true;
    }
    if(p == B){
      bIsThere = true;
    }
  }
  return aIsThere && bIsThere;
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