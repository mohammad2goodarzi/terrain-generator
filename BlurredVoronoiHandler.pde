class BlurredVoronoiHandler{
  int pointsNumber;
  float[][] points;
  int[][] table;
  int[][] blurredVorMap;

  public BlurredVoronoiHandler(float[][] points, int pointsNumber){ // O(1)
    this.pointsNumber = pointsNumber;
    this.points = points;
    table = new int[width][height];
  }

  public void theVoronoiTable(){ // O(width*height)
    Point c1 = new Point(0, 0);
    Point c2 = new Point(0, height);
    Point c3 = new Point(width, height);
    Point c4 = new Point(width, 0);
    voronoiRecursive(c1, c2, c3, c4);
  }

  private void voronoiRecursive(Point p1, Point p2, Point p3, Point p4){ // O(x*y) -> x = p3.getX() - p1.getX() , y = p3.getY() - p1.getY()
    if (isLittle(p1, p2, p3, p4))
    {
      return;
    }
    int s1 = closest(p1);
    int s2 = closest(p2);
    int s3 = closest(p3);
    int s4 = closest(p4);
  
    if (s1 == s2 && s1 == s3 && s1 == s4){
      assignToRegion(p1, p2, p3, p4, s1);
    }
    else{
      Point m1 = middle(p1, p2);
      Point m2 = middle(p2, p3);
      Point m3 = middle(p3, p4);
      Point m4 = middle(p4, p1);
      Point m5 = middle(p1, p3);
      
      voronoiRecursive(p1, m1, m5, m4); // O(x/2*y/2)
      voronoiRecursive(m1, p2, m2, m5); // O(x/2*y/2)
      voronoiRecursive(m5, m2, p3, m3); // O(x/2*y/2)
      voronoiRecursive(m4, m5, m3, p4); // O(x/2*y/2)
    }
  }
  private boolean isLittle(Point p1, Point p2, Point p3, Point p4){ // O(1)
    float minimumDistance = min(distance(p1, p2),  distance(p1, p3), distance(p1, p4));
    return (minimumDistance < 0.1);
  }
  
  private float distance(Point p1, Point p2){ // O(1)
    return sqrt(sq(p1.getX() - p2.getX()) + sq(p1.getY() - p2.getY()));
  }
  
  private int closest(Point p){ // O(pointsNumber)
    float minDistance = width * height;
    int closestPointIndex = -1;
    for(int i = 0; i < pointsNumber; i++){
      Point tmp = new Point(points[i][0], points[i][1]);
      float d = distance(tmp, p);
      if(i == 0){
        minDistance = d;
        closestPointIndex = i;
      }
      else{
        if(d < minDistance){
          minDistance = d;
          closestPointIndex = i;
        }
      }
    }
    return closestPointIndex;
  }
  
  private Point middle(Point p1, Point p2){ // O(1)
    float newX = (p1.getX() + p2.getX()) / 2;
    float newY = (p1.getY() + p2.getY()) / 2;
    Point result = new Point(newX, newY);
    return result;
  }
  private void assignToRegion(Point p1, Point p2, Point p3, Point p4, int regionIndex){ // O(x*y) -> x = p3.getX() - p1.getX() , y = p3.getY() - p1.getY()
    for(int i = (int)p1.getX(); i < p3.getX(); i++){
      for(int j = (int)p1.getY(); j < p3.getY(); j++){
        table[i][j] = regionIndex;
      }
    }
  }

  public void blurVoronoiTable(){ // O(width*height)
    noiseSeed(250);
    float xoff = 0.0;
    float xoff2 = 1000.0;
    float increment = 0.02;
    int boundaryDisplacement = 8;
    float[][][] boundaryNoise = new float[width][height][2];
    blurredVorMap = new int[width][height];
    
    for (int x = 0; x < width; x++) {
      xoff += increment;
      xoff2 += increment;
      float yoff = 0.0;
      float yoff2 = 2000.0;
      for (int y = 0; y < height; y++) {
        yoff += increment;
        yoff2 += increment;
        float noise1 = noise(xoff, yoff);
        float noise2 = noise(xoff2, yoff2);
        noise1 = map(noise1, 0, 1, -1, 1);
        noise2 = map(noise2, 0, 1, -1, 1);
        boundaryNoise[x][y][0] = noise1 * boundaryDisplacement + x;
        boundaryNoise[x][y][1] = noise2 * boundaryDisplacement + y;
        if (boundaryNoise[x][y][0] < 0)
          boundaryNoise[x][y][0] = 0;
        if (boundaryNoise[x][y][0] >= width)
          boundaryNoise[x][y][0] = width - 1;
        if (boundaryNoise[x][y][1] < 0)
          boundaryNoise[x][y][1] = 0;
        if (boundaryNoise[x][y][1] >= height)
          boundaryNoise[x][y][1] = height - 1;
      }
    }
    for(int x = 0; x < width; x++){
      for (int y = 0; y < height; y++){      
        int j = (int)boundaryNoise[x][y][0];
        int i = (int)boundaryNoise[x][y][1];
        blurredVorMap[y][x] = table[i][j];
      }
    }
  }

  public int[][] getTable(){
    return table;
  }
  public int[][] getBlurredVorMap(){
    return blurredVorMap;
  }
}
