KdNode root;

void kDTree(){
  if(points.size()>0){
    
    ArrayList<PVector> lexiPointsByX = new ArrayList<PVector>(lexiSortX(points));
    for (int i = 0; i < lexiPointsByX.size(); i++ ){
      println(lexiPointsByX.get(i));
    }
    root = kDDivideX(null, lexiPointsByX);
    println("Root:" + root);
    printTree(root);
    
  }else{
    addMode = true;
  }
}

KdNode kDDivideX(KdNode parent, ArrayList<PVector> lexiPointsByX){
  int size = lexiPointsByX.size();
  ArrayList<PVector> P1, P2;
  PVector halfPoint;
  KdNode node1 = null;
  KdNode node2 = null;
  
  if(size % 2 == 0){
    int sHalf = (size - 1)/2;
    halfPoint = lexiPointsByX.get(sHalf);    
  }else{
    halfPoint = lexiPointsByX.get(size/2);
  }
  
  
  P1 = new ArrayList<PVector>(lexiPointsByX.subList(0, lexiPointsByX.indexOf(halfPoint)));
  lexiPointsByX.removeAll(P1);
  P2 = new ArrayList<PVector>(lexiPointsByX);
  P1 = lexiSortY(P1);
  P2 = lexiSortY(P2); 
  
  int depth = 0;
  if(parent != null){
    depth = parent.getDepth() +1;
  }
  KdNode newKd = new KdNode(depth, halfPoint, parent);
  
  
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
  
  int size = lexiPointsByY.size();
  ArrayList<PVector> P1, P2;
  PVector halfPoint;
  KdNode node1 = null;
  KdNode node2 = null;
  
  if(size % 2 == 0){
    int sHalf = (size - 1)/2;
    halfPoint = lexiPointsByY.get(sHalf);    
  }else{
    halfPoint = lexiPointsByY.get(size/2);
  }
  
  
  P1 = new ArrayList<PVector>(lexiPointsByY.subList(0, lexiPointsByY.indexOf(halfPoint)));
  lexiPointsByY.removeAll(P1);
  P2 = new ArrayList<PVector>(lexiPointsByY);
  P1 = lexiSortX(P1);
  P2 = lexiSortX(P2); 
  
  int depth = 0;
  if(parent != null){
    depth = parent.getDepth() +1;
  }
  KdNode newKd = new KdNode(depth, halfPoint, parent);
  
  /*if(P1.size() > 1){
    node1 = kDDivideX(newKd, P1);
  }
  
  if(P2.size() > 1){
    node2 = kDDivideY(newKd, P2);
  }*/
  
  newKd.setLeft(node1);
  newKd.setRight(node2);
  
  return newKd;
  
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