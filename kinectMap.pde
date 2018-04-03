void kinectConfig() { //<>//
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.enableIR(true);
  kinect.enableMirror(true);
}
 
float[][] almacenarMapa() {

  float[][] mapaDeProfundidad = new float [kinect.width][kinect.height];
  PImage deepimg;
  int[] rawDepth;

  deepimg = kinect.getDepthImage();
  rawDepth = kinect.getRawDepth();

  for (int x = 0; x < deepimg.width; x++) {
    for ( int y = 0; y < deepimg.height; y++) {
      mapaDeProfundidad[x][y] = rawDepth[x+y*deepimg.width];
    }
  }

  return mapaDeProfundidad;
}


boolean[][] almacenarMapaBool(int umbral) {

  boolean[][] mapaDeProfundidad = new boolean [kinect.width][kinect.height];
  PImage deepimg;
  int[] rawDepth;

  deepimg = kinect.getDepthImage();
  rawDepth = kinect.getRawDepth();

  for (int x = 0; x < deepimg.width; x++) {
    for ( int y = 0; y < deepimg.height; y++) {
      boolean condicion = umbral > rawDepth[x+y*deepimg.width] ;
      if (condicion) {
        mapaDeProfundidad[x][y] = true;
      } else {
        mapaDeProfundidad[x][y] = false;
      }
    }
  }

  return mapaDeProfundidad;
}

float[][] almacenarMapaAjustado(int _x, int _y) {

  float[][] mapaDeProfundidad = new float [kinect.width][kinect.height];
  float[][] mapaDeProfundidadNorm = new float [width/_x][height/_y];

  PImage deepimg;
  int[] rawDepth;

  deepimg = kinect.getDepthImage();
  rawDepth = kinect.getRawDepth();

  for (int x = 0; x < deepimg.width; x++) {
    for ( int y = 0; y < deepimg.height; y++) {
      mapaDeProfundidad[x][y] = rawDepth[x+y*deepimg.width];
    }
  }

  for (int x = 0; x < mapaDeProfundidad.length; x++) {

    for (int y = 0; y < mapaDeProfundidad[0].length; y++) {
      //normaliza valores del mapeo de la kinect (640,480) al tamaño del canvas
      int kx = int( map (x, 0, mapaDeProfundidad.length, 0, mapaDeProfundidadNorm.length)    );
      int ky = int( map (y, 0, mapaDeProfundidad[0].length, 0, mapaDeProfundidadNorm[0].length));

      mapaDeProfundidadNorm[x][y] = mapaDeProfundidad[kx][ky];
    }
  }

  return mapaDeProfundidadNorm;
}
