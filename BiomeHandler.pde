class BiomeHandler{
  int pointsNumber;
  int[][] biomes;
  
  public BiomeHandler(int pointsNumber){
    this.pointsNumber = pointsNumber;
  }
  
  public void calculateBiome(ImageHandler handler, float[][] uniformTemperatureMap, float[][] uniformPrecipitationMap, int[][] blurredVorMap){
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
    biomes = new int[pointsNumber][3];
    for(int i = 0; i < pointsNumber; i++){
      temperatureSum[i] = temperatureSum[i] / count[i];
      precipitationSum[i] = precipitationSum[i] / count[i];
      biomes[i][0] = handler.getRedColor(map(precipitationSum[i], 0, 1, 0, 512), map(temperatureSum[i], 0, 1, 0, 512));
      biomes[i][1] = handler.getGreenColor(map(precipitationSum[i], 0, 1, 0, 512), map(temperatureSum[i], 0, 1, 0, 512));
      biomes[i][2] = handler.getBlueColor(map(precipitationSum[i], 0, 1, 0, 512), map(temperatureSum[i], 0, 1, 0, 512));
    }
  }
  
  public int[][] getBiomes(){
    return biomes;
  }
}
