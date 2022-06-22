class PerlinNoise{
  private float[][] sequence;
  private float[][] uniformSequence;
  
  public PerlinNoise(float xoff, float yoff, float increment, int seed){ // O(width*height)
    generateNoise(xoff, yoff, increment, seed, 4, 0.5);
  }
    
  public PerlinNoise(float xoff, float yoff, float increment, int seed, int lod, float falloff){ // O(width*height)
    generateNoise(xoff, yoff, increment, seed, lod, falloff);
  }
  
  private void generateNoise(float xoff, float yoff, float increment, int seed, int lod, float falloff){
    noiseSeed(seed);
    sequence = new float[width][height];
    for(int i = 0; i < width; i++){
      xoff += increment;
      float theyoff = yoff;
      for(int j = 0; j < height; j++){
        theyoff += increment;
        sequence[i][j] = noise(xoff, theyoff);
      }
    }
  }
  
  void makeThisUniform(float alpha){ // O(width*height)
    uniformSequence = new float[width][height];
    float[] maximums = new float[sequence.length];
    float[] minimums = new float[sequence.length];
    for(int i = 0; i < width; i++){
      maximums[i] = max(sequence[i]);
      minimums[i] = min(sequence[i]);
    }
    for(int i = 0; i < width; i++){
      for(int j = 0; j < height; j++){
        uniformSequence[i][j] = map(sequence[i][j], min(minimums), max(maximums), 0, 1);
      }
    }
  }
  
  public float[][] getSequence(){
    return sequence;
  }  

  public float[][] getUniformSequence(){
    return uniformSequence;
  }
}
