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
      //println("iterator could be " + nearIndices[0] + " or ...IS " + nearIndices[1]);
      
      //println("upper point "+ minYPoint );
      if(isExtreme(nextPoint)){
        // FROM MOST LEFT ONES TO RIGHT
        ArrayList<PVector> lexipolygonsX = lexiSortX(polygons);
        if(isExtreme(lexipolygonsX.get(0)) && isExtreme(lexipolygonsX.get(1))){
          lexipolygonsX.remove(1);
          lexipolygonsX.remove(0);
          rightPath.addAll(lexipolygonsX);
        }
        int size = lexipolygonsX.size();
        if(isExtreme(lexipolygonsX.get(size - 1)) && isExtreme(lexipolygonsX.get(size - 2))){
          lexipolygonsX.remove(size - 1);
          lexipolygonsX.remove(size - 2);
          leftPath.addAll(lexipolygonsX);
        }
        
      }else{
        if (nextPoint.x > previousPoint.x){
          isOnRightPath = true;
          //println("START RIGHT path " + iterator + " " + nextPoint);
        }else{
          isOnRightPath = false;
          //println("START LEFT path " + iterator + " " + nextPoint);
        }
      }
      
      
      
      
      leftPath.add(minYPoint);
      rightPath.add(maxYPoint);
      
      while(rightPath.size() + leftPath.size() != polygons.size()){
        if(hasChanged(iterator)){
          //println("Has changed path " + isOnRightPath + " on point " + polygons.get(iterator));
        }else{
          //println("iterator = " + iterator + " point = "+polygons.get(iterator));
          if(isOnRightPath){
            println("adding to right " + polygons.get(iterator));
            rightPath.add(polygons.get(iterator));
          }else{
            println("adding to left " + polygons.get(iterator));
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
    println();
    println("START OF REAL TRIANGULATION");
    triangulation = new ArrayList<PVector>();
    printPVectorList(lexipolygons);
  
    iterator = 2;
    ArrayList<PVector> stack = new ArrayList<PVector> ();
      
    stack.add(lexipolygons.get(0));
    stack.add(lexipolygons.get(1));
    
    for (int j = 2; j <= lexipolygons.size() - 1 ; j++){
      
      PVector B = stack.get(stack.size() - 1);
      PVector C = lexipolygons.get(j);
      PVector A;
      
      //println(" B=" + B + " C=" + C );
      print("STACK: ");
      printPVectorList(stack);
      
      if(!onSamePath(B, C)){
        for(int i = stack.size() - 1; i >= 1 ; i--){
            addEdge(stack.get(i), C);
            println("adding " + stack.get(i) + " "+ C);
        }
        stack.clear();
        stack.add(B);
        stack.add(C);
      }else{
        A = stack.get(stack.size() - 2);
        println("We are here"+ A +" B="+B+" C="+C );
        
        if(bothOnPath(B, C, rightPath)){
          println("Both on right path");
          if(!leftCrit(A, B, C)){
            println("left crit right path = NOK");
            stack.add(C);
          }else{
            println("turning RIGHT " + leftCrit(A, B, C));
            while(leftCrit(A, B, C) ){
              addEdge(A,C);
              println("left crit right path = NOK");
              println ("added edge both on 1 side " + A + " " + C);
              stack.remove(B);
              B = A;
              if(stack.size() - 2 < 0){
                break;
              }
              A = stack.get(stack.size() - 2);
            }
            stack.add(C);
          }
        }
        
        if(bothOnPath(B, C, leftPath)){
          println("Both on left path");
          if(leftCrit(A, B, C)){
            println("left crit  left path = OK");
            stack.add(C);
          }else{
             while(!leftCrit(A, B, C)){
                addEdge(A,C);
                println("left crit  left path = OK");
                println ("added edge both on 1 side " + A+ " " + C);
                stack.remove(B);
                B = A;
                if(stack.size() - 2 <0){
                  break;
                }
                A = stack.get(stack.size() - 2);
             }
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

boolean isExtreme(PVector A){
  if(A == minYPoint){
    return true;
  }
  if(A == maxYPoint){
    return true;
  }
  return false;
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
      println("CHANGED on LEFT path " + polygons.get(iterator));
       isOnRightPath  = false;
    }else{
      println("CHANGED on RIGHT path" + polygons.get(iterator));
      isOnRightPath  = true;
    }
    return true;
  }
  return false;
}