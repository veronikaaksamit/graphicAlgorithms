//Triangulation
ArrayList<PVector> rightPath, leftPath;
boolean isOnRightPath = false;
ArrayList<PVector> triangulation;

ArrayList<ActiveEdge> activeEdgesL;
ArrayList<ActiveEdge> DT;
Circle c;

ArrayList<Line> VD;

void voronoiDiagrams(){
  if(DT!= null){
    for (int i = 0; i < DT.size(); i ++) {
      Circle c1 = new Circle();
      if(i % 3 == 2){
        c.circumCircle(DT.get(i-2).getP1(), DT.get(i-1).getP1(), DT.get(i).getP1());
        
        if(DT.get(i).getTwin() != null && DT.get(i).getTwin().getNext()!= null){
          c1.circumCircle(DT.get(i).getP1(), DT.get(i).getP2(), DT.get(i).getTwin().getNext().getP2());
          Line l = new Line(c.getCenter(), c1.getCenter());
          VD.add(l);
        }else{
          //Line l = new Line(c.getCenter(),);
        }
        
        if(DT.get(i-1).getTwin() != null && DT.get(i-1).getTwin().getNext()!= null){
          c1.circumCircle(DT.get(i-1).getP1(), DT.get(i-1).getP2(), DT.get(i-1).getTwin().getNext().getP2());
          Line l = new Line(c.getCenter(), c1.getCenter());
          VD.add(l);
        }else{
          //Line l = new Line(c.getCenter(),);
        }
        
        if(DT.get(i-2).getTwin() != null && DT.get(i-2).getTwin().getNext()!= null){
          c1.circumCircle(DT.get(i-2).getP1(), DT.get(i-2).getP2(), DT.get(i-2).getTwin().getNext().getP2());
          Line l = new Line(c.getCenter(), c1.getCenter());
          VD.add(l);
        }else{
          //Line l = new Line(c.getCenter(), );
        }
      }
    }
  }
}


void delaunayTriangulation(){
  if(points.size() >= 3){
    activeEdgesL = new ArrayList<ActiveEdge>();
    DT = new ArrayList<ActiveEdge>();
    maxXPoint = getMaxXPoints(points).get(0);
    
    RealPoint p1 = new RealPoint(maxXPoint);
    RealPoint p2 =  p1.nearestPoint();
    
    RealPoint p3 = smallestDelaunayDistancePoint(p1, p2, points);
    if(p3 == null){      
      println("Could not find p for "+ p1 +" "+ p2);
      RealPoint tmp = p1;
      p1 = p2;
      p2 = tmp;
      p3 = smallestDelaunayDistancePoint(p1,p2, points);
    }
    
    if(p3!= null){
      
      println(p1 +""+ p2 + " " + p3);
      c.circumCircle(p1, p2, p3);
      
      ActiveEdge e1 = new ActiveEdge(p1,p2);
      ActiveEdge e2 = new ActiveEdge(p2,p3);
      ActiveEdge e3 = new ActiveEdge(p3,p1);
      activeEdgesL = new ArrayList<ActiveEdge>();
      
      addToAEL(e1, e2, e3);
      
      ArrayList<PVector> tmpPoints = new ArrayList<PVector>(points);
      removeFromTmpPoints(p1, p2, p3, tmpPoints);
      
      while(activeEdgesL.size() > 0){
        e1 = activeEdgesL.get(0).swapOrientation();
        p3 = smallestDelaunayDistancePoint(e1.getP1(), e1.getP2(), tmpPoints);
        //println(e1 + " p3 ="+ p3);
        if(p3!= null){
          e2 =  new ActiveEdge(e1.getP2(), p3);
          e3 = new ActiveEdge(p3, e1.getP1());
          activeEdgesL.get(0).setTwin(e1);
          addToAEL(e1, e2, e3);
          removeFromTmpPoints(e1.getP1(), e1.getP2(), p3, tmpPoints);
        }
        removeFromAEL(e1.swapOrientation());
      }
      printDelaunayTriangulation();
    }
  }
}

