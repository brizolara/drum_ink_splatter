//  A specific fixed-size array of Splatters.
public class SplatterPool
{
  Splatter [] members;
  int max_size;
  int actual_n_members = 0;
  int firstFreePosition = 0;
  int actualFirst = -1;
  
  SplatterPool(int a_size)
  {
    max_size = a_size;
    members = new Splatter[a_size];
    for(int i=0; i<max_size; i++) {
      members[i] = null;
    }
  }
  
  boolean push(Splatter aSplatter) {
    if(actual_n_members < max_size)
    {
      members[/*actual_n_members*/firstFreePosition] = aSplatter;
      actual_n_members++;
      if(actual_n_members == max_size) {  //  list is full
        firstFreePosition = -1;
        actualFirst       = 0;
      }
      else if(firstFreePosition+1 == max_size) // not full, but last is filled
      {
        for(int i=0; i<max_size; i++) {
          if(members[i] != null) {
            actualFirst       = i;
            break;
          }
        }
        for(int i=0; i<max_size; i++) {
          if(members[i] == null)
          {
            firstFreePosition = i;
            break; 
          }
        }
      }
      else {  //  last is not filled
        for(int i=0; i<max_size; i++) {
          if(members[i] != null)
          {
            actualFirst = i;
            break; 
          }
        }
        for(int i=0; i<max_size; i++) {
          if(members[i] == null)
          {
            firstFreePosition = i;
            break; 
          }
        }
      }
      println("pushed. " + actual_n_members + " members");
      println("actualFirst = " + actualFirst + " | firstFreePosition = " + firstFreePosition);
      return true;
    }
    return false;
  }
  
  /*boolean pop() {
    if(actual_n_members > 0) {
      members[actual_n_members-1] = null;
      actual_n_members--;
      return true;
    }
    return false;
  }*/
  
  boolean removeActualFirst() {
    
    /*if(actual_n_members == max_size) {
      members[0] = null;
      actualFirst       = 1;
      firstFreePosition = 0;
      println("actualFirst = " + actualFirst + " | firstFreePosition = " + firstFreePosition);
      return true;
    }*/
    
    if(actual_n_members > 0) {
      members[actualFirst] = null;
      actual_n_members--;
      if(actualFirst+1 == max_size) {
        for(int i=0; i<max_size; i++) {
          if(members[i] != null) {
            actualFirst = i;
            break;
          }
        }
      }
      else {
        actualFirst++;
      }
      
      for(int i=0; i<max_size; i++) {
        if(members[i] == null) {
          firstFreePosition = i;
          break;
        }
      }
      println("actualFirst = " + actualFirst + " | firstFreePosition = " + firstFreePosition);
      return true;
    }
    println("Error in removeActualFirst() or called in empty list"); 
    return false;
  }
  
  Splatter at(int i) {
    return members[i]; 
  }
  
  int getActualSize() {
    return  actual_n_members;
  }
  
  int getMaxSize() {
    return max_size; 
  }
  
  Splatter getActualFirst_member() {
    return members[actualFirst];
  }
  
  int getActualFirst_index() {
    return actualFirst;
  }
  
  /*Splatter last() {
    if(actual_n_members > 0)
      return members[actual_n_members-1];
    else
      return null;
  }*/
  
}
