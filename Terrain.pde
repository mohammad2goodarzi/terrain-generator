class Terrain {
  int seed;
  int chuncksNumber = 1;
  int pointsNumber = 300;
  Chunck[] chuncks;
  
  Event newChunckEvent1;
  Event newChunckEvent2;
  Event newChunckEvent3;
  Event newChunckEvent4;
  CounterEvent drawChunckEvent1;
  CounterEvent drawChunckEvent2;
  CounterEvent drawChunckEvent3;
  CounterEvent drawChunckEvent4;
  
  
  public Terrain(int seed){
    this.seed = seed;
    chuncks = new Chunck[chuncksNumber];
    generateNewChunck(chuncksNumber / 2);

    newChunckEvent1 = new Event();
    newChunckEvent2 = new Event();
    newChunckEvent3 = new Event();
    newChunckEvent4 = new Event();
    drawChunckEvent1 = new CounterEvent();
    drawChunckEvent2 = new CounterEvent();
    drawChunckEvent3 = new CounterEvent();
    drawChunckEvent4 = new CounterEvent();
    
    drawChunckEvent1.set(chuncksNumber / 2, 16);
  }
  
  private void generateNewChunck(int chunckIndex){
    chuncks[chunckIndex] = new Chunck(seed, pointsNumber, chunckIndex);
  }
  
  private void loadChunckOfThisPosition(float x, float y){
    x = x / (width / sqrt(chuncksNumber));
    y = y / (height / sqrt(chuncksNumber));
    int chunckIndex = int(sqrt(chuncksNumber))*int(x) + int(y);
    if(chunckIndex < chuncksNumber){
      if(chuncks[chunckIndex] == null){
        if(!newChunckEvent1.isOccurred()){
          newChunckEvent1.set(chunckIndex);
        }
        else if(!newChunckEvent2.isOccurred() && newChunckEvent1.getEventCode() != chunckIndex){
          newChunckEvent2.set(chunckIndex);
        }
        else if(!newChunckEvent3.isOccurred() && newChunckEvent1.getEventCode() != chunckIndex && newChunckEvent2.getEventCode() != chunckIndex){
          newChunckEvent3.set(chunckIndex);
        }
        else if(!newChunckEvent4.isOccurred() && newChunckEvent1.getEventCode() != chunckIndex && newChunckEvent2.getEventCode() != chunckIndex && newChunckEvent3.getEventCode() != chunckIndex){
          newChunckEvent4.set(chunckIndex);
        }
      }
    }
  }
  
  private void loadChunckCondition(Player player){
    float x1 = player.getX() + (width / sqrt(chuncksNumber)) * 0.5 - 1, y1 = player.getY() + (height / sqrt(chuncksNumber)) * 0.5 - 1;
    float x2 = player.getX() - (width / sqrt(chuncksNumber)) * 0.5, y2 = player.getY() + (height / sqrt(chuncksNumber)) * 0.5 - 1;
    float x3 = player.getX() + (width / sqrt(chuncksNumber)) * 0.5 - 1, y3 = player.getY() - (height / sqrt(chuncksNumber)) * 0.5;
    float x4 = player.getX() - (width / sqrt(chuncksNumber)) * 0.5, y4 = player.getY() - (height / sqrt(chuncksNumber)) * 0.5;
    
    loadChunckOfThisPosition(x1, y1);
    loadChunckOfThisPosition(x2, y2);
    loadChunckOfThisPosition(x3, y3);
    loadChunckOfThisPosition(x4, y4);
  }
  
  private void checkNewChunckEvent(Event newChunckEvent){
    if(newChunckEvent.isOccurred()){
      int chunckIndex = newChunckEvent.getEventCode();
      println("new chunck", chunckIndex);
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
      println("new chunck loaded");
    }
  }
  
  private void loadNewChunck(){
    checkNewChunckEvent(newChunckEvent1);
    checkNewChunckEvent(newChunckEvent2);
    checkNewChunckEvent(newChunckEvent3);
    checkNewChunckEvent(newChunckEvent4);
  }
  
  private void drawChunck(){
    if(drawChunckEvent4.isOccurred()){
      int chunckIndex = drawChunckEvent4.getEventCode();
      //chuncks[chunckIndex].drawChunck();
      drawChunckEvent4.decrease();
    }
    else if(drawChunckEvent3.isOccurred()){
      int chunckIndex = drawChunckEvent3.getEventCode();
      //chuncks[chunckIndex].drawChunck();
      drawChunckEvent3.decrease();
    }
    else if(drawChunckEvent2.isOccurred()){
      int chunckIndex = drawChunckEvent2.getEventCode();
      //chuncks[chunckIndex].drawChunck();
      drawChunckEvent2.decrease();
    }
    else if(drawChunckEvent1.isOccurred()){
      int chunckIndex = drawChunckEvent1.getEventCode();
      //chuncks[chunckIndex].drawChunck();
      drawChunckEvent1.decrease();
    }
  }
  
  private void drawPlayerArea(){
    float x1 = player.getX() + (width / sqrt(chuncksNumber)) * 0.5, y1 = player.getY() + (height / sqrt(chuncksNumber)) * 0.5;
    float x2 = player.getX() - (width / sqrt(chuncksNumber)) * 0.5, y2 = player.getY() + (height / sqrt(chuncksNumber)) * 0.5;
    float x3 = player.getX() + (width / sqrt(chuncksNumber)) * 0.5, y3 = player.getY() - (height / sqrt(chuncksNumber)) * 0.5;
    float x4 = player.getX() - (width / sqrt(chuncksNumber)) * 0.5, y4 = player.getY() - (height / sqrt(chuncksNumber)) * 0.5;
    int chunckIndex1 = int(sqrt(chuncksNumber))*int(x1) + int(y1);
    int chunckIndex2 = int(sqrt(chuncksNumber))*int(x2) + int(y2);
    int chunckIndex3 = int(sqrt(chuncksNumber))*int(x3) + int(y3);
    int chunckIndex4 = int(sqrt(chuncksNumber))*int(x4) + int(y4);
  }
  
  private void drawChunck2(Player player){
    float x1 = player.getX() - (width / sqrt(chuncksNumber)) * 0.5, y1 = player.getY() - (height / sqrt(chuncksNumber)) * 0.5;
    float x2 = player.getX() - (width / sqrt(chuncksNumber)) * 0.5, y2 = player.getY() + (height / sqrt(chuncksNumber)) * 0.5;
    float x3 = player.getX() + (width / sqrt(chuncksNumber)) * 0.5, y3 = player.getY() - (height / sqrt(chuncksNumber)) * 0.5;
    float x4 = player.getX() + (width / sqrt(chuncksNumber)) * 0.5, y4 = player.getY() + (height / sqrt(chuncksNumber)) * 0.5;
    
    float x5 = x4 - (x4 % (width / sqrt(chuncksNumber))), y5 = y4 - (y4 % (width / sqrt(chuncksNumber)));
    float[][] terrain = new float[width][height];
    for(int i=0; i<width; i++){
      for(int j=0; j<height; j++){
        if(x1 + i < x5 && y1 + j < y5){
          int chunckIndex1 = int(sqrt(chuncksNumber))*int(x1) + int(y1);
          terrain[i][j] = 0;
        }
        else if(x1 + i > x5 && y1 + j < y5){
          int chunckIndex2 = int(sqrt(chuncksNumber))*int(x2) + int(y2);
          terrain[i][j] = 0.25;
        }
        else if(x1 + i < x5 && y1 + j > y5){
          int chunckIndex3 = int(sqrt(chuncksNumber))*int(x3) + int(y3);
          terrain[i][j] = 0.5;
        }
        else if(x1 + i > x5 && y1 + j > y5){
          int chunckIndex4 = int(sqrt(chuncksNumber))*int(x4) + int(y4);
          terrain[i][j] = 0.75;
        }

      }
    }
    //for(int i=0; i<width; i++){
    //  for(int j=0; j<height; j++){
    //    //fill(terrain[i][j] * 256);
    //    //circle(i, j, 10);
    //  }
    //}
    
    fill(255, 100, 50);
    //circle(x1, y1, 5);
    //circle(x2, y2, 5);
    //circle(x3, y3, 5);
    //circle(x4, y4, 5);
    //fill(10, 100, 255);
    circle(x5, y5, 10);
}
  
  public void draw(Player player){
    loadChunckCondition(player);
    loadNewChunck();
    drawChunck();
    //drawChunck2(player);
    //drawPlayerArea();
    player.drawArea(chuncks[chuncksNumber / 2]);
    player.move();
    player.draw();
  }

  
}
