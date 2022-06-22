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

BiomeFilter desertFilter;
BiomeFilter savannaFilter;
BiomeFilter tropicalWoodlandFilter;
BiomeFilter tundraFilter;
BiomeFilter seasonalForestFilter;
BiomeFilter rainforestFilter;
BiomeFilter temperateForestFilter;
BiomeFilter temperateRainforestFilter;
BiomeFilter borealFilter;
BiomeFilter temporaryFilter;
BiomeFilter temporary2Filter;
BiomeFilter temporary3Filter;

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

  println(9);
  handler = new ImageHandler();
  println(10);
  BiomeHandler bHandler = new BiomeHandler(pointsNumber);
  bHandler.calculateBiome(handler, uniformTemperatureMap, uniformPrecipitationMap, blurredVorMap);
  biomes = bHandler.getBiomes();
  println(11);
  PerlinNoise hNoise = new PerlinNoise(1000.0, 2000.0, 0.01, 80, 8, 0.5);
  heightMap = hNoise.getSequence();
  println(12);
  PerlinNoise smoothNoise = new PerlinNoise(1000.0, 2000.0, 0.01, 80, 1, 0.5);
  smoothHeightMap = smoothNoise.getSequence();
  println(13);
  newHMap = applyFilters();

}

void setup() {
  background(255);
  size(800, 800);
  theX = width / 2;
  theY = height / 2;
  int mapSeed = 265948;
  randomSeed(mapSeed);
  points = new float[pointsNumber][2];
  newPoints = new float[pointsNumber][2];
  table = new int[width][height];
  boundaryNoise = new float[width][height][2];
  blurredVorMap = new int[width][height];
  vHandler = new VoronoiHandler(mapSeed, pointsNumber);
  points = vHandler.getPoints();
  myVoronoi = vHandler.getVoronoi();
  myDelaunay = vHandler.getDelaunay();

  vHandler.drawVertcies();
  vHandler.drawEdges();
  vHandler.drawPoints();

  thread("func");

  desertFilter = new BiomeFilter(0.2, 0.2, 0.2, 0.5);
  savannaFilter = new BiomeFilter(0.1, 0.1, 0.1, 0.2);
  tropicalWoodlandFilter = new BiomeFilter(0.33, 0.1, 0.1, 0.75);
  tundraFilter = new BiomeFilter(0.1, 1, 1, 1);
  seasonalForestFilter = new BiomeFilter(0.5, 0.4, 0.33, 0.2);
  rainforestFilter = new BiomeFilter(0.25, 1, 1, 0.5);
  temperateForestFilter = new BiomeFilter(0.5, 0.4, 0.33, 0.33);
  temperateRainforestFilter = new BiomeFilter(0.5, 0.4, 0.33, 0.33);
  borealFilter = new BiomeFilter(0.1, 0.05, 0.05, 0.1);
  temporaryFilter = new BiomeFilter(0.50, 0.0, 1, 0.2);
  temporary2Filter = new BiomeFilter(0.55, 0.4, 0.66, 0.2);
  temporary3Filter = new BiomeFilter(0.2, 0.25, 0.8, 0.2);

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
  if (keyCode == KeyEvent.VK_W){
    WPressed = true;
  }
  else if (keyCode == KeyEvent.VK_S){
    SPressed = true;
  }
  else if (keyCode == KeyEvent.VK_A){
    APressed = true;
  }
  else if (keyCode == KeyEvent.VK_D){
    DPressed = true;
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
  else if (keyCode == KeyEvent.VK_U){
    background(255);
    for(int i = width/3; i < 2*width/3; i++){
      for(int j = height/3; j < 2*height/3; j++){
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
  else if (keyCode == KeyEvent.VK_I){
    background(255);
    float offset = width / 3;
    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        int region = blurredVorMap[i][j];
        int r = biomes[region][0];
        int g = biomes[region][1];
        int b = biomes[region][2];
        fill(r,g,b);
        noStroke();
        circle((i/3)+offset, (j/3)+offset, 1);
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
        filteredHeightMap[i][j] = temperateForestFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 71){
        filteredHeightMap[i][j] = savannaFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 32){
        filteredHeightMap[i][j] = seasonalForestFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 58){
        filteredHeightMap[i][j] = tropicalWoodlandFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 68){
        filteredHeightMap[i][j] = desertFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 44){
        filteredHeightMap[i][j] = tundraFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 253){
        filteredHeightMap[i][j] = borealFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 173){
        filteredHeightMap[i][j] = temperateRainforestFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 40){
        filteredHeightMap[i][j] = rainforestFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 237){
        filteredHeightMap[i][j] = temporaryFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 255){
        filteredHeightMap[i][j] = temporary2Filter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else if(biomes[table[i][j]][0] == 163){
        filteredHeightMap[i][j] = temporary3Filter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
      }
      else{
        filteredHeightMap[i][j] = heightMap[i][j];
      }
    }
  }
  return filteredHeightMap;
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
