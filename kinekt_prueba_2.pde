import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

int min = 256;
int max = 830;//1536; pa la pieza 830

void setup() {
  //frameRate(10);
  //size(1500, 1200);
  fullScreen(P3D);
  kinectConfig();
}

void draw() {

  background(0);
  // fill(0,200);
  // rect(0,0,width,height);
  lights();
  float[][] map = almacenarMapa();
  boolean[][] pix = almacenarMapaBool(max);

  float lastX=0,lastY=0;
  int step = 10;
  boolean distancia;

  for (int x = 0; x < width; x+= step) {
    for (int y = 0; y < height; y+= step) {

      //normaliza valores del mapeo de la kinect (640,480) al tamaño del canvas
      int kx = int( map (x, 0, width, 0, map.length)    );
      int ky = int( map (y, 0, height, 0, map[0].length));

      float brillo = map( map[kx][ky], min, max, 255, 0);

      fill(brillo);
      noStroke();

      if (pix[kx][ky]) {
        float z = map( map[kx][ky], 0, max, 0,-400 )+400;
        pushMatrix();
        translate(x,y,z);
        stroke(255);
        point(0,0);
        popMatrix();//en caso de q pixel sea mayor que el umbral (activar fragmentos)
      }
    }
  }

}
