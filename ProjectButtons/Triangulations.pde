void voronoiDiagrams(){
}


void delaunayTriangulation(){
}

void triangulation(){
  if(polyLines.size()>3){
    ArrayList<PVector> lexiPolyLines = lexiSort(polyLines);
    //polyLines = lexiPolyLines;
    ArrayList<PVector> rightP;
    ArrayList<PVector> leftP;
    //polyLines = lexiSort(polyLines);
    
    printPVectorList(polyLines);
    println("min y point " + minYPPoint );
    println("max y point " + maxYPPoint );
    int upperPointIndex = polyLines.indexOf(minYPPoint);
    int lowerPointIndex = polyLines.indexOf(maxYPPoint);
    
    println("upper point index " + upperPointIndex );
    println("lower y point index " + lowerPointIndex );
    Integer[] nearIndices = getNearIndices(polyLines.size(), upperPointIndex);
    println("bigger index " + nearIndices[1] );
    println("smaller index " + nearIndices[0] );
    PVector a = polyLines.get(nearIndices[0]);
    PVector b = polyLines.get(nearIndices[1]);
    
    CyclicList l = new CyclicList(polyLines);
    
    
    
    if(a.x < b.x){
      rightPath = l.getElementsBetween( upperPointIndex , lowerPointIndex, "N");
      println("right path");
      printPVectorList(rightPath);
      leftPath = l.getElementsBetween( upperPointIndex , lowerPointIndex, "P");
      println("left path");
      printPVectorList(leftPath);
      //od max(aj) -> a -> do min je RIGHT PATH
      //od min(aj) -> b -> do max je LEFT PATH
    }else{
      
      leftPath = l.getElementsBetween( upperPointIndex , lowerPointIndex, "N");
      println("left path");
      printPVectorList(leftPath);
      rightPath = l.getElementsBetween( upperPointIndex , lowerPointIndex, "P");
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