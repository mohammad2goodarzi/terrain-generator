import java.awt.Image;
import java.io.File;
import java.io.IOException;
import java.awt.image.BufferedImage;

import javax.imageio.ImageIO;


public class ImageHandler {
  BufferedImage picture;
  
  public ImageHandler(){ // O(1)
    try {
      this.picture = ImageIO.read(new File("C:\\Users\\WIN10\\Desktop\\pendulum\\processing_terrain_generator\\graph.png"));
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  public int getColor(float x, float y){ // O(1)
    return getColor((int)x, (int)y);
  }
  public int getColor(int x, int y){ // O(1)
    int clr = picture.getRGB(x, y);
    return clr;
  }
  public int getRedColor(int x, int y){ // O(1)
    int clr = getColor(x, y);
    return (clr & 0x00ff0000) >> 16;
  }
  public int getGreenColor(int x, int y){ // O(1)
    int clr = getColor(x, y);
    return (clr & 0x0000ff00) >> 8;
  }
  public int getBlueColor(int x, int y){ // O(1)
    int clr = getColor(x, y);
    return clr & 0x000000ff;
  }
  public int getRedColor(float x, float y){ // O(1)
    return getRedColor((int)x, (int)y);
  }
  public int getGreenColor(float x, float y){ // O(1)
    return getGreenColor((int)x, (int)y);
  }
  public int getBlueColor(float x, float y){ // O(1)
    return getBlueColor((int)x, (int)y);
  }
}
