ArrayList<PVector> lexiSort(AbstractList<PVector> inLines){
  ArrayList<PVector> lines = new ArrayList<PVector>(inLines);
  ArrayList<PVector> result = new ArrayList<PVector>();
  float arraySize = lines.size();
  
  while (result.size() != arraySize){
    ArrayList<PVector> minY = getMinYPoints(lines);
    while (minY.size() > 0){
      PVector point = getMinXPoint(minY);
      result.add(point);
      minY.remove(point);
      lines.remove(point);
      println(point);
    }  
  }
  
  return result;
}

boolean leftCriterion(ArrayList<GrahamScanPoint> gSPoints, int index){
  Integer[] nearIndices = getNearIndices(gSPoints.size(), index);
  //println("Near indices for "+ index + " are =" + nearIndices[1] + " " + nearIndices[0]);
  PVector p1 = gSPoints.get(nearIndices[0]).getCoordinates();
  PVector p2 = gSPoints.get(index).getCoordinates();
  PVector p3 = gSPoints.get(nearIndices[1]).getCoordinates();
  
  float resultInNum = (p2.x - p1.x)* (p3.y - p1.y) - (p2.y - p1.y) *(p3.x - p1.x);
  //println("result = "+  resultInNum );
  //println("p1 =" + p1.x +", p2 =" + p2.x +", p3 =" + p3.x);
  if (resultInNum >= 0) return true; //no need for deletion turns LEFT
  else return false;//need to remove middle point turns RIGHT
}

Integer[] getNearIndices(int arrayLSize, int index){
  Integer[] result = new Integer[2];
  if (arrayLSize < 2){
    return null;
  }
  
  //println("arraySize " + arrayLSize + " index: "+ index);
  if (index == 0){
    result[0] = 1;
    result[1] = arrayLSize - 1;
    return result;
  }
  
  if (index == arrayLSize - 1){
    result[0] = arrayLSize - 2;
    result[1] = 0;
    return result;
  }
  
  result[0] = index - 1;
  result[1] = index + 1;
  
  return result;
}

void printPVectorList(AbstractList<PVector> vectors){
  print("Starting print: ");
  for (int i = 0; i< vectors.size(); i++){
    print(i + ":["+ vectors.get(i).x + ", "+ vectors.get(i).y + "] ");
  }
  println(" Ending print");
}

void mouseReleased(){
  //NEED to have point to be moved, can not move it to button area
  if (moveMode == true &&  changingPoint != null && !inButtonsArea(mouseX, mouseY)){
    points.add(new PVector(mouseX, mouseY));
    
    //setting changingPoint to null after editation of point
    changingPoint = null;
  }
}

boolean isPoint(float x, float y){
  float distX = x - mouseX;
  float distY = y - mouseY;
  return sqrt(sq(distX) + sq(distY)) < pointSize/2 ;
}

//Are you over button?
boolean overBut(int x, int y) {
  if (mouseX >= x && mouseX <= x + butSizeX
      && mouseY >= y && mouseY <= y + butSizeY) {
    return true;
  } else {
    return false;
  }
}

//Whether you are in Buttons area 
boolean inButtonsArea(float x, float y){
  if (x < butSizeX + pointSize && y < butSizeY * numOfBut + pointSize){
    return true;
  }
  //IF WANT POINTS JUST IN RIGHT AREA NEXT TO BUTTONS
  if (x < butSizeX + pointSize && y < 540 + pointSize){
    return true;
  }
  return false;
}

//Setting modes of app 
void setModes(boolean add, boolean delete, boolean move, boolean createPoly){
  addMode = add;
  deleteMode = delete;
  moveMode = move;
  createPolyMode = createPoly;
}

void findMinAndMaxYPointForPolygons(){
  if (polygons != null){
    maxYPoint = getMaxYPoint(polygons);
    minYPoint = getMinYPoint(polygons);
  }else{
    println("Polygons are not set");
  }
  
}


ArrayList<PVector> getMinYPoints(AbstractList<PVector> lines){
  ArrayList<PVector> result = new ArrayList<PVector>();
  float min = MAX_FLOAT;
  for (PVector p : lines){
      if (p.y == min){
        result.add(p);
      }
      if (p.y < min){
        min = p.y;
        result.clear();
        result.add(p);
      }
  }
  return result;
}

ArrayList<PVector> getMinXPoints(AbstractList<PVector> lines){
  ArrayList<PVector> result = new ArrayList<PVector>();
  float min = MAX_FLOAT;
  for (PVector p : lines){
      if (p.x == min){
        result.add(p);
      }
      if (p.x < min){
        min = p.x;
        result.clear();
        result.add(p);
      }
  }
  return result;
}

ArrayList<PVector> getMaxXPoints(AbstractList<PVector> points){
  ArrayList<PVector> result = new ArrayList<PVector>();
  float max = 0;
  for (PVector p : points){
      if (p.x == max){
        result.add(p);
      }
      if (p.x > max){
        max = p.x;
        result.clear();
        result.add(p);
      }
  }
  return result;
}

ArrayList<PVector> getMaxYPoints(AbstractList<PVector> points){
  ArrayList<PVector> result = new ArrayList<PVector>();
  float max = 0;
  for (PVector p : points){
      if (p.y == max){
        result.add(p);
      }
      if (p.y > max){
        max = p.y;
        result.clear();
        result.add(p);
      }
  }
  return result;
}

PVector getMinYPoint(AbstractList<PVector> points){
  PVector result = null;
  float min = MAX_FLOAT;
  for (PVector p : points){
      if (p.y < min){
        min = p.y;
        result = p;
      }
  }
  return result;
}

PVector getMinXPoint(AbstractList<PVector> points){
  PVector result = null;
  float min = MAX_FLOAT;
  for (PVector p : points){
      if (p.x < min){
        min = p.x;
        result = p;
      }
  }
  return result;
}

PVector getMaxYPoint(AbstractList<PVector> points){
  PVector result = null;
  float max = 0;
  for (PVector p : points){
      if (p.y > max){
        max = p.y;
        result = p;
      }
  }
  return result;
}