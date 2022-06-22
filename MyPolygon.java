import java.awt.Polygon;


public class MyPolygon extends Polygon {
  int[][] blurredList = new int[100][2];
  int counter = 0;
  
  public MyPolygon(int[] xpoints, int[] ypoints, int npoints) {
    super(xpoints, ypoints, npoints);
  }
  public MyPolygon() {
    super();
  }
  
  public void addBlurredPoint(int x, int y){
    blurredList[counter][0] = x;
    blurredList[counter][1] = y;
    counter++;
  }
  
  public boolean contains(int x, int y) {
    boolean result1 = super.contains(x, y);
    for(int i = 0; i < counter; i++)
    {
      if(blurredList[i][0] == x && blurredList[i][1] == y)
      {
        return true;
      }
    }
    return result1;
  }
}
