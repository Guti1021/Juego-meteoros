
import processing.serial.*;

Serial port;

String sensores;

int leer;

ArrayList<PVector> pos = new ArrayList<PVector>();

PImage ciudad;
PImage cielo;
PImage meteoro;
PImage intro;
PImage nave;
PImage nave2;
PFont fuente;
PImage gameOver;

float posX[];
float posY[];


float posLaserX = 500;
float posLaserY = 500;

float x = 10;
float y = 10;

int potenciometro1;
int potenciometro2;

int estado [];
int puntaje = 0;
int puntaje2 = 0;
int scene = 0;
int time;

int disparo = -1;
int velLaser = 100;

int anchoPlayer = 100;
int altoPlayer = 100;

int anchoPlayer2 = 100;
int altoPlayer2 = 100;

float posPlayerX;
float posPlayerY;

float posPlayer2X;
float posPlayer2Y;

float vel;
float distancia = 0;

float mapeado;

void setup()
{
  size(1000,1000);
  port = new Serial(this,"COM3",9600);
  ciudad = loadImage("ciudad.png");
  cielo = loadImage("cielo.jpg");
  meteoro = loadImage("meteoro.png");
  intro = loadImage("intro.jpg");
  nave = loadImage("nave.png");
  nave2 = loadImage("nave2.png");
  gameOver = loadImage("gameOver.jpg");
  fuente = loadFont("Georgia-BoldItalic-48.vlw");
  
  posX = new float [100];
  posY = new float [100];
  estado = new int [100];

  for (int i=0; i<100; i++)
  {
    posX [i]= random (100, 900);
    posY [i]= random (-900, -200);
    estado[i]=1;
  }
}

void draw()
{
  image(cielo,0,0,1000,1000);
  image(ciudad,0,489,1000,519);
  //image(meteoro,20,20,100,100);
  
  
  
  if (mousePressed==true) 
  {
    if (scene==0) {
      scene=1;
    }
  }
  switch(scene)
  {
    //-------------------------------case 0------------------------------------
  case 0:

    image(intro, 0, 0, 1000, 1000);
    
  
    break;

    //-------------------------------case 1------------------------------------
  case 1:
    //image(cielo, 0, 0, 1024, 653);
    
     //Leer potenciometro
 
  if (0 < port.available()) 
  {     
    //otra forma de enviar los datos a processing es no usando serial.write, sino serial.println, sin embargo en processing no se utiliza port.read(), sino port.readStringUntil('\n');
    sensores =  port.readStringUntil('\n');    //mnsaje llega hasta el /n por medio de readStringUntil
        
    if(sensores != null)
    {
      println(sensores);
      //se crea un arreglo que divide los datos y los guarda dentro del arreglo, para dividir los datos se hace con split cuando le llegue el caracter 'T',
      String[] datosSensor = split(sensores,'T');//split = dividir
      
      if(datosSensor.length == 2) // datos que estoy enviando (2 potenciometros)
      {
        println(datosSensor[0]);
        println(datosSensor[1]);
        potenciometro1 = int(trim(datosSensor[0])); // trim = eliminar espacios vacios antes o despues del String / Limpiar el dato
        potenciometro2 = int(trim(datosSensor[1]));
        println(potenciometro1);
        println(potenciometro2);
      }     
    }
    
    posPlayerX = map(potenciometro1,0,1023,0,900);
    posPlayer2X = map(potenciometro2,0,1023,0,900);
  }
  
  /*if(0 < port.available())
  {
   leer = port.read();
   println(leer);
  }
  
  mapeado = map (leer,0,255,0,768);
  
  posPlayerX = mapeado;
  posPlayerY = mapeado;*/
    
    //Nave mouse
  
   
   
   image(nave,posPlayerX,850,anchoPlayer,altoPlayer);
   
  
  if(x > 0 && x < anchoPlayer)
  {
    if(y >= posPlayerY && y <= posPlayerY + altoPlayer)
    {
      disparo = disparo * -1;
    }
  }
    
    image(nave2,posPlayer2X,850,anchoPlayer2,altoPlayer2);
    
    //Disparo
  
  disparo();
  
  /*if(posLaserY<0)
  {
   disparo = disparo * -1; 
  }*/

    // posocion meteoros
  for (int i=0; i<100; i++)
  {
    if (estado [i]==1) 
    {

      image (meteoro, posX[i], posY[i], 100, 100);
    }
  }
    // velocidad meteoros
    for (int i=0; i<100; i++) 
  {

    vel=random(1, 5);
    posY[i] = posY [i]+vel;
  }
   // puntaje del  juego
  fill (244, 23, 24);
  text("Puntaje: "+puntaje, 30, 40);
  

puntaje=0;
  for (int i=0; i<100; i++) 
  {
    if (estado [i]==0)
    {
      puntaje++;
    }
  }
  //tiempo
  time = millis ()/1000;
  textFont(fuente, 30);
  text ("Tiempo: " + time, 800,40);
  
  
  
  break;
  }
  
  // posocion meteoros
  /*for (int i=0; i<20; i++)
  {
    if (estado [i]==1) 
    {

      image (meteoro, posX[i], posY[i], 100, 100);
    }
  }*/
  
  // velocidad meteoros
  /*for (int i=0; i<20; i++) 
  {

    vel=random(0.5, 1);// 5;
    posY[i] = posY [i]+vel;
  }*/
  
  // destruir meteoros
  
    
  for (int i=0; i<100; i++)
  {
    if (mousePressed == true)
    {
      //distancia = dist(mouseX, mouseY, posX[i], posY[i]);
      //if (distancia <= 50)
      distancia = dist(posLaserX, posLaserY, posX[i], posY[i]);
      if (distancia <= 200)
      {
        estado [i] = 0;
      }
    }
  }
  //Game Over
  if(time >= 20){
  image(gameOver,0,0,1100,1100);
}

 
}

void mousePressed(){
  pos.add( new PVector(posPlayerX+50, 950, 0) );
  pos.add( new PVector(posPlayer2X+50, 950, 0) );
}

void disparo(){
  stroke(0, 0, 800);
  strokeWeight(20);
  for ( int i = 0; i < pos.size(); i++ ) {
    pos.get(i).y -= velLaser;
    point(pos.get(i).x, pos.get(i).y);
  }
  for ( int i = pos.size()-1; i >=0; i-- ) { //___ cleanup
    if ( pos.get(i).y > width ) {
      pos.remove(i);
      println("long "+pos.size()+" removed "+i);
    }
  }
}
