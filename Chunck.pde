class Chunck{
  int chunckNumberSq = 7;
  int seed;
  int pointsNumber;
  int chunckOffset;
  VoronoiHandler vHandler;
  BlurredVoronoiHandler bvHandler;
  PerlinNoise precipitationMap;
  PerlinNoise temperatureMap;
  ImageHandler handler;
  BiomeHandler biomeHandler;
  PerlinNoise heightNoise;
  PerlinNoise smoothNoise;
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
    bvHandler.theVoronoiTable();
    bvHandler.blurVoronoiTable();

    precipitationMap = new PerlinNoise(0.0 + (chunckOffset / 3)*width*0.015625, 0.0 + int(chunckOffset % 3)*height*0.015625, 0.015625, 10);
    precipitationMap.makeThisUniform(0.33);

    temperatureMap = new PerlinNoise(0.0 + (chunckOffset / 3)*width*0.015625, 0.0 + int(chunckOffset % 3)*height*0.015625, 0.015625, 40);
    temperatureMap.makeThisUniform(0.33);

    handler = new ImageHandler();
  
    biomeHandler = new BiomeHandler(pointsNumber);
    biomeHandler.calculateBiome(handler, temperatureMap.getUniformSequence(), precipitationMap.getUniformSequence(), bvHandler.getBlurredVorMap());

    heightNoise = new PerlinNoise(1000.0 + (chunckOffset / 3)*width*0.015625, 2000.0 + int(chunckOffset % 3)*height*0.015625, 0.015625, 80, 8, 0.5);

    smoothNoise = new PerlinNoise(1000.0 + (chunckOffset / 3)*width*0.015625, 2000.0 + int(chunckOffset % 3)*height*0.015625, 0.015625, 80, 1, 0.5);

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
  public void drawChunck(){
    int[][] blurredVorMap = bvHandler.getBlurredVorMap();
    int[][] biomes = biomeHandler.getBiomes();
    float xoffset = int(chunckOffset / chunckNumberSq) * (width / chunckNumberSq);
    float yoffset = (chunckOffset % chunckNumberSq) * (height / chunckNumberSq);
    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        int region = blurredVorMap[i][j];
        float c = finalHeightMap[i][j];
        //int g = biomes[region][1];
        //int b = biomes[region][2];
        fill(c*256);
        noStroke();
        circle((i/chunckNumberSq)+xoffset, (j/chunckNumberSq)+yoffset, 1);
      }
    }
  }
  public void drawNoise(){
    float[][] heightMap = heightNoise.getSequence();
    float xoffset = int(chunckOffset / chunckNumberSq) * (width / chunckNumberSq);
    float yoffset = (chunckOffset % chunckNumberSq) * (height / chunckNumberSq);
    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        fill(heightMap[i][j]*256);
        noStroke();
        circle((i/chunckNumberSq)+xoffset, (j/chunckNumberSq)+yoffset, 1);
      }
    }
  }
  public void drawSmoothNoise(){
    println("drawSmoothNoise");
    float[][] smoothHeightMap = smoothNoise.getSequence();
    float xoffset = int(chunckOffset / chunckNumberSq) * (width / chunckNumberSq);
    float yoffset = (chunckOffset % chunckNumberSq) * (height / chunckNumberSq);
    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        fill(smoothHeightMap[i][j]*256);
        noStroke();
        circle((i/chunckNumberSq)+xoffset, (j/chunckNumberSq)+yoffset, 1);
      }
    }
  }
  public void drawPrecipitationMap(){
    float[][] smoothHeightMap = precipitationMap.getUniformSequence();
    float xoffset = int(chunckOffset / chunckNumberSq) * (width / chunckNumberSq);
    float yoffset = (chunckOffset % chunckNumberSq) * (height / chunckNumberSq);
    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        fill(smoothHeightMap[i][j]*256);
        noStroke();
        circle((i/chunckNumberSq)+xoffset, (j/chunckNumberSq)+yoffset, 1);
      }
    }
  }
  public void drawTemperatureMap(){
    float[][] smoothHeightMap = temperatureMap.getUniformSequence();
    float xoffset = int(chunckOffset / chunckNumberSq) * (width / chunckNumberSq);
    float yoffset = (chunckOffset % chunckNumberSq) * (height / chunckNumberSq);
    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        fill(smoothHeightMap[i][j]*256);
        noStroke();
        circle((i/chunckNumberSq)+xoffset, (j/chunckNumberSq)+yoffset, 1);
      }
    }
  }
  public void drawTheVoronoi(){
    //background(255);
    int xoff = chunckOffset / chunckNumberSq * (width / chunckNumberSq);
    int yoff = chunckOffset % chunckNumberSq * (height / chunckNumberSq);
    vHandler.drawVertcies(3, xoff, yoff);
    vHandler.drawEdges(3, xoff, yoff);
    //vHandler.drawPoints(3, xoff, yoff);
  }
  
}
