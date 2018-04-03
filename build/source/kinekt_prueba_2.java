import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import org.openkinect.freenect.*; 
import org.openkinect.processing.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class kinekt_prueba_2 extends PApplet {




Kinect kinect;

int min = 256;
int max = 830;//1536; pa la pieza 830

public void setup() {
  //frameRate(10);
  
  kinectConfig();
}

public void draw() {

  background(0);
  float[][] map = almacenarMapa();
  boolean[][] pix = almacenarMapaBool(500);

  int step = 10;

  for (int x = 0; x < width; x+= step) {
    for (int y = 0; y < height; y+= step) {

      //normaliza valores del mapeo de la kinect (640,480) al tamaño del canvas
      int kx = PApplet.parseInt( map (x, 0, width, 0, map.length)    );
      int ky = PApplet.parseInt( map (y, 0, height, 0, map[0].length));

      float brillo = map( map[kx][ky], min, max, 255, 0);

      fill(brillo, 127);
      rect(x, y, step, step);

      if (pix[kx][ky]) {
          //en caso de q pixel sea mayor que el umbral (activar fragmentos)
      }

    }
  }
}
class Fragmento{

  PVector posicion, velocidad, aceleracion, rota, velRot;

  float tamano, crecimiento;

  Fragmento(float posx, float posy){    // - - - - - - - - CONSTRUCTOR

    tamano = 5;
    crecimiento = random(0,.08f);
    posicion = new PVector(posx,posy,0);

    velocidad =   new PVector (0                ,   random(-5,0)  ,   0         );
    aceleracion = new PVector (random(-.15f,.15f) ,   .2f           ,   random(0,.1f));

    rota = new PVector( 0,0,0 );
    velRot = new PVector( random(-8,8),random(-8,8),0 );
  }

  public void actualizar(){                   // - - - - - - - - ACTUALIZAR

    velocidad.add(aceleracion);
    posicion.add(velocidad);
    tamano += crecimiento;

    if(posicion.x > width || posicion.x < 0){
      velocidad.x *= -1;
      aceleracion.x *= -1;}

    if(posicion.y < 0){
      velocidad.y *= -1;
      aceleracion.y *= -1;
    }
    
    rota.add(velRot);
  }

  public void dibujar(){                       // - - - - - - - - DIBUJAR

    pushMatrix();
      translate(posicion.x, posicion.y, posicion.z);
      rotateX(radians(rota.x)); rotateY(radians(rota.y)); rotateZ(radians(rota.z));

      fill(255);
      stroke(0,127);
      box(tamano, tamano, tamano);
    popMatrix();
  }

  public boolean fueraDePantalla(){              // - - - - - - - -  FUERA DE PANTALLA

    if(posicion.y > height+tamano){ return true;
    }else{                          return false;}
  }

}
public void kinectConfig() { //<>//
  kinect = new Kinect(this);
  kinect.initDepth();
  kinect.enableIR(true);
  kinect.enableMirror(true);
}

public float[][] almacenarMapa() {

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


public boolean[][] almacenarMapaBool(int umbral) {

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

public float[][] almacenarMapaAjustado(int _x, int _y) {

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
      int kx = PApplet.parseInt( map (x, 0, mapaDeProfundidad.length, 0, mapaDeProfundidadNorm.length)    );
      int ky = PApplet.parseInt( map (y, 0, mapaDeProfundidad[0].length, 0, mapaDeProfundidadNorm[0].length));

      mapaDeProfundidadNorm[x][y] = mapaDeProfundidad[kx][ky];
    }
  }

  return mapaDeProfundidadNorm;
}
  public void settings() {  size(800, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "kinekt_prueba_2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
