public class KdNode{
  
  public int k = 2; // dimensionality
  private int depth = 0; // current depth
  private PVector coordinates = null; // point representation
  private KdNode parent = null; // pointer to parent node
  private KdNode left = null; // pointer to left child
  private KdNode right = null; // pointer to right child
  
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
  @Override
  public String toString(){
    StringBuilder str = new StringBuilder();
    str.append(this.depth + ", [" + this.coordinates.x + "," + this.coordinates.y + "]:");
    return str.toString();
  }
  
}