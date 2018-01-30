public void addToAEL(ActiveEdge e1, ActiveEdge e2, ActiveEdge e3){
  if(!isInAEL(e1)){
    if(!isInAEL(e1.swapOrientation())){
      if(!isInDT(e1)){
        activeEdgesL.add(e1);
        //println(" Adding to AEL e1 "+ e1);
      }else{
        //println("Not adding to AEL e1 is in DT"+ e1);
      }
    }else{
      //println("Not adding to AEL e1 is in AEL switched"+ e1);
    }
  }else{
    //println("Not adding to AEL e1 is in AEL "+ e1);
  }
  
  if(!isInAEL(e2)){
    if(!isInAEL(e2.swapOrientation())){
      if(!isInDT(e2)){
        activeEdgesL.add(e2);
        //println(" Adding to AEL e2 "+ e2);
      }else{
        //println("Not adding to AEL e2 is in DT"+ e2);
      }
    }else{
      //println("Not adding to AEL e2 is in AEL switched"+ e2);
    }
  }else{
    //println("Not adding to AEL e2 is in AEL "+ e2);
  }
  
  if(!isInAEL(e3)){
    if(!isInAEL(e3.swapOrientation())){
      if(!isInDT(e3)){
        activeEdgesL.add(e3);
        //println(" Adding to AEL e3 "+ e3);
      }else{
        //println("Not adding to AEL e3 is in DT"+ e3);
      }
    }else{
      //println("Not adding to AEL e3 is in AEL switched"+ e3);
    }
  }else{
    //println("Not adding to AEL e3 is in AEL "+ e3);
  }
  
  DT.add(e1);
  output.println("Adding to DT e1 "+ e1);
  
  DT.add(e2);
  output.println("Adding to DT e2 "+ e2);
  
  DT.add(e3);
  output.println("Adding to DT e3 "+ e3);
  
}

public ActiveEdge findInDT(ActiveEdge ae){
  ActiveEdge result = null;
  for(int i = 0 ; i< DT.size() ; i++){
    if(DT.get(i).equals(ae)){
      if(DT.get(i).getTwin().getNext() != null){
        ae.setTwin(DT.get(i).getTwin());
        result = DT.get(i);
      }
    }
  }
  return result;
}

public boolean isInAEL(ActiveEdge ae){
  return activeEdgesL.indexOf(ae)!= -1; 
}

public boolean isInDT(ActiveEdge ae){
  return DT.contains(ae);
}

public void removeFromAEL(ActiveEdge ae){
  if(activeEdgesL.contains(ae)){
    activeEdgesL.remove(ae);
    //println("It was found "+ ae);
  }else{
     println("It was not found "+ ae);
  }
}
    