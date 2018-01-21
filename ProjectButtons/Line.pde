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
  
  
  
}