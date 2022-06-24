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
    noStroke();
    fill(255, 0, 0);
    circle(x, y, 3);
  }
  
  public float getX(){
    return x;
  }
  public float getY(){
    return y;
  }
}
