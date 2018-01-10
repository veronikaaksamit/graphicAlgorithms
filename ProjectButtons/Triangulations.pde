boolean isOnRightPath = false;

void voronoiDiagrams(){
}


void delaunayTriangulation(){
}

void triangulation(){
  println("Triangulation by sweep line");
  
  if (polygons.size()>3){
    
    ArrayList<PVector> lexipolygons = lexiSort(polygons);
    //printPVectorList(lexipolygons);
    rightPath = new  ArrayList<PVector>();
    leftPath = new  ArrayList<PVector>();
    
    //printPVectorList(polygons);
    
    //println("min y point " + minYPoint );
    //println("max y point " + maxYPoint );
    int upperPointIndex = polygons.indexOf(minYPoint);
    
    
    //println("upper point index " + upperPointIndex );

    Integer[] nearIndices = getNearIndices(polygons.size(), upperPointIndex);
    //println("bigger index " + nearIndices[1] );
    //println("smaller index " + nearIndices[0] );
    
    
    PVector nextPoint = polygons.get(nearIndices[1]);
    PVector previousPoint = polygons.get(nearIndices[0]);
    int iterator = nearIndices[1];
    println("iterator could be " + nearIndices[0] + " or ...IS " + nearIndices[1]);
    
    
    //println("Next point" + nextPoint);
    //println("Previous point " + previousPoint);
    
    if (nextPoint.x > previousPoint.x){
      isOnRightPath = true;
    }else{
      isOnRightPath = false;
    }
    
    leftPath.add(minYPoint);
    rightPath.add(maxYPoint);
    
    while (iterator != upperPointIndex){
      if(hasChanged(iterator)){
        println("Has changed path " + isOnRightPath + " on point " + polygons.get(iterator));
      }else{
        println("iterator = " + iterator + " point = "+polygons.get(iterator));
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
    
    
  }
   else{
    removeAllPoints();
    createPolyMode = true;
  }
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