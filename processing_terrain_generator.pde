import java.awt.Polygon;
import java.util.Arrays;
import java.lang.Math;
import java.awt.event.KeyEvent;
//float seaLevel = 0.1;

boolean WPressed = false;
boolean DPressed = false;
boolean APressed = false;
boolean SPressed = false;

float theX, theY;
int distance = 40;

int[] colorsR;
int[] colorsG;
int[] colorsB;

int[][] blurredVorMap;
float[][][] boundaryNoise;
int pointsNumber = 1000;
float[][] points;
float[][] newPoints;
int[][] table;

float[][] uniformPrecipitationMap;
float[][] uniformTemperatureMap;
float[][] heightMap;
float[][] smoothHeightMap;
int[][] biomes;
float[][] newHMap;

Voronoi myVoronoi;
Delaunay myDelaunay;
ImageHandler handler;



VoronoiHandler vHandler;

void func(){
  BlurredVoronoiHandler bvHandler = new BlurredVoronoiHandler(points, pointsNumber);
  bvHandler.theVoronoiTable();
  bvHandler.blurVoronoiTable();
  table = bvHandler.getTable();
  blurredVorMap = bvHandler.getBlurredVorMap();

  println(5);
  println(6);
  println(7);
  PerlinNoise precipitationMap = new PerlinNoise(0.0, 0.0, 0.02, 10);
  precipitationMap.makeThisUniform(0.33);
  uniformPrecipitationMap = precipitationMap.getUniformSequence();
  println(8);
  PerlinNoise temperatureMap = new PerlinNoise(0.0, 0.0, 0.02, 40);
  temperatureMap.makeThisUniform(0.33);
  uniformTemperatureMap = temperatureMap.getUniformSequence();
  uniformPrecipitationMap = makeThisUniform(generatePrecipitationMap(), 0.33);
  uniformTemperatureMap = makeThisUniform(generateTemperatureMap(), 0.33);
  println(9);
  handler = new ImageHandler();
  println(10);
  biomes = getBiome();
  println(11);
  heightMap = getHeightMap();
  println(12);
  smoothHeightMap = getSmoothHeightMap();
  println(13);
  newHMap = applyFilters();

}

void setup() {
  background(255);
  size(800, 800, P3D);
  theX = width / 2;
  theY = height / 2;
  int mapSeed = 265948;
  randomSeed(mapSeed);
  points = new float[pointsNumber][2];
  newPoints = new float[pointsNumber][2];
  table = new int[width][height];
  boundaryNoise = new float[width][height][2];
  blurredVorMap = new int[width][height];
  println(1);
  vHandler = new VoronoiHandler(mapSeed, pointsNumber);
  points = vHandler.getPoints();
  myVoronoi = vHandler.getVoronoi();
  myDelaunay = vHandler.getDelaunay();

  vHandler.drawVertcies();
  vHandler.drawEdges();
  vHandler.drawPoints();

  thread("func");

  println(2);
  println(3);
  println(3.5);
  
  //applyFilters();
  //println(14);
}

void draw(){
  //move();
  //zoom();
  //noFill();
  //strokeWeight(3);
  //rect(theX - distance / 2, theY - distance / 2, distance, distance);
  //fill(0, 200, 155);
  //noStroke();
  //circle(theX, theY, 10);
}

void mouseClicked(){
  boolean a1 = false, a2 = false, a3 = false, a4 = false, a5 = false, a6 = false, a7 = false, a8 = false, a9 = false, a10 = false, a11 = false, a12 = false;
  for(int i = 0; i < width; i++){
    for(int j = 0; j < height; j++){
      if(biomes[table[i][j]][0] == 94){
        a1 = true;
      }
      else if(biomes[table[i][j]][0] == 71){
        a2 = true;
      }
      else if(biomes[table[i][j]][0] == 32){
        a3 = true;
      }
      else if(biomes[table[i][j]][0] == 58){
        a4 = true;
      }
      else if(biomes[table[i][j]][0] == 68){
        a5 = true;
      }
      else if(biomes[table[i][j]][0] == 44){
        a6 = true;
      }
      else if(biomes[table[i][j]][0] == 253){
        a7 = true;
      }
      else if(biomes[table[i][j]][0] == 173){
        a8 = true;
      }
      else if(biomes[table[i][j]][0] == 40){
        a9 = true;
      }
      else if(biomes[table[i][j]][0] == 237){
        a10 = true;
      }
      else if(biomes[table[i][j]][0] == 255){
        a11 = true;
      }
      else if(biomes[table[i][j]][0] == 163){
        a12 = true;
      }
    }
  }
  println(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12);
  println(biomes[table[mouseX][mouseY]][0]);
}

