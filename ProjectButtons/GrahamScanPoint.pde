public class GrahamScanPoint implements Comparable{
  private PVector place;
  //if 360 then it is the base point (biggest X coordinate)
  private float angle;
  
  public float getAngle(){
    return angle;
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
  
}