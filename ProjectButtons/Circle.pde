public class Circle{
  private RealPoint center;
  private float radius;
  
  public Circle(){
  }
  
  public Circle(RealPoint centerV, float radiusV){
    this.center = centerV;
    this.radius = radiusV;
  }
  
  public void setCenter(RealPoint value){
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
  
  public void circumCircle(RealPoint p1, RealPoint p2, RealPoint p3){
    float cp = crossProduct(p1,p2,p3);
    if ( cp != 0) {
      float p1Sq  = sq(p1.getX()) + sq(p1.getY());
      float p2Sq = sq(p2.getX()) + sq(p2.getY());
      float p3Sq = sq(p3.getX()) + sq(p3.getY());
      float num = p1Sq *(p2.getY() - p3.getY()) + p2Sq *(p3.getY() - p1.getY()) + p3Sq *(p1.getY() - p2.getY());
      float cx = num / (2.0f * cp );
      num = p1Sq *(p3.getX() - p2.getX()) + p2Sq*(p1.getX() - p3.getX()) + p3Sq*(p2.getX() - p1.getX());
      float cy = num / (2.0f * cp );
      this.setCenter(new RealPoint(cx, cy));
      this.setRadius(this.center.distance(p1));
    }
  }
  
  private float crossProduct(RealPoint p1, RealPoint p2, RealPoint p3){
    float u1= p2.getX() - p1.getX();
    float v1= p2.getY() - p1.getY(); 
    float u2= p3.getX() - p1.getX(); 
    float v2= p3.getY() - p1.getY();
    return u1* v2 - v1* u2;
  }
}