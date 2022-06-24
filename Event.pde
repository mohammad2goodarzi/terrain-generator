class Event{
  boolean eventOccurred;
  int eventCode;
  
  public Event(){
    eventOccurred = false;
  }
  
  public void set(int eventCode){
    eventOccurred = true;
    this.eventCode = eventCode;
  }
  public void unset(){
    eventOccurred = false;
  }
  
  public int getEventCode(){
    return eventCode;
  }
  public boolean isOccurred(){
    return eventOccurred;
  }
}

class CounterEvent extends Event{
  int counter;
  public void set(int eventCode, int counter){
    super.set(eventCode);
    this.counter = counter;
  }
  
  public void decrease(){
    counter--;
    if(counter == 0){
      unset();
    }
  }
}
