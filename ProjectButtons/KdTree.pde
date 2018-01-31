KdNode root;

void kDTree(){
  if(points.size()>0){
    
    ArrayList<PVector> lexiPointsByX = new ArrayList<PVector>(lexiSortX(points));
    /*for (int i = 0; i < lexiPointsByX.size(); i++ ){
      println(lexiPointsByX.get(i));
    }*/
    root = kDDivideX(null, lexiPointsByX);
    println("Root:" + root);
    printTree(root);
    setLinesForTree();
    
    checkForCrossingsInTheTree(root);
    
  }else{
    addMode = true;
  }
}

KdNode kDDivideX(KdNode parent, ArrayList<PVector> lexiPointsByX){
  ArrayList<PVector> P1, P2;
  PVector halfPoint;
  KdNode node1 = null;
  KdNode node2 = null;
  
  halfPoint = getHalfPointIndex(lexiPointsByX);
  
  P1 = new ArrayList<PVector>(lexiPointsByX.subList(0, lexiPointsByX.indexOf(halfPoint)));
  lexiPointsByX.removeAll(P1);
  P2 = new ArrayList<PVector>(lexiPointsByX);
  P1 = lexiSortY(P1);
  P2 = lexiSortY(P2); 
  
  int depth = 0;
  if(parent != null){
    depth = parent.getDepth() + 1;
  }
  
  KdNode newKd = new KdNode(depth, halfPoint, parent);
  /*println("P1");
  printPVectorList(P1);
  println("P2");
  printPVectorList(P2);*/
  if(P1.size() > 1){
    node1 = kDDivideY(newKd, P1);
  }
  
  if(P2.size() > 1){
    node2 = kDDivideY(newKd, P2);
  }
  
  newKd.setLeft(node1);
  newKd.setRight(node2);
  return newKd;
}

KdNode kDDivideY(KdNode parent, ArrayList<PVector> lexiPointsByY){
  Collections.reverse(lexiPointsByY);
  //printPVectorList(lexiPointsByY);
  
  ArrayList<PVector> P3, P4;
  PVector halfPoint;
  KdNode node1 = null;
  KdNode node2 = null;
  
  halfPoint = getHalfPointIndex(lexiPointsByY);
  
  P3 = new ArrayList<PVector>(lexiPointsByY.subList(0, lexiPointsByY.indexOf(halfPoint)));
  lexiPointsByY.removeAll(P3);
  P4 = new ArrayList<PVector>(lexiPointsByY);
  P3 = lexiSortX(P3);
  P4 = lexiSortX(P4); 
  
  int depth = 0;
  if(parent != null){
    depth = parent.getDepth() + 1;
  }
  KdNode newKd = new KdNode(depth, halfPoint, parent);
  
  if(P3.size() > 1){
    node1 = kDDivideX(newKd, P3);
  }
  
  if(P4.size() > 1){
    node2 = kDDivideX(newKd, P4);
  }
  
  newKd.setLeft(node2);
  newKd.setRight(node1);
  
  return newKd;
  
}

PVector getHalfPointIndex(ArrayList<PVector> points){
  int size = points.size();
  PVector halfPoint = null;
  
  if(size % 2 == 1){
    int sHalf = ((size + 1)/2) - 1;
    halfPoint = points.get(sHalf); 
    //println("sHalf " + sHalf + " point" + halfPoint);
  }else{
    halfPoint = points.get((size/2));
  }
  
  return halfPoint;
}

void printTree(KdNode node){
  println(node);
  
  if(node.getLeft()!= null){
    printTree(node.getLeft());
  }
  if(node.getRight()!= null){
    printTree(node.getRight());
  }
}

void checkForCrossingsInTheTree(KdNode node){
  node.checkForCrossings();
  if(node.getLeft()!= null){
    checkForCrossingsInTheTree(node.getLeft());
  }
  if(node.getRight()!= null){
    checkForCrossingsInTheTree(node.getRight());
  }
}

void setLinesForTree(){
  setVertical(root);
  //setting line for root
  PVector rootLinePoint1 = new PVector (root.getCoordinates().x, 0);
  PVector rootLinePoint2 = new PVector (root.getCoordinates().x, maxY);
  root.setLine(rootLinePoint1, rootLinePoint2);
}

void setVertical(KdNode node){
  PVector point2 = null;
  PVector point1 = null;
  
  if(node.getLeft()!= null){
    if(node.getLeft().isOnRightSide()){
      point1 = new PVector((int)root.getCoordinates().x, node.getLeft().getCoordinates().y);
      point2 = new PVector((int)node.getCoordinates().x, node.getLeft().getCoordinates().y);
      
      setHorizontal(node.getLeft());
    }else{
      setHorizontal(node.getLeft());
      
      point1 = new PVector(butSizeX, node.getLeft().getCoordinates().y);
      point2 = new PVector((int)node.getCoordinates().x, node.getLeft().getCoordinates().y);
      
    }
    
    node.getLeft().setLine(point1, point2 );
  }
  
  if(node.getRight()!= null){
    if(node.getRight().isOnLeftSide()){
       setHorizontal(node.getRight());
       
       point1 = new PVector((int)node.getCoordinates().x, node.getRight().getCoordinates().y);
       point2 = new PVector((int)root.getCoordinates().x, node.getRight().getCoordinates().y);
       
    }else{
      setHorizontal(node.getRight());
      
      point1 = new PVector((int)node.getCoordinates().x, node.getRight().getCoordinates().y);
      point2 = new PVector(maxX, node.getRight().getCoordinates().y);
    }
   
    node.getRight().setLine(point1, point2 );
  }
}

void setHorizontal(KdNode node){
  PVector point1 = null;
  PVector point2 = null;
  
  if(node.getLeft()!= null){
    setVertical(node.getLeft());
    
    point1 = new PVector((int)node.getLeft().getCoordinates().x, 0);
    point2 = new PVector((int)node.getLeft().getCoordinates().x, node.getCoordinates().y);
    
    node.getLeft().setLine(point1, point2);
  }
  
  if(node.getRight()!= null){
    setVertical(node.getRight()); 
    
    point1 = new PVector((int)node.getRight().getCoordinates().x, (int)node.getCoordinates().y);
    point2 = new PVector((int)node.getRight().getCoordinates().x, maxY);
    node.getRight().setLine(point1, point2);
  }
}