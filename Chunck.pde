class Chunck{
  int chunckNumberSq = 1;
  int seed;
  int pointsNumber;
  int chunckOffset;
  int chuncksPartNumber = 16;
  int whichPart = 0;
  float seaLevel = 0.45;
  
  VoronoiHandler vHandler;
  BlurredVoronoiHandler bvHandler;
  PerlinNoise precipitationMap;
  PerlinNoise temperatureMap;
  ImageHandler handler;
  BiomeHandler biomeHandler;
  PerlinNoise heightNoise;
  PerlinNoise smoothNoise;
  PerlinNoise oceanNoise;
  float[][] finalHeightMap;
  
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
  
  public Chunck(int seed, int pointsNumber, int chunckOffset){
    this.seed = seed;
    this.pointsNumber = pointsNumber;
    this.chunckOffset = chunckOffset;
    vHandler = new VoronoiHandler(seed+chunckOffset, pointsNumber);
    handler = new ImageHandler();

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
    notThreadFunction();
  }
  
  private void notThreadFunction(){
    bvHandler = new BlurredVoronoiHandler(vHandler.getPoints(), pointsNumber);
    bvHandler.theVoronoiTable();  //thread
    bvHandler.blurVoronoiTable();

    precipitationMap = new PerlinNoise(0.0 + (chunckOffset / 3)*width*0.015625, 0.0 + int(chunckOffset % 3)*height*0.015625, 0.015625, 10);
    precipitationMap.makeThisUniform(0.33);

    temperatureMap = new PerlinNoise(0.0 + (chunckOffset / 3)*width*0.015625, 0.0 + int(chunckOffset % 3)*height*0.015625, 0.015625, 40);
    temperatureMap.makeThisUniform(0.33);

    biomeHandler = new BiomeHandler(pointsNumber);
    biomeHandler.calculateBiome(handler, temperatureMap.getUniformSequence(), precipitationMap.getUniformSequence(), bvHandler.getBlurredVorMap());

    heightNoise = new PerlinNoise(1000.0 + (chunckOffset / 3)*width*0.015625, 2000.0 + int(chunckOffset % 3)*height*0.015625, 0.015625, 80, 8, 0.5);

    smoothNoise = new PerlinNoise(1000.0 + (chunckOffset / 3)*width*0.015625, 2000.0 + int(chunckOffset % 3)*height*0.015625, 0.015625, 80, 1, 0.5);
    oceanNoise = new PerlinNoise(1000.0 + (chunckOffset / 3)*width*0.015625, 2000.0 + int(chunckOffset % 3)*height*0.015625, 0.015625, 80);

    applyFilters();
  }
  
  private void applyFilters(){
    int[][] table = bvHandler.getTable();
    int[][] biomes = biomeHandler.getBiomes();
    float[][] heightMap = heightNoise.getSequence();
    float[][] smoothHeightMap = smoothNoise.getSequence();
    finalHeightMap = new float[width][height];

    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        if(biomes[table[i][j]][0] == 94){
          finalHeightMap[i][j] = temperateForestFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
        }
        else if(biomes[table[i][j]][0] == 71){
          finalHeightMap[i][j] = savannaFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
        }
        else if(biomes[table[i][j]][0] == 32){
          finalHeightMap[i][j] = seasonalForestFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
        }
        else if(biomes[table[i][j]][0] == 58){
          finalHeightMap[i][j] = tropicalWoodlandFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
        }
        else if(biomes[table[i][j]][0] == 68){
          finalHeightMap[i][j] = desertFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
        }
        else if(biomes[table[i][j]][0] == 44){
          finalHeightMap[i][j] = tundraFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
        }
        else if(biomes[table[i][j]][0] == 253){
          finalHeightMap[i][j] = borealFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
        }
        else if(biomes[table[i][j]][0] == 173){
          finalHeightMap[i][j] = temperateRainforestFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
        }
        else if(biomes[table[i][j]][0] == 40){
          finalHeightMap[i][j] = rainforestFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
        }
        else if(biomes[table[i][j]][0] == 237){
          finalHeightMap[i][j] = temporaryFilter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
        }
        else if(biomes[table[i][j]][0] == 255){
          finalHeightMap[i][j] = temporary2Filter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
        }
        else if(biomes[table[i][j]][0] == 163){
          finalHeightMap[i][j] = temporary3Filter.filterMap(heightMap[i][j], smoothHeightMap[i][j]);
        }
        else{
          finalHeightMap[i][j] = heightMap[i][j];
        }
      }
    }
  }
  
  public void drawWholeChunck(){
    for(int i = 0; i < chuncksPartNumber; i++){
      drawChunck(chuncksPartNumber, whichPart);
      whichPart = (whichPart + 1) % chuncksPartNumber;      
    }
  }  
  
  public void drawChunck(){
    drawChunck(chuncksPartNumber, whichPart);
    whichPart = (whichPart + 1) % chuncksPartNumber;
  }
  public void drawChunck(int partNumber, int whichPart){
    float[][] oceanMap;
    try{
      oceanMap = oceanNoise.getSequence();
    } catch (NullPointerException e){
      oceanMap = new float[width][height];    
    }
    float xoffset = int(chunckOffset / chunckNumberSq) * (width / chunckNumberSq);
    float yoffset = (chunckOffset % chunckNumberSq) * (height / chunckNumberSq);
    
    int eachSidePartNumber = int(sqrt(partNumber));
    int eachPartLength = width / eachSidePartNumber;
    
    
    for(int i = (whichPart%eachSidePartNumber)*eachPartLength; i < ((whichPart%eachSidePartNumber)+1)*eachPartLength; i++){
      for(int j = (whichPart/eachSidePartNumber)*eachPartLength; j < ((whichPart/eachSidePartNumber)+1)*eachPartLength; j++){
        if(oceanMap[i][j] < seaLevel)
          fill(0, 0, 255);
        else if(isRiver(i, j)){
          fill(255, 0, 0);
        }
        else{
          float c = finalHeightMap[i][j];        
          fill(c*256);
        }
        noStroke();
        circle((i/chunckNumberSq)+xoffset, (j/chunckNumberSq)+yoffset, 1);
      }
    }
  }
  
  private boolean isRiver(int x, int y){
    int riverSize = 3;
    int[][] blurredVorMap = bvHandler.getBlurredVorMap();
    int[][] biomes = biomeHandler.getBiomes();
    int region = blurredVorMap[x][y];
    if(x-riverSize>=0){
      int regionLeft = blurredVorMap[x-riverSize][y];
      if(biomes[region][0] != biomes[regionLeft][0])
        return true;
    }
    if(x+riverSize<blurredVorMap.length){
    int regionRight = blurredVorMap[x+riverSize][y];
      if(biomes[region][0] != biomes[regionRight][0])
        return true;
    }
    if(y+riverSize<blurredVorMap.length){
    int regionUp = blurredVorMap[x][y+riverSize];
      if(biomes[region][0] != biomes[regionUp][0])
        return true;
    }
    if(y-riverSize>=0){
    int regionDown = blurredVorMap[x][y-riverSize];
      if(biomes[region][0] != biomes[regionDown][0])
        return true;
    }
    return false;
  }
  
  public color[][] getTerrainColor(){
    color[][] terrain = new color[width][height];
    float[][] oceanMap;
    try{
      oceanMap = oceanNoise.getSequence();
    } catch (NullPointerException e){
      oceanMap = new float[width][height];    
    }
    int[][] blurredVorMap = bvHandler.getBlurredVorMap();
    int[][] biomes = biomeHandler.getBiomes();
    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        if(oceanMap[i][j] < seaLevel)
          terrain[i][j] = color(0, 0, 255);
        else if(isRiver(i, j)){
          terrain[i][j] = color(10, 10, 220);
        }
        else{
          int region = blurredVorMap[i][j];
          int r = biomes[region][0];
          int g = biomes[region][1];
          int b = biomes[region][2];
          terrain[i][j] = color(r,g,b);
        }
      }
    }
    return terrain;
  }
    
  public float[][] getTerrain(){
    float[][] terrain = new float[width][height];
    float[][] oceanMap;
    try{
      oceanMap = oceanNoise.getSequence();
    } catch (NullPointerException e){
      oceanMap = new float[width][height];    
    }
    
    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        if(oceanMap[i][j] < seaLevel)
          terrain[i][j] = 0;
        else if(isRiver(i, j)){
          terrain[i][j] = 0;
        }
        else{
          float c = finalHeightMap[i][j];        
          terrain[i][j] = c;
        }
      }
    }
    return terrain;
  }
  
  
}
