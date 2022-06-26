import java.awt.event.KeyEvent;

class Player{
  float stepSize = 1;
  float x;
  float y;
  boolean up = false;
  boolean down = false;
  boolean left = false;
  boolean right = false;

  public Player(){
    this.x = width / 2;
    this.y = height / 2;
  }
  
  public void keyReleased(){
    if (keyCode == KeyEvent.VK_W){
      up = false;
    }
    else if (keyCode == KeyEvent.VK_S){
      down = false;
    }
    else if (keyCode == KeyEvent.VK_A){
      left = false;
    }
    else if (keyCode == KeyEvent.VK_D){
      right = false;
    }
  }
  public void keyPressed(){
    if (keyCode == KeyEvent.VK_W){
      up = true;
    }
    else if (keyCode == KeyEvent.VK_S){
      down = true;
    }
    else if (keyCode == KeyEvent.VK_A){
      left = true;
    }
    else if (keyCode == KeyEvent.VK_D){
      right = true;
    }
  }
  public void move(){
    if (up){
      y -= stepSize;
    }
    if (down){
      y += stepSize;
    }
    if (left){
      x -= stepSize;
    }
    if (right){
      x += stepSize;
    } 
  }
  public void draw(){
    //noStroke();
    //fill(255, 0, 0);
    //circle(x, y, 3);
  }
  
  public void drawArea(Chunck c1){
    drawArea(c1.getTerrain(), c1.getTerrainColor());
  }
  
  public void drawArea(float[][] terrain, color[][] terrainColor){
    background(100);
    noStroke();
    translate(width/2, height/2);
    rotateX(PI/3);
    translate(-width/2, -height/2);
    float jj = 320;
    for(int j = int(y) - height/30; j < int(y) + height/30 - 1; j++){
      float ii = 150;
      beginShape(TRIANGLE_STRIP);
      for(int i = int(x) - width/30; i < int(x) + width/30; i++){
        fill(terrainColor[i][j]);
        vertex(ii, jj, map(terrain[i][j], 0, 1, 0, 100));
        vertex(ii, (jj+10), map(terrain[i][j+1], 0, 1, 0, 100));
        ii+=10;
      }
      endShape();
      jj+=10;
    }
  }
  
  public float getX(){
    return x;
  }
  public float getY(){
    return y;
  }
}
