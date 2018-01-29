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
    this.p1 = new RealPoint(firstP);
    this.p2 = new RealPoint(secondP);
    this.next = next;
  }
  
  public RealPoint getP1(){
    return this.p1;
  }
  
  public RealPoint getP2(){
    return this.p2;
  }
  
  @Override
  public String toString(){
    StringBuilder sb = new StringBuilder();
    sb.append(p1.toString() + "->" + p2.toString());
    return sb.toString();
  }
  
  @Override
  public boolean equals(Object o){
    if(o instanceof ActiveEdge){
      ActiveEdge e = (ActiveEdge) o;
      boolean tmp = this.getP1().x == e.getP1().x && this.getP2().x == e.getP2().x;
      return tmp && this.getP1().y == e.getP1().y && this.getP2().y == e.getP2().y;
    }
    return false;
  }
  
  public ActiveEdge swapOrientation(){
    ActiveEdge swappedEdge = new ActiveEdge(this.p2, this.p1);
    return swappedEdge;
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
}