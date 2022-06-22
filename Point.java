import processing.core.PApplet;
import processing.core.PGraphics;


class Point{
  float x;
  float y;
  
  public Point(float x, float y){ // O(1)
    this.x = x;
    this.y = y;
  }
  
  public void draw(PApplet p){ // O(1)
    draw(p.g);
  }
  
  public void draw(PGraphics g){ // O(1)
    g.circle(this.x, this.y, 4);
  }
  
  public float getX(){
    return x;
  }
  public float getY(){
    return y;
  }
}
