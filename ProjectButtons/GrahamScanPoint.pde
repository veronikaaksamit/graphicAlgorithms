public class GrahamScanPoint implements Comparable{
  private PVector coordinates;
  //if 360 then it is the base point (biggest X coordinate)
  private float angle;
  
  public GrahamScanPoint(PVector coord, float angle){
    this.setCoordinates(coord);
    this.setAngle(angle);
  }
  
  
  public void setAngle(float angle){
    this.angle = angle;
  }
  
  public float getAngle(){
    return angle;
  }
  
  public void setCoordinates(PVector coord){
    this.coordinates = coord;
  }
  public PVector getCoordinates(){
    return coordinates;
  }
  
  @Override
  public int compareTo(Object obj ) {
    
      if (this == obj) {
        return 0;
      }
      
      GrahamScanPoint grahamScPoint = (GrahamScanPoint) obj;
      
      if (this.getAngle() < grahamScPoint.getAngle()) return -1;
      if (this.getAngle() > grahamScPoint.getAngle()) return 1;
      return 0;
  }
  
  @Override
  public String toString(){
    return "[ " + this.coordinates.x + ", " + this.coordinates.y + "] :" + angle ;
  }
  
}