public ArrayList<PVector> removeFromTmpPoints(RealPoint p1, RealPoint p2, RealPoint p3, ArrayList<PVector>tmpPoints){
  ArrayList<PVector>result = new ArrayList<PVector>(tmpPoints);
  for(int i =  tmpPoints.size() - 1; i >= 0 ; i--){
    if(tmpPoints.get(i).x == p1.getX() &&  tmpPoints.get(i).y == p1.getY()){
      result.remove(i);
    }
    if(tmpPoints.get(i).x == p2.getX() &&  tmpPoints.get(i).y == p2.getY()){
      result.remove(i);
    }
    if(tmpPoints.get(i).x == p3.getX() &&  tmpPoints.get(i).y == p3.getY()){
      result.remove(i);
    }
  }
  return result;
}

public void printDelaunayTriangulation(){
  println("Delaunay Triangulation result");
  for(ActiveEdge ae : DT){
    println(ae);
  }
}

public RealPoint smallestDelaunayDistancePoint(RealPoint p1, RealPoint p2, ArrayList<PVector> pointList){
  Circle c1 = new Circle();
  RealPoint smallerDistPoint = null;
  
  for(int i = 0; i < pointList.size() ; i++){
    RealPoint p = new RealPoint(pointList.get(i));
    
    if(!p.equals(p1) && !p.equals(p2)){
      //println("Not p1, p2 point" + p);
      if(c1.getCenter() == null){
        //println("c1.getCenter() is null");
        if(!leftCrit(p1, p2, p)){
          //println("Left crit NOK");
          c1.circumCircle(p1,p2,p);
          smallerDistPoint = p;
        }
      }else{
        //println("c1.getCenter() is  NOT null");
        if(c1.inside(p)){
          //println(p + "p is inside");
          if(!leftCrit(p1, p2, p)){
            //println("Left crit NOK");
            c1.circumCircle(p1,p2,p);
            smallerDistPoint = p;
          }
        }
      }
    }
  }
  return smallerDistPoint;
}

void triangulation(){
  if(points.size()>3 && polygons.size() < 3){
    grahamScan();
  }
  
  println("Triangulation by sweep line");
  if (polygons.size()>3){
      removePointsInsidePolygon();
      ArrayList<PVector> lexipolygonsY = lexiSortY(polygons);
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
    printPVectorList(lexipolygonsY);
  
    iterator = 2;
    ArrayList<PVector> stack = new ArrayList<PVector> ();
      
    stack.add(lexipolygonsY.get(0));
    stack.add(lexipolygonsY.get(1));
    
    for (int j = 2; j <= lexipolygonsY.size() - 1 ; j++){
      
      PVector B = stack.get(stack.size() - 1);
      PVector C = lexipolygonsY.get(j);
      PVector A;
      
      //println(" B=" + B + " C=" + C );
      print("STACK: ");
      printPVectorList(stack);
      
      if(!onSamePath(B, C)){
        for(int i = stack.size() - 1; i >= 1 ; i--){
            addEdge(stack.get(i), C);
            //println("adding " + stack.get(i) + " "+ C);
        }
        stack.clear();
        stack.add(B);
        stack.add(C);
      }else{
        A = stack.get(stack.size() - 2);
        //println("We are here"+ A +" B="+B+" C="+C );
        
        if(bothOnPath(B, C, rightPath)){
          //println("Both on right path");
          if(!leftCrit(A, B, C)){
            //println("left crit right path = NOK");
            stack.add(C);
          }else{
            //println("turning RIGHT " + leftCrit(A, B, C));
            while(leftCrit(A, B, C) ){
              addEdge(A,C);
              //println("left crit right path = NOK");
              //println ("added edge both on 1 side " + A + " " + C);
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
          //println("Both on left path");
          if(leftCrit(A, B, C)){
            //println("left crit  left path = OK");
            stack.add(C);
          }else{
             while(!leftCrit(A, B, C)){
                addEdge(A,C);
                //println("left crit  left path = OK");
                //println ("added edge both on 1 side " + A+ " " + C);
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
  int indexA = polygons.indexOf(A);
  int indexB = polygons.indexOf(B);
  Integer[] indicesA = getNearIndices(polygons.size(), indexA);
  Integer[] indicesB = getNearIndices(polygons.size(), indexB);
  if(Arrays.asList(indicesA).contains(indexB)){
    return;
  }
  if(Arrays.asList(indicesB).contains(indexA)){
    return;
  }
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