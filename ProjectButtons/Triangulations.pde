void voronoiDiagrams(){
}


void delaunayTriangulation(){
}

void triangulation(){
  if (polygons.size()>3){
    ArrayList<PVector> lexipolygons = lexiSort(polygons);
    //polygons = lexipolygons;
    ArrayList<PVector> rightP;
    ArrayList<PVector> leftP;
    //polygons = lexiSort(polygons);
    
    printPVectorList(polygons);
    println("min y point " + minYPPoint );
    println("max y point " + maxYPPoint );
    int upperPointIndex = polygons.indexOf(minYPPoint);
    int lowerPointIndex = polygons.indexOf(maxYPPoint);
    
    println("upper point index " + upperPointIndex );
    println("lower y point index " + lowerPointIndex );
    Integer[] nearIndices = getNearIndices(polygons.size(), upperPointIndex);
    println("bigger index " + nearIndices[1] );
    println("smaller index " + nearIndices[0] );
    PVector a = polygons.get(nearIndices[0]);
    PVector b = polygons.get(nearIndices[1]);
    
    //CyclicList l = new CyclicList(polygons);
    
    
    
    if (a.x < b.x){
      //rightPath = l.getElementsBetween( upperPointIndex , lowerPointIndex, "N");
      println("right path");
      printPVectorList(rightPath);
      //leftPath = l.getElementsBetween( upperPointIndex , lowerPointIndex, "P");
      println("left path");
      printPVectorList(leftPath);
      //od max(aj) -> a -> do min je RIGHT PATH
      //od min(aj) -> b -> do max je LEFT PATH
    }else{
      
      //leftPath = l.getElementsBetween( upperPointIndex , lowerPointIndex, "N");
      println("left path");
      printPVectorList(leftPath);
      //rightPath = l.getElementsBetween( upperPointIndex , lowerPointIndex, "P");
      println("right path");
      printPVectorList(rightPath);
      
      //od max(aj) -> b -> do min je RIGHT PATH
      //od min(aj) -> a -> do max je LEFT PATH
    }
    
  }
   else{
    removeAllPoints();
    createPolyMode = true;
  }
}