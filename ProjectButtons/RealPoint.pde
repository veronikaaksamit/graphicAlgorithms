public class RealPoint{
  private float x;
  private float y;
  
  public RealPoint(PVector p){
    this.x = p.x;
    this.y = p.y;
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
  
  public float distance(RealPoint p2){
    RealPoint p1 = this;
    return sqrt(sq(p2.x - p1.x) + sq(p2.y - p1.y));
  }
}