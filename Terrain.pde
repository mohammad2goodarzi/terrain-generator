class Terrain {
  int seed;
  int chuncksNumber = 49;
  int pointsNumber = 100;
  Chunck[] chuncks;
  
  Event newChunckEvent;
  CounterEvent drawChunckEvent1;
  CounterEvent drawChunckEvent2;
  CounterEvent drawChunckEvent3;
  CounterEvent drawChunckEvent4;
  
  
  public Terrain(int seed){
    this.seed = seed;
    chuncks = new Chunck[chuncksNumber];
    generateNewChunck(chuncksNumber / 2);
    chuncks[chuncksNumber/2].drawWholeChunck();
    newChunckEvent = new Event();

    drawChunckEvent1 = new CounterEvent();
    drawChunckEvent2 = new CounterEvent();
    drawChunckEvent3 = new CounterEvent();
    drawChunckEvent4 = new CounterEvent();
  }
  
  void generateNewChunck(int chunckIndex){
    chuncks[chunckIndex] = new Chunck(seed, pointsNumber, chunckIndex);
  }  
  
  private void loadChunckCondition(Player player){
    int temp1 = int(player.getX() / (width / sqrt(chuncksNumber)));
    int temp2 = int(player.getY() / (height / sqrt(chuncksNumber)));
    int chunckIndex = int(sqrt(chuncksNumber))*temp1 + temp2;
    if(chuncks[chunckIndex] == null){
      newChunckEvent.set(chunckIndex);
    }
  }
  
  private void loadNewChunck(){
    if(newChunckEvent.isOccurred()){
      int chunckIndex = newChunckEvent.getEventCode();
      chuncks[chunckIndex] = new Chunck(mapSeed, pointsNumber, chunckIndex);
      int chuncksPartNumber = 16;
      if (!drawChunckEvent1.isOccurred()){
        newChunckEvent.unset();
        drawChunckEvent1.set(chunckIndex, chuncksPartNumber);
      }
      else if (!drawChunckEvent2.isOccurred()){
        newChunckEvent.unset();
        drawChunckEvent2.set(chunckIndex, chuncksPartNumber);
      }
      else if (!drawChunckEvent3.isOccurred()){
        newChunckEvent.unset();
        drawChunckEvent3.set(chunckIndex, chuncksPartNumber);
      }
      else if (!drawChunckEvent4.isOccurred()){
        newChunckEvent.unset();
        drawChunckEvent4.set(chunckIndex, chuncksPartNumber);
      }

    }
  }
  
  private void drawChunck(){
    if(drawChunckEvent4.isOccurred()){
      int chunckIndex = drawChunckEvent4.getEventCode();
      chuncks[chunckIndex].drawChunck();
      drawChunckEvent4.decrease();
    }
    else if(drawChunckEvent3.isOccurred()){
      int chunckIndex = drawChunckEvent3.getEventCode();
      chuncks[chunckIndex].drawChunck();
      drawChunckEvent3.decrease();
    }
    else if(drawChunckEvent2.isOccurred()){
      int chunckIndex = drawChunckEvent2.getEventCode();
      chuncks[chunckIndex].drawChunck();
      drawChunckEvent2.decrease();
    }
    else if(drawChunckEvent1.isOccurred()){
      int chunckIndex = drawChunckEvent1.getEventCode();
      chuncks[chunckIndex].drawChunck();
      drawChunckEvent1.decrease();
    }
  }
  
  public void draw(Player player){
    loadChunckCondition(player);
    loadNewChunck();
    drawChunck();
    player.move();
    player.draw();
  }

  
}
