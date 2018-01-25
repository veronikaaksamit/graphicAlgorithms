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
  
  public void circumCircle(RealPoint p1, RealPoint p2, RealPoint p3){
    float cp = crossProduct(p1,p2,p3);
    if ( cp <> 0) {
      float p1Sq  = sq(p1.getX()) + sq(p1.getY());
      float p2Sq = sq(p2.getX()) + sq(p2.getY());
      float 3Sq = sq(p3.getX()) + sq(p3.getY());
      /*num = p 1Sq *(p Sq *(p 2.y .y -p3.y) + p.y) + p .y) + p.y) + p 2Sq *(p Sq *(p 3.y -p1.y) + .y) + .y) + .y) + p3Sq *(p Sq *(pSq *(p 1.y -p2.y); .y); .y);
      cx = num / (2.0 * / (2.0 * / (2.0 * / (2.0 * / (2.0 * cp ); );
      num = p 1Sq *(p Sq *(pSq *(p 3.x -p2.x) + p .x) + p 2Sq*(p Sq*(p 1.x -p3.x) + .x) + p3Sq*(p Sq*(p 2.x -p1.x);
      cy = num / (2.0f * / (2.0f * cp ); ); c.set c.set(cx , cy );
      c.set(cx , cy ); );
      r = c.distance(p 1);*/
  }
  
  private float crossProduct(RealPoint p1, RealPoint p2, RealPoint p3){
    float u1= p2.getX() - p1.getX();
    float v1= p2.getY() - p1.getY(); 
    float u2= p3.getX() - p1.getX(); 
    float v2= p3.getY() - p1.getY();
    return u1* v2 - v1* u2;
  }
}