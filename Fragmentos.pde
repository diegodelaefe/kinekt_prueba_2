class Fragmento{

  PVector posicion, velocidad, aceleracion, rota, velRot;

  float tamano, crecimiento;

  Fragmento(float posx, float posy){    // - - - - - - - - CONSTRUCTOR

    tamano = 5;
    crecimiento = random(0,.08);
    posicion = new PVector(posx,posy,0);

    velocidad =   new PVector (0                ,   random(-5,0)  ,   0         );
    aceleracion = new PVector (random(-.15,.15) ,   .2           ,   random(0,.1));

    rota = new PVector( 0,0,0 );
    velRot = new PVector( random(-8,8),random(-8,8),0 );
  }

  void actualizar(){                   // - - - - - - - - ACTUALIZAR

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

  void dibujar(){                       // - - - - - - - - DIBUJAR

    pushMatrix();
      translate(posicion.x, posicion.y, posicion.z);
      rotateX(radians(rota.x)); rotateY(radians(rota.y)); rotateZ(radians(rota.z));

      fill(255);
      stroke(0,127);
      box(tamano, tamano, tamano);
    popMatrix();
  }

  boolean fueraDePantalla(){              // - - - - - - - -  FUERA DE PANTALLA

    if(posicion.y > height+tamano){ return true;
    }else{                          return false;}
  }

}