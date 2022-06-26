float theX, theY;
int mapSeed;
Terrain terrain;
Player player;


void setup() {
  background(255);
  size(800, 800, P3D);
  theX = width / 2;
  theY = height / 2;
  mapSeed = 265948;
  terrain = new Terrain(mapSeed);
  player = new Player();
}

void draw(){
  terrain.draw(player);
}

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

void keyReleased(){
  player.keyReleased();
}

void keyPressed(){
  player.keyPressed();
}
