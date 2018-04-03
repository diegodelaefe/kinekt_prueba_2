import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

int min = 256;
int max = 830;//1536; pa la pieza 830

void setup() {
  //frameRate(10);
  size(800, 600);
  kinectConfig();
}

void draw() {
 
  background(0);
  float[][] map = almacenarMapa();
  boolean[][] pix = almacenarMapaBool(500);

  int step = 10;

  for (int x = 0; x < width; x+= step) {
    for (int y = 0; y < height; y+= step) {

      //normaliza valores del mapeo de la kinect (640,480) al tamaño del canvas
      int kx = int( map (x, 0, width, 0, map.length)    );
      int ky = int( map (y, 0, height, 0, map[0].length));

      float brillo = map( map[kx][ky], min, max, 255, 0);

      fill(brillo, 127);
      rect(x, y, step, step);

      if (pix[kx][ky]) {
          //en caso de q pixel sea mayor que el umbral (activar fragmentos)
      }

    }
  }
}
