void delaunayTriangulation(){
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
    Integer[] nearIndices = getNearIndices(polyLines.size(), maxPointIndex);
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
    removeAllPoints();
    createPolyMode = true;
  }
}