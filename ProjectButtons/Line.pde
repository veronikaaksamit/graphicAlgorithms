public class Line{
  //NOT IMPLEMENTED ...it should be ...LEFT to RIGHT
  //NOT IMPLEMENTED ...it should be ...TOP to BOTTOM
  
  private PVector point1;
  
  private PVector point2;
  
  public Line(PVector p1, PVector p2){
    this.point1 = p1;
    this.point2 = p2;
  }
  
  public PVector getPoint1(){
    return this.point1;
  }
  
  public PVector getPoint2(){
    return this.point2;
  }
  
  public void setPoint1(PVector p1){
    this.point1 = p1;
  }
  
  public void setPoint2(PVector p2){
    this.point2 = p2;
  }
  
  @Override
  public String toString(){
    StringBuilder sb = new StringBuilder();
    sb.append(point1.toString() + "->" + point2.toString());
    return sb.toString();
  }
  
  public boolean isVertical(){
    if(point1 == point2){
      println("Points are identical, it is not the line");
      return false;
    }
    if(point1.x == point2.x){
      return true;
    }
    return false;
  }
  
  public boolean isHorizontal(){
    if(point1 == point2){
      println("Points are identical, it is not the line");
      return false;
    }
    if(point1.y == point2.y){
      return true;
    }
    return false;
  }
  
  public boolean isCrossingLine(Line line2){
    Line line1 = this;
    boolean canCross1 = false;
    boolean canCross2 = false;
    
    if(line1.isVertical()){
      canCross1 = isInTheInterval((int)line1.point1.x, (int)line2.getPoint1().x, (int)line2.getPoint2().x);
      canCross2 = isInTheInterval((int)line2.getPoint1().y, (int)line1.point1.y, (int)line1.point2.y);
      return canCross1 && canCross2;
    }
    if(line1.isHorizontal()){
      canCross1 = isInTheInterval((int)line2.getPoint1().x, (int)line1.point1.x, (int)line1.point2.x);
      canCross2 = isInTheInterval((int)line1.point1.y, (int)line2.getPoint1().y, (int)line2.getPoint2().y);
      return canCross1 && canCross2;
    }
    return canCross1 && canCross2;
  }
  
  private boolean isInTheInterval(int x, int a, int b){
    
    if(a < b){
      if( a < x && x < b){
        return true;
      }
    }else{
      if( b < x && x < a){
        return true;
      }
    }
    
    return false;
  }
}