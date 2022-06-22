class PerlinNoise{
  private float[][] sequence;
  private float[][] uniformSequence;
  
  public PerlinNoise(float xoff, float yoff, float increment, int seed){ // O(width*height)
    noiseSeed(seed);
    sequence = new float[width][height];
    for(int i = 0; i < width; i++){
      xoff += increment;
      for(int j = 0; j < height; j++){
        yoff += increment;
        sequence[i][j] = noise(xoff, yoff);
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
