public class RealPoint{
  private float x;
  private float y;
  
  public RealPoint(PVector p){
    this.x = p.x;
    this.y = p.y;
  }
  
  public RealPoint(RealPoint p){
    this.x = p.getX();
    this.y = p.getY();
  }
  
  public RealPoint(float xV, float yV){
    this.x = xV;
    this.y = yV;
  }
  
  public void setX(float value){
    this.x = value;
  }
  
  public void setY(float value){
    this.y = value;
  }
  
  public float getX(){
    return this.x;
  }
  
  public float getY(){
    return this.y;
  }
  
  @Override
  public String toString(){
    StringBuilder str = new StringBuilder();
    str.append("[" + this.x + "," + this.y + "]");
    return str.toString();
  }
  
  public boolean equals(Object o){
    if(o instanceof RealPoint){
      RealPoint p = (RealPoint) o;
      return this.x == p.x && this.y == p.y;
    }
    return false;
  }
  
  
  public float distance(RealPoint p2){
    RealPoint p1 = this;
    return sqrt(sq(p2.x - p1.x) + sq(p2.y - p1.y));
  }
  
  public RealPoint nearestPoint(){
    RealPoint point = this;
    RealPoint minimalDistantPoint = null;
    float minDistance = 10000;
    for(PVector p: points){
      RealPoint p1 = new RealPoint(p);
      if(!p1.equals( point)){
        if(distance(p1) < minDistance){
          minDistance = distance(p1);
          minimalDistantPoint = p1;
        }
      }
    }
    return minimalDistantPoint;
  }
}