public class CyclicList{
  private ArrayList<PVector> vectors;
  
  public CyclicList(ArrayList<PVector> arr){
    vectors = new ArrayList<PVector>(arr);
  }
  
  public void addVector(PVector vec){
    vectors.add(vec);
  }
  
  public void removeVector(PVector vec){
    vectors.remove(vec);
  }
  
  public PVector getNext(int index){
    return vectors.get(getNextIndex(index));
  }
  
  public PVector getPrevious(int index){
    return vectors.get(getPreviousIndex(index));
  }
  
  
  public int getNextIndex(int index){
    if(index >= vectors.size() - 1){
      return 0;
    }
    return index + 1;
  }
  
  public int getPreviousIndex(int index){
    if(index <= 0){
      return vectors.size() - 1;
    }
    return index - 1;
  }
  
  public ArrayList<PVector> getElementsBetween(int indexA, int indexC, String NorP){
    ArrayList<PVector> elem = new ArrayList<PVector>();
    int i = indexA;
    println("NorP in getElementsBetween " + NorP);
    if(NorP == "N"){
      while(i != indexC){
        elem.add(this.getNext(i));
        i = getNextIndex(i);
        println("i = " + i);
      }
    }
    if(NorP == "P"){
      while(i != indexC){
        elem.add(this.getPrevious(i));
        i = getPreviousIndex(i);
        println("i = " + i);
      }
    }
    
    return elem;
    
  }
}