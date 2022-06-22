class BiomeFilter{
  float y1;
  float y2;
  float a;
  float b;
  public BiomeFilter(float y1, float y2, float a, float b){ // O(1)
    this.y1 = y1;
    this.y2 = y2;
    this.a = a;
    this.b = b;
  }
  
  float filterMap(float hMap, float smoothHMap){ // O(limitBetween + bezierFilter) ~ O(1)
    float outputMap = hMap*b + smoothHMap*(1-b);
    outputMap = limitBetween(outputMap, 0, 1);
    outputMap = bezierFilter(outputMap);
    return outputMap;
  }
  
  float bezierFilter(float h){ // O(1)
    float y = bezierPoint(0, height * y1, height * y2, height * a, h);
    return y / height;
  }
  
  private float limitBetween(float number, float lowerBound, float upperBound){ // O(1)
    if(number < lowerBound)
      number = lowerBound;
    if(number > upperBound)
      number = upperBound;
    return number;
  }
}
