public class ActiveEdge{
  private ActiveEdge next;
  private ActiveEdge twin;
  
  private RealPoint p1;
  private RealPoint p2;
  
  public ActiveEdge(RealPoint firstP, RealPoint secondP){
    this.p1 = firstP;
    this.p2 = secondP;
  }
  
  public ActiveEdge(RealPoint firstP, RealPoint secondP, ActiveEdge next){
    this.p1 = firstP;
    this.p2 = secondP;
    this.next = next;
  }
  
  public void setActiveEdges(ActiveEdge n, ActiveEdge t){
    this.next = n;
    this.twin = t;
  }
  
  /*
  If the flag is N => next is set, if T => twin is set
  */
  public void setActiveEdges(ActiveEdge ae, String flag){
    switch(flag){
      case "N": this.next = ae;
                break;
      case "T": this.twin = ae;
                break;
    }
  }
  
  public void setNext(ActiveEdge n){
    this.next = n;
  }
  
  public void setTwin(ActiveEdge t){
    this.twin = t;
  }
  
  public ActiveEdge getNext(){
    return this.next;
  }
  
  public ActiveEdge getTwin(){
    return this.twin;
  }
  
  public RealPoint minDelDistPoint(ArrayList<PVector> points){
    ActiveEdge
  } 
}