void zoom(){
  try{
    for(int i = 0; i < distance; i++){
      for(int j = 0; j < distance; j++){
        float h = newHMap[int(theX - distance / 2 + i)][int(theY - distance / 2 + j)];
        fill(h * 256);
        noStroke();
        rect(i * 20.0, j * 20.0, 20, 20);
        //println(i * 20 + (theX%1), j * 20 + (theY%1));
      }
    }
  } catch(NullPointerException e){
    
  }
}

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

void keyReleased(){
  if (keyCode == KeyEvent.VK_W){
    WPressed = false;
  }
  else if (keyCode == KeyEvent.VK_S){
    SPressed = false;
  }
  else if (keyCode == KeyEvent.VK_A){
    APressed = false;
  }
  else if (keyCode == KeyEvent.VK_D){
    DPressed = false;
  }
}
void keyPressed(){
  //drawVoronoiV2();
  if (keyCode == KeyEvent.VK_W){
    WPressed = true;
    //theY -= 1;
  }
  else if (keyCode == KeyEvent.VK_S){
    SPressed = true;
    //theY += 1;
  }
  else if (keyCode == KeyEvent.VK_A){
    APressed = true;
    //theX -= 1;
  }
  else if (keyCode == KeyEvent.VK_D){
    DPressed = true;
    //theX += 1;
  }
  else if (keyCode == KeyEvent.VK_Z){
    zoom();
  }
  else if (keyCode == KeyEvent.VK_Q){
    background(255);
    vHandler.drawVertcies();
    vHandler.drawEdges();
    vHandler.drawPoints();
  }
  else if (keyCode == KeyEvent.VK_R){
    vHandler.processVoronoi();
    println("processed");
  }
  else if (keyCode == KeyEvent.VK_T){
    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        int region = table[i][j];
        int r = biomes[region][0];
        int g = biomes[region][1];
        int b = biomes[region][2];
        fill(r,g,b);
        noStroke();
        circle(i, j, 1);
      }
    }
  }
  else if (keyCode == KeyEvent.VK_Y){
    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        int region = blurredVorMap[i][j];
        int r = biomes[region][0];
        int g = biomes[region][1];
        int b = biomes[region][2];
        fill(r,g,b);
        noStroke();
        circle(i, j, 1);
      }
    }
  }
  else{
    background(255);
    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        if(keyCode % 10 == 0){
          fill(heightMap[i][j]*256);
        }
        if(keyCode % 10 == 1){
          fill(heightMap[i][j]*256);
        }
        if(keyCode % 10 == 2){
          fill(heightMap[i][j]*256);
        }
        if(keyCode % 10 == 3){
          fill(smoothHeightMap[i][j]*256);
        }
        if(keyCode % 10 == 4){
          fill(smoothHeightMap[i][j]*256);
        }
        if(keyCode % 10 == 5){
          fill(smoothHeightMap[i][j]*256);
        }
        if(keyCode % 10 == 6){
          fill(newHMap[i][j]*256);
        }
        if(keyCode % 10 == 7){
          fill(newHMap[i][j]*256);
        }
        if(keyCode % 10 == 8){
          fill(newHMap[i][j]*256);
        }
        if(keyCode % 10 == 9){
          int region = table[i][j];
          int r = biomes[region][0];
          int g = biomes[region][1];
          int b = biomes[region][2];
          fill(r,g,b);
        }
        //if (heightMap[i][j] < 0.4)
        //  fill(0, 0, 255);
        noStroke();
        circle(i, j, 1);
      }
    }
  }
}

