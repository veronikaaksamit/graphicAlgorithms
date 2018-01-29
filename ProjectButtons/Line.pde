public class Line{
  //NOT IMPLEMENTED ...it should be ...LEFT to RIGHT
  //NOT IMPLEMENTED ...it should be ...TOP to BOTTOM
  
  private PVector point1;
  
  private PVector point2;
  
  public Line(PVector p1, PVector p2){
    this.point1 = p1;
    this.point2 = p2;
  }
  
  public Line(RealPoint p1, RealPoint p2){
    this.point1 = new PVector(p1.getX(), p1.getY());
    this.point2 = new PVector(p2.getX(), p2.getY());
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
  
  public PVector isCrossingLine(Line line2){
    Line line1 = this;
    boolean canCross1 = false;
    boolean canCross2 = false;
    
    PVector point = null;
    
    if(line1.isVertical()){
      canCross1 = isInTheInterval((int)line1.point1.x, (int)line2.getPoint1().x, (int)line2.getPoint2().x);
      canCross2 = isInTheInterval((int)line2.getPoint1().y, (int)line1.point1.y, (int)line1.point2.y);
      if(canCross1 && canCross2){
        point = new PVector(line1.point1.x, line2.getPoint1().y);
      }
    }
    
    canCross1 = false;
    canCross2 = false;
    if(line1.isHorizontal()){
      
      canCross1 = isInTheInterval((int)line2.getPoint1().x, (int)line1.point1.x, (int)line1.point2.x);
      /*if(canCross1){
        println("CanCross1 H" + line1);
      }*/
      canCross2 = isInTheInterval((int)line1.point1.y, (int)line2.getPoint1().y, (int)line2.getPoint2().y);
      /*if(canCross2){
        println("CanCross2 H" + line1);
      }*/
      if(canCross2 && canCross1){
        point = new PVector(line2.getPoint1().x, line1.point1.y);
        //println("Horizontal line is crossing " + point);
      }
    }
    
    return point;
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
  
  public void changeExtremePointOfLine(PVector crossingPoint){
    //println("trying to solve " + this + " " + crossingPoint);
    if(this.isVertical()){
      //println("Is vertical");
      if(this.getPoint1().y == 0){
        this.setPoint1(crossingPoint);
      }else{
        this.setPoint2(crossingPoint);
      }
    }
    
    if(this.isHorizontal()){
      //println("Is horizontal");
      if(this.getPoint1().x == butSizeX){
        this.setPoint1(crossingPoint);
      }else{
        this.setPoint2(crossingPoint);
      }
    }
  }
}