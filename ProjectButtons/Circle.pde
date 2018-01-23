public class Circle{
  private RealPoint center;
  private float radius;
  
  public Circle(RealPoint centerV, float radiusV){
    this.center = centerV;
    this.radius = radiusV;
  }
  
  public void setCener(RealPoint value){
    this.center = value;
  }
  
  public void setRadius(float value){
    this.radius = value;
  }
  
  public RealPoint getCenter(){
    return this.center;
  }
  
  public float getRadius(){
    return this.radius;
  }
  
  public boolean inside(RealPoint p){    
    return this.center.distance(p) < radius;
  }
}