float[][] applyFilters(){
  float[][] filteredHeightMap = new float[width][height];
  for(int i = 0; i < width; i++){
    for(int j = 0; j < height; j++){
      if(biomes[table[i][j]][0] == 94){
        filteredHeightMap[i][j] = temperateForestFilterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 71){
        filteredHeightMap[i][j] = savannaFilterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 32){
        filteredHeightMap[i][j] = seasonalForestFilterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 58){
        filteredHeightMap[i][j] = tropicalWoodlandFilterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 68){
        filteredHeightMap[i][j] = desertFilterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 44){
        filteredHeightMap[i][j] = tundraFilterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 253){
        filteredHeightMap[i][j] = borealFilterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 173){
        filteredHeightMap[i][j] = temperateRainforestFilterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 40){
        filteredHeightMap[i][j] = rainforestFilterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 237){
        filteredHeightMap[i][j] = temporaryFilterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 255){
        filteredHeightMap[i][j] = temporary2FilterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 163){
        filteredHeightMap[i][j] = temporary3FilterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else{
        filteredHeightMap[i][j] = heightMap[i][j];
      }
    }
  }
  return filteredHeightMap;
}

float[][] makeThisUniform(float[][] sequence, float alpha){
  float[][] result = new float[width][height];
  float[] maxes = new float[sequence.length];
  float[] mines = new float[sequence.length];
  for(int i = 0; i < width; i++){
    maxes[i] = max(sequence[i]);
    mines[i] = min(sequence[i]);
  }
  for(int i = 0; i < width; i++){
    for(int j = 0; j < height; j++){
      result[i][j] = map(sequence[i][j], min(mines), max(maxes), 0, 1);
    }
  }
  return result;
}

int[][] getBiome(){
  int[] count = new int[pointsNumber];
  float[] temperatureSum = new float[pointsNumber];
  float[] precipitationSum = new float[pointsNumber];
  
  for(int i = 0; i < pointsNumber; i++){
    count[i] = 0;
    temperatureSum[i] = 0;
    precipitationSum[i] = 0;
  }
  
  for(int i = 0; i < width; i++){
    for(int j = 0; j < height; j++){
      int region = blurredVorMap[i][j];
      count[region]++;
      temperatureSum[region] += uniformTemperatureMap[i][j];
      precipitationSum[region] += uniformPrecipitationMap[i][j];
    }
  }
  int[][] biomes = new int[pointsNumber][3];
  for(int i = 0; i < pointsNumber; i++){
    temperatureSum[i] = temperatureSum[i] / count[i];
    precipitationSum[i] = precipitationSum[i] / count[i];
    biomes[i][0] = handler.getRedColor(map(precipitationSum[i], 0, 1, 0, 512), map(temperatureSum[i], 0, 1, 0, 512));
    biomes[i][1] = handler.getGreenColor(map(precipitationSum[i], 0, 1, 0, 512), map(temperatureSum[i], 0, 1, 0, 512));
    biomes[i][2] = handler.getBlueColor(map(precipitationSum[i], 0, 1, 0, 512), map(temperatureSum[i], 0, 1, 0, 512));
    //println(biomes[i][0], biomes[i][1], biomes[i][2]);
    //println(i, precipitationSum[i], temperatureSum[i], handler.getRedColor(precipitationSum[i], temperatureSum[i]), handler.getGreenColor(precipitationSum[i], temperatureSum[i]), handler.getBlueColor(precipitationSum[i], temperatureSum[i]));
  }
  return biomes;
}

float[][] getSmoothHeightMap(){
  noiseSeed(80);
  noiseDetail(1, 0.5);
  float[][] smoothHeightMap = new float[width][height];
  float xoff = 1000.0;
  float increment = 0.01;
  for(int i = 0; i < width; i++){
    xoff += increment;
    float yoff = 2000.0;
    for(int j = 0; j < height; j++){
      yoff += increment;
      smoothHeightMap[i][j] = noise(xoff, yoff);
    }
  }
  return smoothHeightMap;
}

float[][] getHeightMap(){
  noiseSeed(80);
  noiseDetail(8, 0.5);
  float[][] heightMap = new float[width][height];
  float xoff = 1000.0;
  float increment = 0.01;
  for(int i = 0; i < width; i++){
    xoff += increment;
    float yoff = 2000.0;
    for(int j = 0; j < height; j++){
      yoff += increment;
      heightMap[i][j] = noise(xoff, yoff);
    }
  }
  return heightMap;
}

float[][] generateTemperatureMap(){
  noiseSeed(40);
  float[][] temperatureMap = new float[width][height];
  float xoff = 0.0;
  float increment = 0.02;
  for(int i = 0; i < width; i++){
    xoff += increment;
    float yoff = 0.0;
    for(int j = 0; j < height; j++){
      yoff += increment;
      temperatureMap[i][j] = noise(xoff, yoff);
    }
  }
  return temperatureMap;
}

float[][] generatePrecipitationMap(){
  noiseSeed(10);
  float[][] precipitationMap = new float[width][height];
  float xoff = 0.0;
  float increment = 0.02;
  for(int i = 0; i < width; i++){
    xoff += increment;
    float yoff = 0.0;
    for(int j = 0; j < height; j++){
      yoff += increment;
      precipitationMap[i][j] = noise(xoff, yoff);
    }
  }
  return precipitationMap;
}

void drawVoronoi(){
  for(int i = 0; i < width; i++){
    for(int j = 0; j < height; j++){
      fill((table[i][j]*13)%256, (table[i][j]*19)%256, (table[i][j]*23)%256);
      noStroke();
      circle(i, j, 1);
    }
  }
}

//void blurVoronoiTableV2(){
//  noiseSeed(100);
//  int boundaryDisplacement = 8;
//  float increment = 0.015625;
//  float xoff = 0.0 + increment * (theX - (distance * 1));
//  float xoff2 = 1000.0 + increment * (theX - (distance * 1));
//  for(int x = int(theX - (distance * 1)); x < theX + (distance * 1); x++){
//    xoff += increment;
//    xoff2 += increment;
//    float yoff = 0.0 + increment * (theY - (distance * 1));
//    float yoff2 = 2000.0 + increment * (theY - (distance * 1));
//    for(int y = int(theY - (distance * 1)); y < theY + (distance * 1); y++){
//      yoff += increment;
//      yoff2 += increment;
//      float noise1 = noise(xoff, yoff);
//      float noise2 = noise(xoff2, yoff2);
//      if (x == 400 && y == 420){
//        println(theX, theY, xoff, yoff, xoff2, yoff2, noise1, noise2, noise(500, 200));
//      }
//      noise1 = map(noise1, 0, 1, -1, 1);
//      noise2 = map(noise2, 0, 1, -1, 1);
//      //boundaryNoise[x][y][0] = noise1;
//      //boundaryNoise[x][y][1] = noise2;
//      boundaryNoise[x][y][0] = noise1 * boundaryDisplacement + x;
//      boundaryNoise[x][y][1] = noise2 * boundaryDisplacement + y;
//      if (boundaryNoise[x][y][0] < 0)
//        boundaryNoise[x][y][0] = 0;
//      if (boundaryNoise[x][y][0] >= width)
//        boundaryNoise[x][y][0] = width - 1;
//      if (boundaryNoise[x][y][1] < 0)
//        boundaryNoise[x][y][1] = 0;
//      if (boundaryNoise[x][y][1] >= height)
//        boundaryNoise[x][y][1] = height - 1;
//    }
//  }
//  for(int x = 0; x < width; x++){
//    for (int y = 0; y < height; y++){      
//      int j = (int)boundaryNoise[x][y][0];
//      int i = (int)boundaryNoise[x][y][1];
//      blurredVorMap[y][x] = table[i][j];
//    }
//  }
//}

void blurVoronoiTable(){
  float xoff = 0.0;
  float xoff2 = 1000.0;
  float increment = 0.02;
  int boundaryDisplacement = 8;

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
      //boundaryNoise[x][y][0] = noise1;
      //boundaryNoise[x][y][1] = noise2;
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

void theVoronoiTable(){
  Point c1 = new Point(0, 0);
  Point c2 = new Point(0, height);
  Point c3 = new Point(width, height);
  Point c4 = new Point(width, 0);
  voronoiRecursive(c1, c2, c3, c4);
}
//void theVoronoiTableV2(){
//  Point c1 = new Point(theX - (distance * 2), theY - (distance * 2));
//  Point c2 = new Point(theX - (distance * 2), theY + (distance * 2));
//  Point c3 = new Point(theX + (distance * 2), theY + (distance * 2));
//  Point c4 = new Point(theX + (distance * 2), theY - (distance * 2));
//  voronoiRecursive(c1, c2, c3, c4);
//}
//void drawVoronoiV2(){
//  for(int i = int(theX - (distance * 1)); i < theX + (distance * 1); i++){
//    for(int j = int(theY - (distance * 1)); j < theY + (distance * 1); j++){
//      fill((blurredVorMap[i][j]*13)%256, (blurredVorMap[i][j]*19)%256, (blurredVorMap[i][j]*23)%256);
//      noStroke();
//      circle(i, j, 1);
//    }
//  }
//}
void voronoiRecursive(Point p1, Point p2, Point p3, Point p4){
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
    
    voronoiRecursive(p1, m1, m5, m4);
    voronoiRecursive(m1, p2, m2, m5);
    voronoiRecursive(m5, m2, p3, m3);
    voronoiRecursive(m4, m5, m3, p4);
  }
}

boolean isLittle(Point p1, Point p2, Point p3, Point p4){
  float minimumDistance = min(distance(p1, p2),  distance(p1, p3), distance(p1, p4));
  return (minimumDistance < 0.1);
}

float distance(Point p1, Point p2){
  return sqrt(pow(p1.getX() - p2.getX(), 2) + pow(p1.getY() - p2.getY(), 2));
}

int closest(Point p){
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

Point middle(Point p1, Point p2){
  float newX = (p1.getX() + p2.getX()) / 2;
  float newY = (p1.getY() + p2.getY()) / 2;
  Point result = new Point(newX, newY);
  return result;
}

void assignToRegion(Point p1, Point p2, Point p3, Point p4, int regionIndex){
  for(int i = (int)p1.getX(); i < p4.getX(); i++){
    for(int j = (int)p1.getY(); j < p2.getY(); j++){
      table[i][j] = regionIndex;
    }
  }
}


float desertFilterMap(float hMap, float smoothHMap){
  float b = 0.5;
  float outputMap = hMap*b + smoothHMap*(1-b);
  if(outputMap < 0)
    outputMap = 0;
  if(outputMap > 1)
    outputMap = 1;
  outputMap = desertBezier(outputMap);
  return outputMap;
}
float desertBezier(float h){
  float x1 = 0.75, y1 = 0.2, x2 = 0.95, y2 = 0.2, a = 0.2;
  float y = bezierPoint(0, height * y1, height * y2, height * a, h);
  return y / height;
}


float savannaFilterMap(float hMap, float smoothHMap){
  float b = 0.2;
  float outputMap = hMap*b + smoothHMap*(1-b);
  if(outputMap < 0)
    outputMap = 0;
  if(outputMap > 1)
    outputMap = 1;
  outputMap = savannaBezier(outputMap);
  return outputMap;
}
float savannaBezier(float h){
  float x1 = 0.5, y1 = 0.1, x2 = 0.95, y2 = 0.1, a = 0.1;
  float y = bezierPoint(0, height * y1, height * y2, height * a, h);
  return y / height;
}


float tropicalWoodlandFilterMap(float hMap, float smoothHMap){
  float b = 0.75;
  float outputMap = hMap*b + smoothHMap*(1-b);
  if(outputMap < 0)
    outputMap = 0;
  if(outputMap > 1)
    outputMap = 1;
  outputMap = tropicalWoodlandBezier(outputMap);
  return outputMap;
}
float tropicalWoodlandBezier(float h){
  float x1 = 0.33, y1 = 0.33, x2 = 0.95, y2 = 0.1, a = 0.1;
  float y = bezierPoint(0, height * y1, height * y2, height * a, h);
  return y / height;
}


float tundraFilterMap(float hMap, float smoothHMap){
  float b = 1;
  float outputMap = hMap*b + smoothHMap*(1-b);
  if(outputMap < 0)
    outputMap = 0;
  if(outputMap > 1)
    outputMap = 1;
  outputMap = tundraBezier(outputMap);
  return outputMap;
}
float tundraBezier(float h){
  float x1 = 0.5, y1 = 0.1, x2 = 0.25, y2 = 1, a = 1;
  float y = bezierPoint(0, height * y1, height * y2, height * a, h);
  return y / height;
}


float seasonalForestFilterMap(float hMap, float smoothHMap){
  float b = 0.2;
  float outputMap = hMap*b + smoothHMap*(1-b);
  if(outputMap < 0)
    outputMap = 0;
  if(outputMap > 1)
    outputMap = 1;
  outputMap = seasonalForestBezier(outputMap);
  return outputMap;
}
float seasonalForestBezier(float h){
  float x1 = 0.75, y1 = 0.5, x2 = 0.4, y2 = 0.4, a = 0.33;
  float y = bezierPoint(0, height * y1, height * y2, height * a, h);
  return y / height;
}


float rainforestFilterMap(float hMap, float smoothHMap){
  float b = 0.5;
  float outputMap = hMap*b + smoothHMap*(1-b);
  if(outputMap < 0)
    outputMap = 0;
  if(outputMap > 1)
    outputMap = 1;
  outputMap = rainforestBezier(outputMap);
  return outputMap;
}
float rainforestBezier(float h){
  float x1 = 0.5, y1 = 0.25, x2 = 0.66, y2 = 1, a = 1;
  float y = bezierPoint(0, height * y1, height * y2, height * a, h);
  return y / height;
}


float temperateForestFilterMap(float hMap, float smoothHMap){
  float b = 0.33;
  float outputMap = hMap*b + smoothHMap*(1-b);
  if(outputMap < 0)
    outputMap = 0;
  if(outputMap > 1)
    outputMap = 1;
  outputMap = temperateForestBezier(outputMap);
  return outputMap;
}
float temperateForestBezier(float h){
  float x1 = 0.75, y1 = 0.5, x2 = 0.4, y2 = 0.4, a = 0.33;
  float y = bezierPoint(0, height * y1, height * y2, height * a, h);
  return y / height;
}


float temperateRainforestFilterMap(float hMap, float smoothHMap){
  float b = 0.33;
  float outputMap = hMap*b + smoothHMap*(1-b);
  if(outputMap < 0)
    outputMap = 0;
  if(outputMap > 1)
    outputMap = 1;
  outputMap = temperateRainforestBezier(outputMap);
  return outputMap;
}
float temperateRainforestBezier(float h){
  float x1 = 0.75, y1 = 0.5, x2 = 0.4, y2 = 0.4, a = 0.33;
  float y = bezierPoint(0, height * y1, height * y2, height * a, h);
  return y / height;
}


float borealFilterMap(float hMap, float smoothHMap){
  float b = 0.1;
  float outputMap = hMap*b + smoothHMap*(1-b);
  if(outputMap < 0)
    outputMap = 0;
  if(outputMap > 1)
    outputMap = 1;
  outputMap = borealBezier(outputMap);
  return outputMap;
}
float borealBezier(float h){
  float x1 = 0.8, y1 = 0.1, x2 = 0.9, y2 = 0.05, a = 0.05;
  float y = bezierPoint(0, height * y1, height * y2, height * a, h);
  return y / height;
}

float temporaryFilterMap(float hMap, float smoothHMap){
  float b = 0.2;
  float outputMap = hMap*b + smoothHMap*(1-b);
  if(outputMap < 0)
    outputMap = 0;
  if(outputMap > 1)
    outputMap = 1;
  outputMap = temporaryBezier(outputMap);
  return outputMap;
}
float temporaryBezier(float h){
  float x1 = 0.73, y1 = 0.50, x2 = 0.98, y2 = 0.0, a = 1;
  float y = bezierPoint(0, height * y1, height * y2, height * a, h);
  return y / height;
}

float temporary2FilterMap(float hMap, float smoothHMap){
  float b = 0.2;
  float outputMap = hMap*b + smoothHMap*(1-b);
  if(outputMap < 0)
    outputMap = 0;
  if(outputMap > 1)
    outputMap = 1;
  outputMap = temporary2Bezier(outputMap);
  return outputMap;
}
float temporary2Bezier(float h){
  float x1 = 0.7, y1 = 0.55, x2 = 0.42, y2 = 0.4, a = 0.66;
  float y = bezierPoint(0, height * y1, height * y2, height * a, h);
  return y / height;
}

float temporary3FilterMap(float hMap, float smoothHMap){
  float b = 0.2;
  float outputMap = hMap*b + smoothHMap*(1-b);
  if(outputMap < 0)
    outputMap = 0;
  if(outputMap > 1)
    outputMap = 1;
  outputMap = temporary3Bezier(outputMap);
  return outputMap;
}
float temporary3Bezier(float h){
  float x1 = 0.9, y1 = 0.2, x2 = 0.9, y2 = 0.25, a = 0.8;
  float y = bezierPoint(0, height * y1, height * y2, height * a, h);
  return y / height;
}
