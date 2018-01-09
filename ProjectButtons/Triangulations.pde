boolean isOnRightPath = false;

void voronoiDiagrams(){
}


void delaunayTriangulation(){
}

void triangulation(){
  println("Triangulation by sweep line");
  
  if (polygons.size()>3){
    
    ArrayList<PVector> lexipolygons = lexiSort(polygons);
    printPVectorList(lexipolygons);
    //polygons = lexipolygons;
    rightPath = new  ArrayList<PVector>();
    leftPath = new  ArrayList<PVector>();
    //polygons = lexiSort(polygons);
    
    printPVectorList(polygons);
    
    println("min y point " + minYPPoint );
    println("max y point " + maxYPPoint );
    int upperPointIndex = polygons.indexOf(maxYPPoint);
    
    
    println("upper point index " + upperPointIndex );

    Integer[] nearIndices = getNearIndices(polygons.size(), upperPointIndex);
    println("bigger index " + nearIndices[1] );
    println("smaller index " + nearIndices[0] );
    
    
    PVector nextPoint = polygons.get(nearIndices[1]);
    PVector previousPoint = polygons.get(nearIndices[0]);
    int iterator = nearIndices[1];
    
    rightPath.add(maxYPPoint);
    
    if (nextPoint.x > previousPoint.x){
      isOnRightPath = true;
    }else{
      isOnRightPath = false;
    }
    
    while (iterator != upperPointIndex){
      hasChanged(iterator);
      
      println("iterator =" + iterator);
      if(isOnRightPath){
        println("adding to right " + polygons.get(iterator));
        rightPath.add(polygons.get(iterator));
      }else{
        println("adding to left " + polygons.get(iterator));
        leftPath.add(polygons.get(iterator));
      }
    
      iterator++;
      
      if(iterator >= polygons.size()){
        println("need to change interator to 0 "+ iterator );
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
  if(polygons.get(iterator) == minYPPoint || polygons.get(iterator) == maxYPPoint){
    if(isOnRightPath){      
       isOnRightPath  = false;
    }else{
      isOnRightPath  = true;
    }
    return true;
  }
  return false;
}