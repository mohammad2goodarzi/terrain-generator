import processing.core.PApplet;
import processing.core.PGraphics;


class Point{
  float x;
  float y;
  
  public Point(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  public void draw(PApplet p){
    draw(p.g);
  }
  
  public void draw(PGraphics g){
    g.circle(this.x, this.y, 4);
  }
  
  public float getX(){
    return x;
  }
  public float getY(){
    return y;
  }
}
