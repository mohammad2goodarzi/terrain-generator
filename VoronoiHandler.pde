class VoronoiHandler{
  float[][] points;
  int seed;
  int pointsNumber;
  Voronoi myVoronoi;
  Delaunay myDelaunay;

  public VoronoiHandler(int seed, int pointsNumber){ // O((pointsNumber)log(pointsNumber))
    this.seed = seed;
    this.pointsNumber = pointsNumber;
    
    generateRandomPoints();
    
    processVoronoi();
  }
  
  private void generateRandomPoints() { // O(pointsNumber)
    randomSeed(seed);
    points = new float[pointsNumber][pointsNumber];
    for(int i = 0; i < pointsNumber; i++){
      points[i][0] = random(height);
      points[i][1] = random(width);
    }
  }
  
  public void processVoronoi(){ // O(calculateVoronoi()) ~ O((pointsNumber)log(pointsNumber))
    for (int i = 0; i < 15; i++){
      points = calculateVoronoi();
    }
  }
  
  private float[][] calculateVoronoi(){ // O(Voronoi + calculateNewPoints()) ~ O((pointsNumber)log(pointsNumber)+pointsNumber + pointsNumber) ~ O((pointsNumber)log(pointsNumber))
    myVoronoi = new Voronoi(points); // O(nlogn+n) ~ O((pointsNumber)log(pointsNumber)+pointsNumber)
    myDelaunay = new Delaunay(points); // O(nlogn+n) ~ O((pointsNumber)log(pointsNumber)+pointsNumber)
  
    return calculateNewPoints();
  }
  
  private float[][] calculateNewPoints(){ // O(calculateCentroid() * pointsNumber) ~ O(pointsNumber)
    float[][] newPoints = new float[pointsNumber][pointsNumber];

    MPolygon[] myRegions = myVoronoi.getRegions();
    for(int i=0; i<myRegions.length; i++)
    {
      float[][] regionCoordinates = myRegions[i].getCoords();
      float[] centroid = calculateCentroid(regionCoordinates);
      newPoints[i][0] = centroid[0];
      newPoints[i][1] = centroid[1];
    }
    return newPoints;
  }
  
  private float[] calculateCentroid(float[][] regionCoordinates){ // O(regionCoordinates.length) ~ O(1)
    float[] result = new float[2];
    result[0] = 0;
    result[1] = 0;
    
    boolean edge1 = false;
    boolean edge2 = false;
    boolean edge3 = false;
    boolean edge4 = false;
    int cornerNumber = 0;
  
    for(int i = 0; i < regionCoordinates.length; i++){
      Line theLine = new Line(regionCoordinates[i], regionCoordinates[(i+1) % regionCoordinates.length]);
      Line border1 = new Line(0, 0, width, 0);
      Line border2 = new Line(0, 0, 0, height);
      Line border3 = new Line(width, 0, width, height);
      Line border4 = new Line(0, height, width, height);
      
      float[] inter1 = theLine.intersection(border1, width, height);
      float[] inter2 = theLine.intersection(border2, width, height);
      float[] inter3 = theLine.intersection(border3, width, height);
      float[] inter4 = theLine.intersection(border4, width, height);
      if (inter1 != null) {
        edge1 = true;
        result[0] += inter1[0];
        result[1] += inter1[1];
        cornerNumber += 1;
      }
      else if (inter2 != null) {
        edge2 = true;
        result[0] += inter2[0];
        result[1] += inter2[1];
        cornerNumber += 1;
      }
      else if (inter3 != null) {
        edge3 = true;
        result[0] += inter3[0];
        result[1] += inter3[1];
        cornerNumber += 1;
      }
      else if (inter4 != null) {
        edge4 = true;
        result[0] += inter4[0];
        result[1] += inter4[1];
        cornerNumber += 1;
      }
      else{
      }
      if(regionCoordinates[i][0] <= width && regionCoordinates[i][0] >= 0 && regionCoordinates[i][1] <= height && regionCoordinates[i][1] >= 0){
        result[0] += regionCoordinates[i][0];
        result[1] += regionCoordinates[i][1];
        cornerNumber += 1;
      }
    }
    if (edge1 && edge2) {
      result[0] += 0;
      result[1] += 0;
      cornerNumber += 1;
    }
    if (edge1 && edge3) {
      result[0] += width;
      result[1] += 0;
      cornerNumber += 1;
    }
    if (edge2 && edge4) {
      result[0] += 0;
      result[1] += height;
      cornerNumber += 1;
    }
    if (edge3 && edge4) {
      result[0] += width;
      result[1] += height;
      cornerNumber += 1;
    }
    result[0] /= cornerNumber;
    result[1] /= cornerNumber;
    return result;
  }
  
  public void drawVertcies(){
    MPolygon[] regions = myVoronoi.getRegions();
    for(int i=0; i<regions.length; i++)
    {
      fill(255, 255, 255);
      float[][] regionCoordinates = regions[i].getCoords();
      for(int j = 0; j < regionCoordinates.length; j++)
      {
        fill(255, 0, 0);
        circle(regionCoordinates[j][0], regionCoordinates[j][1], 4);
      }
    }
  }
  public void drawEdges(){
    int cnt = 0;
    float[][] myEdges = myVoronoi.getEdges();
    for(int i=0; i<myEdges.length; i++)
    {
      float startX = myEdges[i][0];
      float startY = myEdges[i][1];
      float endX = myEdges[i][2];
      float endY = myEdges[i][3];
      if(!((startX < 0 || startX > width || startY < 0 || startY > height) && (endX < 0 || endX > width || endY < 0 || endY > height))){
        stroke(0, 0, 0);
        line(startX, startY, endX, endY);
      }
    }
  }
  
  public void drawPoints() {
    for(int i = 0; i < points.length; i++){
      fill(0, 0, 255);
      circle(points[i][0], points[i][1], 6);
    }  
  }
  
  public float[][] getPoints(){
    return points;
  }
    
  public Voronoi getVoronoi(){
    return myVoronoi;
  }
    
  public Delaunay getDelaunay(){
    return myDelaunay;
  }
}
