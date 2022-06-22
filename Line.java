public class Line {
  public float a;
  public float b;
  public float[] point1;
  public float[] point2;
  
  public Line(float coordX1, float coordY1, float coordX2, float coordY2){ // O(1)
    this.a = (coordY1 - coordY2) / (coordX1 - coordX2);
    this.b = coordY1 - this.a * coordX1;
    this.point1 = new float[2];
    this.point1[0] = coordX1;
    this.point1[1] = coordY1;
    this.point2 = new float[2];
    this.point2[0] = coordX2;
    this.point2[1] = coordY2;
  }

  public Line(float[] p1, float[] p2){ // O(1)
    this.a = (p1[1] - p2[1]) / (p1[0] - p2[0]);
    this.b = p1[1] - this.a * p1[0];
    this.point1 = p1;
    this.point2 = p2;
  }
  
  public float giveMeY(float x){ // O(1)
    return this.a * x + this.b;
  }
  public float giveMeX(float y){ // O(1)
    return (y - this.b) / this.a;
  }
  public float[] intersection(Line other, int width, int height){ // O(1)
    float[] result = new float[2];
    
    if(other.point1[1] == other.point2[1] && other.point2[1] == 0){
      float x = this.giveMeX(0);
      result[0] = x;
      result[1] = 0;
      
      if(((result[1] > this.point1[1] && result[1] < this.point2[1]) || (result[1] > this.point2[1] && result[1] < this.point1[1])) && ((result[0] > this.point1[0] && result[0] < this.point2[0]) || (result[0] > this.point2[0] && result[0] < this.point1[0]))){
        if(result[0] <= width && result[0] >= 0){
          return result;
        }
      }
    }
    if(other.point1[1] == other.point2[1] && other.point2[1] == height){
      float x = this.giveMeX(height);
      result[0] = x;
      result[1] = height;
      
      if(((result[1] > this.point1[1] && result[1] < this.point2[1]) || (result[1] > this.point2[1] && result[1] < this.point1[1])) && ((result[0] > this.point1[0] && result[0] < this.point2[0]) || (result[0] > this.point2[0] && result[0] < this.point1[0]))){
        if(result[0] <= width && result[0] >= 0){
          return result;
        }
      }
    }
    
    if(other.point1[0] == other.point2[0] && other.point2[0] == 0){
      float y = this.giveMeY(0);
      result[0] = 0;
      result[1] = y;
      if(((result[1] > this.point1[1] && result[1] < this.point2[1]) || (result[1] > this.point2[1] && result[1] < this.point1[1])) && ((result[0] > this.point1[0] && result[0] < this.point2[0]) || (result[0] > this.point2[0] && result[0] < this.point1[0]))){
        if(result[1] <= height && result[1] >= 0){
          return result;
        }
      }
    }
    if(other.point1[0] == other.point2[0] && other.point2[0] == width){
      float y = this.giveMeY(width);
      result[0] = width;
      result[1] = y;
      if(((result[1] > this.point1[1] && result[1] < this.point2[1]) || (result[1] > this.point2[1] && result[1] < this.point1[1])) && ((result[0] > this.point1[0] && result[0] < this.point2[0]) || (result[0] > this.point2[0] && result[0] < this.point1[0]))){
        if(result[1] <= height && result[1] >= 0){
          return result;
        }
      }
    }
    return null;
  }
}
