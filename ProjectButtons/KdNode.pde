public class KdNode{
  
  public int k = 2; // dimensionality
  private int depth = 0; // current depth
  private PVector coordinates = null; // point representation
  private KdNode parent = null; // pointer to parent node
  private KdNode left = null; // pointer to left child
  private KdNode right = null; // pointer to right child
  private Line line = null;
  
  
   public KdNode(int depth, PVector coordinates, KdNode parent){
    this.depth = depth;
    this.coordinates = coordinates;
    this.parent = parent;
    this.left = null;
    this.right = null;
  }
  
  public KdNode(int depth, PVector coordinates, KdNode parent, KdNode left, KdNode right){
    this.depth = depth;
    this.coordinates = coordinates;
    this.parent = parent;
    this.left = left;
    this.right = right;
  }
  
  public KdNode(int depth, PVector coordinates, KdNode left, KdNode right){
    this.depth = depth;
    this.coordinates = coordinates;
    this.parent = null;
    this.left = left;
    this.right = right;
  }
  
  public KdNode(int depth, PVector coordinates){
    this.depth = depth;
    this.coordinates = coordinates;
    this.parent = null;
    this.left = null;
    this.right = null;
  }
  
  public void setDepth(int depth){
    this.depth = depth;
  }
  
  public int getDepth(){
    return depth;
  }
  
  public void setCoordinates(PVector coord){
    this.coordinates = coord;
  }
  
  public PVector getCoordinates(){
    return coordinates;
  }
  
  public void setParent(KdNode parent){
    this.parent = parent;
  }
  
  public KdNode getParent(){
    return parent;
  }
  
  public void setLeft(KdNode left){
    this.left = left;
  }
  
  public KdNode getLeft(){
    return left;
  }
  
  public void setRight(KdNode right){
    this.right = right;
  }
  
  public KdNode getRight(){
    return right;
  }
  
  public void setLine(PVector p1, PVector p2){
    this.line = new Line(p1, p2);
    this.checkForCrossings();
  }
  
  public Line getLine(){
    return this.line;
  }
  
  @Override
  public String toString(){
    StringBuilder str = new StringBuilder();
    str.append(this.depth + ", [" + this.coordinates.x + "," + this.coordinates.y + "]:");
    if(this.line != null){
      str.append(line);
    }
    return str.toString();
  }
  
  public boolean isOnLeftSide(){
    KdNode node = this;
    while(node != root){
      if(node.parent == root){
        
        if(root.getLeft() == node){
          return true;
        }else{
          return false;
        }
      }
      node = node.parent;
    }
    return false;
  }
  
  public boolean isOnRightSide(){
    KdNode node = this;
    while(node != root){
      if(node.parent == root){
        
        if(root.getRight() == node){
          return true;
        }else{
          return false;
        }
      }
      node = node.parent;
    }
    return false;
  }
  
  public boolean checkForCrossings(){
    KdNode node = this.getParent();
    boolean isCrossing = false;
    while(node != null && node != root ){
      
      if(node.getLine() != null){
         PVector crossingPoint = this.line.isCrossingLine(node.getLine());
         if(crossingPoint!= null){
           //println(this.line + "is crossing " + node.getLine() + " in the point " + crossingPoint);
           this.line.changeExtremePointOfLine(crossingPoint);
           isCrossing = true;
         }
      }
      node = node.getParent();
    }
    return isCrossing;
  }
  
  public int minYAncestor(){
    KdNode node = this.parent;
    int minY = Integer.MAX_VALUE;
    while(node != root){
      if(node.getCoordinates().y < minY){
        minY = (int)node.getCoordinates().y;
      }
      node = node.parent;
    }
    return minY;
  }
  
  public int minXAncestor(){
    KdNode node = this.parent;
    int minX = Integer.MAX_VALUE;
    while(node != root){
      if(node.getCoordinates().x < minX){
        minX = (int)node.getCoordinates().x;
      }
      node = node.parent;
    }
    return minX;
  }
  
  public int maxYAncestor(){
    KdNode node = this.parent;
    int maxY = Integer.MIN_VALUE;
    while(node != root){
      if(node.getCoordinates().y > maxY){
        maxY = (int)node.getCoordinates().y;
      }
      node = node.parent;
    }
    return maxY;
  }
  
  public int maxXAncestor(){
    KdNode node = this.parent;
    int maxX = Integer.MIN_VALUE;
    while(node != root){
      if(node.getCoordinates().x > maxX){
        maxX = (int)node.getCoordinates().x;
      }
      node = node.parent;
    }
    return maxX;
  }
}