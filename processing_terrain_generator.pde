import java.awt.event.KeyEvent;

boolean WPressed = false;
boolean DPressed = false;
boolean APressed = false;
boolean SPressed = false;

float theX, theY;
int pointsNumber = 100;

int mapSeed;
//int chunckNumber = 49;

boolean flag = true, wannaShowFlag = false;
Chunck[] chuncks;
boolean[] wannaShow;
//void func(){
//  chuncks[23] = new Chunck(mapSeed, pointsNumber, 23);
//  chuncks[17] = new Chunck(mapSeed, pointsNumber, 17);
//  chuncks[31] = new Chunck(mapSeed, pointsNumber, 31);
//  chuncks[25] = new Chunck(mapSeed, pointsNumber, 25);
//  flag = true;
//}




Terrain terrain;
Player player;
void setup() {
  background(255);
  size(800, 800);
  theX = width / 2;
  theY = height / 2;
  mapSeed = 265948;  // ----
  //chuncks = new Chunck[chunckNumber];
  //wannaShow = new boolean[chunckNumber];
  
  terrain = new Terrain(mapSeed);
  player = new Player();
  
  //chuncks[chunckNumber/2] = new Chunck(mapSeed, pointsNumber, chunckNumber/2);
  ////chunckOffset++;
  //chuncks[chunckNumber/2].drawChunck();
  //thread("func");
  //for(int i = 0; i < chunckNumber; i++){
  //  println(wannaShow[i]);
  //}
}

void draw(){
  terrain.mainFunction(player);

  //move();
  //showPlayer();
  //if (loadChunckCondition() && flag)
  //{
  //  flag = false;
  //  thread("loadNewCunck");

  //  //loadNewCunck();
  //}
  //if (wannaShowFlag){
  //  for(int i = 0; i < chunckNumber; i++){
  //    if(wannaShow[i])
  //    {
  //      chuncks[i].drawChunck();
  //      wannaShow[i] = false;
  //    }
  //  }
  //}
  //zoom();
  //noFill();
  //strokeWeight(3);
  //rect(theX - distance / 2, theY - distance / 2, distance, distance);
  //fill(0, 200, 155);
  //noStroke();
  //circle(theX, theY, 10);
}

//boolean loadChunckCondition(){
//  int temp1 = int(theX / (width / sqrt(chunckNumber)));
//  int temp2 = int(theY / (height / sqrt(chunckNumber)));
//  int chunckIndex = int(sqrt(chunckNumber))*temp1 + temp2;
//  return (chuncks[chunckIndex] == null);
//}

//void loadNewCunck(){
//  int temp1 = int(theX / (width / sqrt(chunckNumber)));
//  int temp2 = int(theY / (height / sqrt(chunckNumber)));
//  int chunckIndex = int(sqrt(chunckNumber))*temp1 + temp2;
//  chuncks[chunckIndex] = new Chunck(mapSeed, pointsNumber, chunckIndex);
//  wannaShow[chunckIndex] = true;
//  wannaShowFlag = true;
//  flag = true;
//}

//void zoom(){
//  try{
//    for(int i = 0; i < distance; i++){
//      for(int j = 0; j < distance; j++){
//        float h = newHMap[int(theX - distance / 2 + i)][int(theY - distance / 2 + j)];
//        fill(h * 256);
//        noStroke();
//        rect(i * 20.0, j * 20.0, 20, 20);
//        //println(i * 20 + (theX%1), j * 20 + (theY%1));
//      }
//    }
//  } catch(NullPointerException e){
    
//  }
//}

void move(){
  if (WPressed){
    theY -= 1;
  }
  if (SPressed){
    theY += 1;
  }
  if (APressed){
    theX -= 1;
  }
  if (DPressed){
    theX += 1;
  }
}

void showPlayer(){
  noStroke();
  fill(255, 0, 0);
  circle(theX, theY, 3);
}

void keyReleased(){
  player.keyReleased();
}

void keyPressed(){
  player.keyPressed();
}
